;
; calculateTotal
; Address:  06:BF90 (01BFA0)
;
; Helper routine to calculate a new grand total when buying more than one item.
; The routine also calculates the packed BCD representation of the price and
; stores the result in $0A through $0C for use in rendering the total amount
; into the nametable.
;
.org $BF90
calculateTotal:
  ; Copy the item price to the zero page memo ($08-$09)
  lda $030E
  sta $08
  lda $030F
  sta $09
  ; Set the "total" to 0
  lda #0
  sta $07
  sta $06
  sta $05
  ; 16-bits in the item price
  ldx #16
@shift:
  ; Shift the item price memo right to get the first bit
  lsr $09
  ror $08
  bcc @skip
  ; Add the entirety of the quantity to the head of the result
  lda $04
  clc
  adc $07
  sta $07
@skip:
  ; Shift the entire result 1 to the right
  ror $07
  ror $06
  ror $05
  dex
  bne @shift
  rts
