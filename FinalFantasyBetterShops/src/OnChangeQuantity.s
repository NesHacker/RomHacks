; OnChangeQuantity.s
; Routines for incrementing and decrementing quantity in the shop buy menu.


; I think we need to jump into a mini routine here...
; Note, A is immediately overwritten after this jump

;
; Entry Hook (0E:A774)
;
; The original JMP instruction is only executed when a button on the controller
; has been pressed that doesn't correspond to an action in a shop menu (i.e
; the player pressed a button besides up, down, a, or b).
; Instead of jumping out to continue with the routine we jump into a small
; method that calls out to the `changeQuantity` hack method, which handles the
; rest of the logic and checks (e.g. if we are on the correct menu, can you
; affort the quantity, updating the graphics, etc.).
;
; Original Code:
; 0E:A774: 4C 9D AD  JMP $AD9D
;
jmp $84E3           ; 4C E3 84

;
; onQuantityChange
; Address: 0E:84E3
; Length: 8
;
; Calls out to the change quantity hack method to handle changes if applicable.
;
lda #2              ; A9 02       // `changeQuantity` is hack index 2
jsr callHack0E      ; 20 F5 82
jmp $AD9D           ; 4C 9D AD

; ------------------------------------------------------------------------------

; lda $20             ; A5 20
; and %00000011       ; 29 03
; beq +5              ; F0 05


; Routine: Update total from quantity
; Total = Quantity * Item Price
; Currently 46 bytes of memory to handle this... Where am I gonna put this?
; I can get it down to 41 minimum if I don't clean up after myself
  lda $030E   ; Copy over the item price
  sta $05
  lda $030F
  sta $06
  lda #0      ; Set the "total" to 0
  sta $04
  ldx #16     ; 16-bits in the item price
@shift:
  lsr $06     ; Shift the item price to get the first bit
  ror $05
  bcc @skip
  lda $01
  clc
  adc $04
  sta $04
@skip:
  ror $04
  ror $03
  ror $02
  dex
  bne @shift
@end:
  lda #0
  sta $05
  sta $06
  rts

; Routine: Increment With Bounds Checking
; Routine: Decrement With Bounds Checking
