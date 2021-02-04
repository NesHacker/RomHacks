; OnChangeQuantity.s
; Routines for incrementing and decrementing quantity in the shop buy menu.

; $01 - Quantity

; $02 - Total Price Byte 0 (lo)
; $03 - Total Price Byte 1
; $04 - Total Price Byte 2 (hi)

; $05 - Item Price TMP (lo)
; $06 - Item Price TMP (hi)

; $030E - $030F - Item Price

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
