# Final Fantasy: Better Shops Hack

## Overview
This is a "quality of life" hack to modify the game to make it easier to buy
multiple consumable items (e.g. HEAL, PURE, etc.) at once when shopping. In this
repository you can find the 6502 assembly source for the changes and routines I
wrote for the hack along with supplementary data I used when making the hack.

### Generating a ROM
TODO: Write me

### Folders & Files

* `rom/` - FCEUX files for the Final Fantasy (US) ROM I used for the hack. The
ROM file itself is not provided by this repository. If you place your own copy
of the ROM in this directory and load it in FCEUX you should be able to see all
of my labels / notes / etc. in the debugger.
* `src/` - The 6502 assembly source for the project. I broke this into sections
based on the functional use of the source.
* `devnotes.md` - My original notes that I kept while I was doing the hack, most
of the information here has been compiled into this readme.
* `item-ids.csv` - A partial list of the item index ids for all items in the
Final Fantasy game. I started the list for fun, but have yet to finish it.


## Datasheet
In this section I've listed some technical details about the cart, ROM, game
code, and hack code used in the project. I used it as my primary reference when
working on the hack.

### Board & ROM
![Image of Final Fantasy Board](./Board.png)

- **Board:** [SxROM]() (`SNROM`, `NES-SNROM-05`)
- **Mapper:** [MMC1]() (`MMC1B2`)
- **CPU $8000-$BFFF:** 16 KB PRG ROM bank, **SWITCHABLE**
- **CPU $C000-$FFFF:** 16 KB PRG ROM bank, **FIXED TO LAST BANK** (`$0F`)

### RAM Locations
The following are important RAM locations for the hack:

Address | Size | Label                | Purpose
--------|------|----------------------|-----------------------------------------
`$20`   | 1    | `JoyOneMask`         | Bitmask for joypad button states
`$45`   | 1    | `ShopId`             | Id of the current shop
`$54`   | 2    | `VramAddressWrite`   | Address for nametable updates
`$62`   | 1    | `MenuCursorIndex`    | Selected menu option index (general)
`$0300` | 5    | `ShopItemIds`        | A list of item ids sold in the shop
`$030C` | 1    | `ShopItemId`         | ID of the currently select shop item
`$030E` | 2    | `ShopItemPrice`      | 16-bit price for the selected shop item
`$6020` | *    | `InventoryQtyTable`  | Party inventory quantity lookup offset
`$601C` | 3    | `Gold`               | Party gold total

#### Shop Menu State
There does not appear to be a direct state varible stored for which menu is
currently active in a shop. But the high byte of the `VramAddressWrite` variable
does change in a predictable way based on which menu the player is in.

In particular, the `$54` memory location changes as such with the menus:

Value | Shop State          | Menu Options
------|---------------------|---------------------------------------------------
`CB`  | Shop Action Menu    | Buy / Exit
`26`  | Item Selection Menu | Items based on values in $0300 - $0304
`C9`  | Confirm Buy Menu    | Yes / No

#### ZeroPage Temporary Memory
The zero page addresses from `$00` to `$0D` do not appear to be used when in the
shopping code. To implement the new functionality, I use them as temporary state
while shopping.

Address | Purpose
--------|-----------------------------------------------------------------------
`$00`   | Return Bank
`$01`   | Hack Routine Index
`$02`   | Hack Routine Address Lo-byte, binary search memo (left)
`$03`   | Hack Routine Address Hi-byte, binary search memo (right)
`$04`   | Item Quantity
`$05`   | Gold Total (Byte-0)
`$06`   | Gold Total (Byte-1)
`$07`   | Gold Total (Byte-2)
`$08`   | Item Price Memo (lo-byte), Quantity BCD (d0-d1)
`$09`   | Item Price Memo (hi-byte), Re-render Flag (bit 7)
`$0A`   | Gold BCD (D0-1)
`$0B`   | Gold BCD (D2-3)
`$0C`   | Gold BCD (D4-5)
`$0D`   | Max Quantity for Selected Item

### The Great Void (Bank $06)

