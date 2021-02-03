# Final Fantasy ROM Notes

; TODO: Need to hook this in on shop leave to clean up the zero page (just in case)
A9 00 		; LDA #$00
85 01			; STA $01

; TODO: Need to skip

## Hack Overview
- [x] Determine Board, Mapper, and ROM Information
  - Messed with the mapper a bit, but I just opened the cart and took a photo
  - Board: `NES-SNROM-05` (SxROM, SNROM)
  - Mapper: `MMC1B2`
  - CPU $8000-$BFFF: 16 KB PRG ROM bank, **SWITCHABLE**
  - CPU $C000-$FFFF: 16 KB PRG ROM bank, **FIXED TO LAST BANK** (`$0F`)
- [x] Determine memory locations for gold and inventory item quantities.
  - Both of these are in PRG-RAM
  - `$601C-$601D` - Party Gold
  - `$6036-$603B` - Consumable inventory item quantities


## The Hack Plan
1. Use $00 - $09 as temporary state, it's not touched in shops
2. [x] Routine: Cleanup state on shop exit (zero-fill)
3. [ ] Routine: Compute Gold Cost, Gold = Qty x Item Price
4. [ ] Routine: Inc/Dec Qty using left and right d-pad inputs
5. [ ] Routine: Display selected quantity
6. [x] Routine: Multi-add items on buy based on chosen quantity

## Subroutine Injection Locations
Below is a list of locations I've found for injecting routines along with the
number of bytes supported by each spot.

Used? | BANK | CPU RAM | ROM     | Length (Used)  | Notes
------|------|---------|---------|----------------|----------------------
[ ]   | $0F  | $FFCD   | $03FFDD | 17             |
[ ]   | $0F  | $FFB9   | $03FFC9 | 7              |
[ ]   | $0F  | $FFA4   | $03FFB4 | 4              |
[ ]   | $0F  | $FF81   | $03FF91 | 15             |
[ ]   | $0F  | $FF3C   | $03FF4C | 4              |
[ ]   | $0F  | $FDF2   | $03FE02 | 13             |
[x]   | $0E  | $BFEF   | $03BFFF | 15 (15)        | On Exit Routine
[ ]   | $0E  | $AD19   | $03AD29 | 22             |
[ ]   | $0E  | $84E3   | $0384F3 | 28             |
[ ]   | $0E  | $8469   | $038479 | 22             | Looks like $FF padding
[ ]   | $0E  | $82F5   | $038305 | 10             |


## Hacking Notes

### Store Item Memory
$45	Store Index
>	This appears to determine the type of store and what it sells when entering
>	a shop from any town map. These appear to be valid item shop values:
>	3d, 3f, 40, 41, 42

Looks like $45 gets copied to $51 for some reason

$83A6	What's here? We just copied 4 bytes at this offset to $300 - $303

So what appears to happen, is the store index is used to grab item id offsets from
a lookup table somewhere around $83A6. These values are then copied into the
$300 - $304 memory locations. You can change these to change what a store sells.

So it looks like the code for item stores differs from that of weapon stores and armor
shops. You can hack the memory to add a weapon into any of the 5 item slots for the
store, but if you buy a weapon from the item shop it will show up in the items menu.
Further, if you try to use, say... the Masamune from the items menu the game appears
to crash.

It does seem to be possible to buy 4 Masamune and equip them no problem however,
but you must do so from a weapon shop.

### Store Menu Logic
When 'a' is pressed on a menu the program does come fairly convoluted logic checking
bouncing a "modified" value for the controller mask into A via TXA and checking the high
bit to determine which button was pressed (going through checks for #$10, #$20, #$40,
and finally #$80).

When it detects that the "a" button has been pressed, it increments $24, then grabs the
value of $21, EORs it with #$80 and stores it back into $21 (why it does this is quite beyond
me). At this point it returns from two nested subroutines and then jumps into APU code
which I believe probably queues up the sound for the button press on the menu.

At this point it breaks back out into the cursor movement code where it checks to see if
$24 has been incremented. It then, hilariously, clears the carry bit, BCCs to a bit of code
that zeros out $24, $25, and $22, then RTS the hell out.

So the CLC wasn't an accident, it needs to be cleared later at $A484 otherwise there is
a side effect (it nopes out of further logic and just exits the subroutine). Also, the CLC
followed by the BCC is actually 2 cycles faster since we need to clear the carry bit anyway
(at first glance it looks funny, but it now makes a lot of sense).

The program then checks the cursor index ($62) and if it's not zero, it RTS. Otherwise it
jumps into two subsequent subroutines: $AA5B and then $A8C2. The first routine leads
to a very convoluted series of jumps and deeper routines eventually leading to a bank
swap. It's a bit too hard to keep track of things from here.

