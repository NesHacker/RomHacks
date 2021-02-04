; OnBuy.s
; Routines and notes for handling adding multiple items when buying in shops.


; 0E:A4BF: FE 20 60  INC $6020,X @ $6080 = #$04
; 0E:A4C2: 20 CD A4  JSR $A4CD Remove Gold for Item
; 0E:A4C5: A9 13     LDA #$13
; 0E:A4C7: 20 5B AA  JSR $AA5B
; 0E:A4CA: 4C 81 A4  JMP $A481
; Remove Gold for Item:
; 0E:A4CD: AD 1C 60  LDA $601C = #$FF
; 0E:A4D0: 38        SEC
; 0E:A4D1: E5 02     SBC $02 = #$00
; 0E:A4D3: EA        NOP
; 0E:A4D4: 8D 1C 60  STA $601C = #$FF
; 0E:A4D7: AD 1D 60  LDA $601D = #$FF
; 0E:A4DA: E5 03     SBC $03 = #$00
; 0E:A4DC: EA        NOP
; 0E:A4DD: 8D 1D 60  STA $601D = #$FF
; 0E:A4E0: AD 1E 60  LDA $601E = #$0F
; 0E:A4E3: E9 00     SBC #$00
; 0E:A4E5: 8D 1E 60  STA $601E = #$0F
; OnInventoryAdd (END):
; 0E:A4E8: 4C EF A7  JMP $A7EF






; RemoveGoldForItems.s
; Hacks to remove the correct amount of gold for multiple items.

; TODO: This needs to be updated for 3 byte subtractions

; Every time the quantity to buy changes we recalculate the cost and store it
; in the zero page memory at $02-$03. So all we need to do to correctly remove
; the gold is replace the subtraction instructions to reference the zero page
; as opposed to the main memory where the item price is stored.

; [REPLACE] 0E:A4D1: ED 0E 03  SBC $030E
sbc $02         ; E5 02
nop             ; EA

; [REPLACE] 0E:A4DA: ED 0F 03  SBC $030F
sbc $03         ; E5 03
nop             ; EA



;
; JSR Replacement @ $A4BF (ROM: $03A4CF)
;
; Normally the game runs a simple `inc $6020, x` here, we override the three
; bytes and jump into our own subroutine to handle adding multiple items instead
; of just one.
;
jsr $84E3         ; 20 E3 84

; Fast Multi-Add
; Injected: 0E:84E3 - 0E:84EE (12 bytes)
;
; This is probably as good as it gets when it comes to size of the code and
; speed of execution. Instead of repeatedly performing increments we simply use
; the ADC instruction to directly add tot he memory location holding the
; number of items in the player's inventory.
;
; That said, we need to do some work elsewhere in the hack to ensure this can
; be safely executed. Specifically we make two assumptions:
;
; 1. $01 will be cleaned up elsewhere
; The first assumption seems easy enough, just need to inject some code during
; the shop exit routine.
;
; 2. Value($01) + Value($6020,x) <= 99
; The second is paramount, so we will need to take care to ensure that the
; boundry checking is done correctly when inc/dec the user controlled quantity
; elsewhere. Othewrwise we could run into issues where the player can have over
; 99 heals or in the worst case can overflow and end up with less items than
; before they bought more.
;
; 3. This routine will never attempt to buy more than 1 non-consumable
; Finally, we will need to ensure that the routine will never actually buy more
; than one non-consumable item. The game can get weird if you end up buying
; non-consumable items. I think this should work out fine, afaik the game has
; different logic for buying non-consumable items, so hopefully we don't even
; execute this code in that case. Testing will be required to find out, though.
;
pha               ; 48
lda $6020, x      ; BD 20 60
clc               ; 18
adc $01           ; 65 01
sta $6020, x      ; 9D 20 60
pla               ; 68
rts               ; 60
