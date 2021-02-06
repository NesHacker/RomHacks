;
; renderQuantityAndTotal.s
; Address: 06:AD90 (01ADA0)
; Hackl Index: 3
;
; Performs nametable rendering to display the current total gold cost plus the
; selected quantity. This hack is called during vblanks if a re-render flag is
; set by the other method (e.g. after initialization or when quantity changes).
;
renderQuantityAndTotal:
  lda #$20          ; A9 20
  sta $2006         ; 8D 06 20
  lda #$C7          ; A9 C7
  sta $2006         ; 8D 06 20
  lda #$FF          ; A9 FF
  sta $2007         ; 8D 07 20
  lda #$20          ; A9 20
  sta $2006         ; 8D 06 20
  lda #$C2          ; A9 C2
  sta $2006         ; 8D 06 20
  ldx #$03          ; A2 03
@padLeading:
  lda $09, x        ; B5 09
  bne +7            ; D0 07
  lda #$FF          ; A9 FF
  sta $09, x        ; 95 09
  dex               ; CA
  bne @padLeading   ; D0 F5
  cmp #$10          ; C9 10
  bcs +4            ; B0 04
  ora #$F0          ; 09 F0
  sta $09, x        ; 95 09
@setSkipCharacter:
  lda $0C           ; A5 0C
  and #$F0          ; 29 F0
  cmp #$F0          ; C9 F0
  bne +8            ; D0 08
  lda $0C           ; A5 0C
  and #$0F          ; 29 0F
  ora #$E0          ; 09 E0
  sta $0C           ; 85 0C
  ldx #$03          ; A2 03
@loop:
  lda $09, x        ; B5 09
  jsr renderDigits  ; 20 ?? ??
  dex               ; CA
  bne @loop (-8)    ; D0 F8
  lda #$21          ; A9 21
  sta $2006         ; 8D 06 20
  lda #$A2          ; A9 A2
  sta $2006         ; 8D 06 20
  lda #$9A          ; A9 9A
  sta $2007         ; 8D 07 20
  lda #$B7          ; A9 B7
  sta $2007         ; 8D 07 20
  lda #$BC          ; A9 BC
  sta $2007         ; 8D 07 20
  lda #$FF          ; A9 FF
  sta $2007         ; 8D 07 20
  lda $08           ; A5 08
  cmp #$10          ; C9 10
  bcs +2            ; B0 02
  ora #$F0          ; 09 F0
  jsr renderDigits  ; 20 F2 AD
  bit $2002         ; 2C 02 20
  lda #0            ; A9 00
  sta $2005         ; 8D 05 20
  sta $2005         ; 8D 05 20
  lda #$00          ; A9 00
  sta $09           ; 85 09
  rts               ; 60
renderDigits:
  pha               ; 48
  lsr               ; 4A
  lsr               ; 4A
  lsr               ; 4A
  lsr               ; 4A
  cmp #$0E          ; C9 0E
  beq +12           ; F0 0C
  cmp #$0F          ; C9 0F
  bne +2            ; D0 02
  lda #$7F          ; A9 7F
  clc               ; 18
  adc #$80          ; 69 80
  sta $2007         ; 8D 07 20
@lowNibble:
  pla               ; 68
  and #$0F          ; 29 0F
  cmp #$0E          ; C9 0E
  beq +12           ; F0 0C
  cmp #$0F          ; C9 0F
  bne +2            ; D0 02
  lda #$7F          ; A9 7F
  clc               ; 18
  adc #$80          ; 69 80
  sta $2007         ; 8D 07 20
@return:
  rts               ; 60
