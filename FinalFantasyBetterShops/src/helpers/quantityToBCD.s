;
; quantityToBCD
; Address:  06:BF50 (01BF60)
; Length:   88
;
; Helper method that calculates the BCD for the current item quantity. The
; conversion algorithm is greatly simplified due to the fact that we cannot
; exceed 99 items at a time when buying (thus we can use a single byte to hold
; two decimal digits).
;
.org $BF50
quantityToBCD:
  lda $04
  pha
  lda #00
  sta $08
  ldx #$08
@loop:
  lda $08
  cmp #$50
  bcc @lowNibble
  clc
  adc #$30
  sta $08
@lowNibble:
  and #$0f
  cmp #$05
  bcc @shift
  lda #$03
  clc
  adc $08
  sta $08
@shift:
  asl $04
  rol $08
  dex
  bne @loop
  pla
  sta $04
  rts
