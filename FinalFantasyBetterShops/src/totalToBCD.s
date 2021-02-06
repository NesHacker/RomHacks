;
; totalToBCD
; Address:  06:???? (01????)
;
; Converts the current gold total at $05 - $07 to BCD and stores the result in
; $0A - $0C.
;
totalToBCD:
  lda $05           ; A5 05
  pha               ; 48
  lda $06           ; A5 06
  pha               ; 48
  lda $07           ; A5 07
  pha               ; 48
  lda #$00          ; A9 00
  sta $0A           ; 85 0A
  sta $0B           ; 85 0B
  sta $0C           ; 85 0C
  ldy #$18          ; A0 18
@loop:
  ldx #$03          ; A2 03
@highNibble:
  lda $09, x        ; B5 09
  cmp #$50          ; C9 50
  bcc +5            ; 90 05
  clc               ; 18
  adc #$30          ; 69 30
  sta $09, x        ; 95 09
@lowNibble:
  and #$0f          ; 29 0F
  cmp #$05          ; C9 05
  bcc +7            ; 90 07
  lda #$03          ; A9 03
  clc               ; 18
  adc $09, x        ; 75 09
  sta $09, x        ; 95 09
  dex               ; CA
  bne @highNibble (-27)  ; D0 E5
  asl $05           ; 06 05
  rol $06           ; 26 06
  rol $07           ; 26 07
  rol $0A           ; 26 0A
  rol $0B           ; 26 0B
  rol $0C           ; 26 0C
  dey               ; 88
  bne @loop (-44)   ; D0 D4
  pla               ; 68
  sta $07           ; 85 07
  pla               ; 68
  sta $06           ; 85 06
  pla               ; 68
  sta $05           ; 85 05
  rts               ; 60