* **Bank:** `$06`
* **Start Address:**  `$01ACB0` (CPU: `$ACA0`)
* **End Address:**    `$01C00F` (CPU: `$BFFF`)
* **Length (bytes):** `4960`    (~4.84KB!!!)

The "great void" is a region at the end of bank 6 that is a massive sea of 0s
that seems to be entirely unused. It is the only very large contiguous region to
be found in the Final Fantasy ROM, as far as I can tell.

> Initially I tried to inject the modifications into nooks and crannies found
> throughout the `$0E` and `$0F` banks. The routine for performing the total
> calculation forced my hand, though, since it was reasonably large (well over
> 40 bytes) and I didn't have a place I could easly put it while keeping the
> code continguous. Assuming there might be a better spot for all this, I found
> the void while doing a survey across all the ROM banks.


### Code Injection / Hook Locations

#### Indexed Hack Methods (Head)
The routines at the head of the void are the indexed hack methods that can be
easily accessed from outside Bank `$06` via the `callHackXX` methods. Here's an
example of how the `cleanupZeroPage` hack method can be called from bank `$0E`:

```
lda #$00
jsr callHack0E
```

Below is a list of the methods and their indices:

 CPU       | ROM      | Hack Index | Routine
-----------|----------|------------|--------------------------------------------
`$ACA0`    | `01ACB0` | --         | hackMethodAddressTable (lookup table)
`$AD00`    | `01AD10` | --         | executeHack (master hack executor)
`$AD20`    | `01AD30` | 0          | cleanupZeroPage
`$AD30`    | `01AD40` | 1          | initializePriceQuantity
`$AD60`    | `01AD70` | 2          | changeQuantity
`$AD90`    | `01ADA0` | 3          | renderQuantityAndTotal
`$AE60`    | `01AE70` | 4          | buyItems

#### Helpers / Subroutines
At the tail of the void we place various helpers and subroutines. This is mostly
to make it easier to add functionality to the indexed routines without having to
rearrange them too often (this is a pain cause we used indirect addressing to
index them so as to reduce the total number of bytes required to call a hack
method).

Below is a table of the routines and their locations:

 CPU       | ROM      | Routine
-----------|----------|---------------------------------------------------------
`$BF90`    | `01BFA0` | `calculateTotal`
`$BF80`    | `01BF90` | `isConsumable`
`$BF50`    | `01BF60` | `quantityToBCD`
`$BF20`    | `01BF30` | `updateShopState`
`$BED0`    | `01BEE0` | `incrementQuantity`
`$BEB0`    | `01BEC0` | `cmpTotalToGold`
`$BE80`    | `01BE90` | `decrementQuantity`
`$BE20`    | `01BE30` | `totalToBCD`
`$BDA0`    | `01BDB0` | `calculateBuyMaximum`

#### Event Hooks

##### Bank $0E
Used? | BANK | CPU RAM | ROM     | Length (Used)  | Notes
------|------|---------|---------|----------------|----------------------
[x]   | $0E  | $AD19   | $03AD29 | 22             | OnBuy
[x]   | $0E  | $84E3   | $0384F3 | 28             | OnQuantityChange
--    | $0E  | $84EB   | $0384FB | --             | OnVblank
[x]   | $0E  | $8469   | $038479 | 22             | OnShopExit
[x]   | $0E  | $82F5   | $038305 | 10             | callHack0E

##### Bank $0F (Fixed Bank)
Used? | BANK | CPU RAM | ROM     | Length (Used)  | Notes
------|------|---------|---------|----------------|----------------------
[x]   | $0F  | $FF82   | $03FF91 | 13 (8)         | swapAndJumpToHack
[x]   | $0F  | $FDF2   | $03FE02 | 13 (13)        | callHack
[ ]   | $0F  | $FFCD   | $03FFDD | 17             |
[ ]   | $0F  | $FFB9   | $03FFC9 | 7              |
[ ]   | $0F  | $FFA4   | $03FFB4 | 4              |
[ ]   | $0F  | $FF3C   | $03FF4C | 4              |

## License
MIT
