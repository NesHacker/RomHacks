# Final Fantasy ROM Notes

## Store Item Memory
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


## Store Menu Logic
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

--------------------------------------------------------------------------------------------------------------------------------------------------------

; Hack injection JSR
20 19 AD 		; JSR $AD20

; Double increment item in inventory as a test of hacking in a new routine
FE 20 60		; INC $6020,X
FE 20 60 		; INC $6020,X
60			; RTS

; Multi-buy Routine (Suuupaa Haakka)
A4 01			; LDY $01
F0 07			; BEQ +7
FE 20 60		; INC $6020,X
88			; DEY
D0 FA			; BNE -4
60 			; RTS

; Safe Multi-buy Routine (Inject: $AD19)
; Assumes $01 contains the number of items being bought
48			; PHA
98			; TYA
48			; PHA
A4 01			; LDY $01
F0 06			; BEQ +6
FE 20 60		; INC $6020,X
88			; DEY
D0 FA			; BNE -4
A9 00 		; LDA #$00
85 01			; STA $01
68			; PLA
A8			; TAY
68			; PLA
60 			; RTS

; Fast Multi-buy with Boundary Checking (Inject: $AD19)
; - Assumes $01 contains the number of items being bought
; - Assumes $01 + $60XX <= 99 (needs to be handled by the qty select hook)
48			; PHA
BD 20 60 		; LDA $6020,X
18 			; CLC
65 01			; ADC $01
9D 20 60		; STA $6020,X
68			; PLA
60 			; RTS

--------------------------------------------------------------------------------------------------------------------------------------------------------

; Increment Item quantity w/ boundary & item type checking (Inject: ???)

PHA
LDA #$1C
CMP $030C
BCC +? // (SKIP direct set of qty to 1)
LDA #$01
STA $01
BCS +? // (GOTO end of routine)\
LDA $6020,X
CLC
ADC $01
CMP #$63
BCS +2
INC $01
PLA
RTS


; TODO: Need to hook this in on shop leave to clean up the zero page (just in case)
A9 00 		; LDA #$00
85 01			; STA $01

; TODO: Need to skip


--------------------------------------------------------------------------------------------------------------------------------------------------------

Item code	Item
16		Tent
17		Cabin
18		House
19		Heal
1A		Pure
1B		Soft

1C		Wooden Nunchaku
1D		Small Knife
1E		Wooden Staff
1F		Rapier
20		Iron Hammer
21		Short Sword
22		Hand Axe
23		Scimitar
24		Iron Nunchaku
25		Large Knife
26		Iron Staff
27		Sabre
28		Long Sword
29		Great Axe
2A		Falchon
2B		Silver Knife
2C		Silver Sword
2D		Silver Hammer
2E		Silver Axe
2F		Flame Sword
30		Ice Sword
31		Dragon Sweord
32		Giant Sword
33		Sun Sword
34		Coral Sword
35		Were Sword
36		Rune Sword
37		Power Staff
38		Light Axe
39		Heal Staff
3A		Mage Staff
3B		Defense
3C		Wizard Staff
3D		Vorpal
3E		CatClaw
3F		Thor's Hammer
40		Bane Sword
41		Katana
42		Xcalber
43		Masmune

44		Cloth
45		Wooden Armor



