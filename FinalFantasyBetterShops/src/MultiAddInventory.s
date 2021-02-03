; MultiAddInventory.s
; Routines and notes for handling adding multiple items when buying in shops.

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
