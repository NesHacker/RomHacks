; MultiAddInventory.s
; Routines and notes for handling adding multiple items based on selected quantity.

;
; JSR Replacement @ $A4BF (ROM: $03A4CF)
;
; Normally the game runs a simple `inc $6020, x` here, we override the three
; bytes and jump into our own subroutine to handle adding multiple items instead
; of just one.
;
jsr $AD19         ; 20 19 AD

; All of the routines below should be injected into the rom at $AD19 (ROM: $03AD29)

;
; Test: Double increment
;
; This was my first test just to ensure I got the code injectected and working
; properly. It simply increments the count for the number of items of the type
; being bough twice then returns.
;
inc $6020, x      ; FE 20 60
inc $6020, x      ; FE 20 60
rts               ; 60

;
; Test: Multi-add Based on Quantity State
;
; Assuming that the quantity being bought is stored at $01, this routine handles
; a parameterized multi-add. It's pretty unsafe because we are using the Y
; register and it is unknown if that register is currently holding important
; state.
;
ldy $01           ; A4 01
beq +7            ; F0 07
inc $6020, x      ; FE 20 60
dey               ; 88
bne -4            ; D0 FA
rts               ; 60

;
; Safe Multi-add
;
; An improvment over the previous routine. Here we add some safety to the code
; by pushing the accumulator and the Y register to the stack prior to changing
; their values. We also "zero-out" the state for the quantity at $01. Finally,
; at the end, we pop the A and Y values off the stack and then return.
;
; This is a very safe, but also very long and slow way to do all this. The
; "Absolute, X" addressing mode for the INC operation alone takes 6 cycles to
; each time it is called (potentially 99 times, which is 594 cycles total, lol).
;
pha               ; 48
tya               ; 98
pha               ; 48
ldy $01           ; A4 01
beq +6            ; F0 06
inc $6020, x      ; FE 20 60
dey               ; 88
bne -4            ; D0 FA
lda #0            ; A9 00
sta $01           ; 85 01
pla               ; 68
tay               ; A8
pla               ; 68
rts               ; 60

; Fast Multi-Add
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