I tried setting a breakpoint to see when $21 is read next, but it doesn't seem to be read
at all prior to the transition. It's eventually written over with #$09 and the trail goes cold :(

### On Item Selection

When you press 'a' to select an item to buy the routine does the following

1. Load the cursor index ($62) into A
2. Left shift the value 3 times
3. Add #$15 (#21) and store it into $3E

This would be the same as multiplying the index by 8 and adding 21.
`$3E <- (($62 << 3) + 21) == $3E <- cursorIndex * 8 + 21`

Seems to indicate that there is a region in RAM that's offset by 21 bytes where
information about the items loaded for the store are held. Each item has 8 bytes
of information (thus 8 times the cursor index + 21 byte offset).

Next, we clear the carry flag, add 2 to the result and transfer it to the X
register. So at this point `X = (cursorIndex * x + 21) + 2`. So the next bit of
code seems to make this clear:

```
0E:AA78: A9 00     LDA #$00     ; Zero-out $0300 + X
0E:AA7A: 9D 00 03  STA $0300,X
0E:AA7D: CA        DEX
0E:AA7E: BD 00 03  LDA $0300,X  ; Store value at $0300 + X to $030C
0E:AA81: 8D 0C 03  STA $030C
```

`$030C` is the shop item index for the selected item, so this is how it's being
copied into place upon selection.

Yeah, this is all starting to make alot more sense. I'm pretty sure
that $03XX is used as general purpose state for various parts of the game. In this case
it holds state related to the shop, and what items are being sold. I think with a bit
more prying I should be able to determine the exact byte layout for each of the items
being sold. At that point we have all the info we need to make the gold value injection
routine.

Also $3E-$3F is holding the lo-byte and hi-byte of an address: $0315 (for cursor index 0)
upon item selection. My guess is that $0315 is the start of where data for the items are
being stored.

The bytes in memory at this point starting at $0315 and assuming a 8-byte record struct
can be arranged as follows for the 3 items in the first item shop:

```
03 19 00 02 1A 01 FF FF
03 1A 01 02 16 01 FF FF
03 16 01 00 00 00 00 FF
```

Not sure how to interpret this, exactly, but the item ids are definite at the
index + 1 as 19 is HEAL, 1A is PURE, and 16 is TENT according to my item id
notes. I was hoping to see the prices here as well or something, but doesn't
look like they have been loaded into this part of the ram.

#### Subroutine: $ECB9
AHA! I figured out what this routine is doing. It's a function that, given an
item index in the accumulator, will write the PRICE for the item into $10-$11!
Apparently the price information for these items is on bank 13. HA!

##### $ECB9 Routine Overview
1. Set `$12-$13` to an indirect address based on the item index (this is the item price)
2. Bank switch to `$0D` (this is where the item price information is)
3. Copy the values at $BC32-$BC33 to $10-$11 (`$3C` and `$00`, or 60 gold)
4. Zero-fill $12 (new address is maybe $BC00?, possibly just cleanup?)
5. Bank switch to `$0E` and return

##### Detailed Notes

The program then jumps into a subroutine located at `$ECB9`, here's what it
does:

0. On entry `A` holds the item index (in this case `$19` for HEAL)
1. `$12 <- A << 1` (`$12` now equals `#$32`)
2. `$13 <- $BC` (if carry clear), `$13 <- $BD` (if carry set)

This forms an indirect addres at `$12-$13`, which for the HEAL item index
gives us an absolute address of `$BC32`.

We then then set `A = #$0D` and jump into a subroutine at `$FE03`, which then
immediately jumps to `$FE1A`. This swaps the PRG-ROM bank to whatever is
currently in the accumlator (in this case `$0D` or bank 13).

I ran throught he swap to see what bank is fixed, and after it executed it was
clear that *the lower 16KB PRG-ROM bank is the swappable one*! This was something
I didn't know yet, so it's rad we figured that out while doing something else.

The program then proceeds to write the contents of $BC32-$BC33 to $10-$11
resulting in `$10 = #$3C` and `$11 = #$00`.

Next it zero-fills the value at `$12` which might mean we're grabbing something
at `$BC00` or it could mean that `$12` is now being used as some other form of
state...

It then loads `A = $0E` and initiates a bank switch by jumping to `$FE03`. This
pops us out of the routine and back to where we originally entered, but now with
the lower prg-rom bank set to `$0E` (bank 14).


### Tracing the Exit Code

- Bank `$0E` seems to be loaded when you're in a store
- Looks like `$62` being set to 1 determines if we "leave" the shop on A press
- `$62` gets set as a result of moving the cursor, but only on the first menu...
