;
; renderQuantityAndTotal.s
; Address: 06:AD90 (01ADA0)
; Hack Routine Index: 3
;
; Performs nametable rendering to display the current total gold cost plus the
; selected quantity. This hack is called during vblanks if a re-render flag is
; set by the other method (e.g. after initialization or when quantity changes).
;
.org $AD90
renderQuantityAndTotal:
  lda #$20
  sta $2006
  lda #$C7
  sta $2006
  lda #$FF
  sta $2007
  lda #$20
  sta $2006
  lda #$C2
  sta $2006
  ldx #$03
@padLeading:
  lda $09, x
  bne *+9
  lda #$FF
  sta $09, x
  dex
  bne @padLeading
  cmp #$10
  bcs @setSkipCharacter
  ora #$F0
  sta $09, x
@setSkipCharacter:
  lda $0C
  and #$F0
  cmp #$F0
  bne @beginLoop
  lda $0C
  and #$0F
  ora #$E0
  sta $0C
@beginLoop:
  ldx #$03
@loop:
  lda $09, x
  jsr renderDigits
  dex
  bne @loop
  lda #$21
  sta $2006
  lda #$A2
  sta $2006
  lda #$9A
  sta $2007
  lda #$B7
  sta $2007
  lda #$BC
  sta $2007
  lda #$FF
  sta $2007
  lda $08
  cmp #$10
  bcs *+4
  ora #$F0
  jsr renderDigits
  bit $2002
  lda #0
  sta $2005
  sta $2005
  lda #$00
  sta $09
  rts

;
; Attached helper method for rendering compact binary coded decimal digits.
; Consider breaking this out into a common helper later if we need to do further
; number rendering in future hacks.
;
renderDigits:
  pha
  lsr
  lsr
  lsr
  lsr
  cmp #$0E
  beq @lowNibble
  cmp #$0F
  bne *+4
  lda #$7F
  clc
  adc #$80
  sta $2007
@lowNibble:
  pla
  and #$0F
  cmp #$0E
  beq @return
  cmp #$0F
  bne *+4
  lda #$7F
  clc
  adc #$80
  sta $2007
@return:
  rts
