;
; totalToBCD
; Address:  06:BE20 (01BE30)
;
; Converts the current gold total at $05 - $07 to BCD and stores the result in
; $0A - $0C.
;
.org $BE20
totalToBCD:
  lda $05
  pha
  lda $06
  pha
  lda $07
  pha
  lda #$00
  sta $0A
  sta $0B
  sta $0C
  ldy #$18
@loop:
  ldx #$03
@highNibble:
  lda $09, x
  cmp #$50
  bcc *+7
  clc
  adc #$30
  sta $09, x
@lowNibble:
  and #$0f
  cmp #$05
  bcc *+9
  lda #$03
  clc
  adc $09, x
  sta $09, x
  dex
  bne @highNibble
  asl $05
  rol $06
  rol $07
  rol $0A
  rol $0B
  rol $0C
  dey
  bne @loop
  pla
  sta $07
  pla
  sta $06
  pla
  sta $05
  rts
