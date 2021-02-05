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
quantityToBCD:
  lda $04           ; A5 04
  pha               ; 48
  lda #00           ; A9 00
  sta $08           ; 85 08
  ldx #$08          ; A2 08
@loop:
  ; High Nibble
  lda $08           ; A5 08
  cmp #$50          ; C9 50
  bcc +5            ; 90 05
  clc               ; 18
  adc #$30          ; 69 30
  sta $08           ; 85 08
  ; Low Nibble
  and #$0f          ; 29 0F
  cmp #$05          ; C9 05
  bcc +7            ; 90 07
  lda #$03          ; A9 03
  clc               ; 18
  adc $08           ; 65 08
  sta $08           ; 85 08
  ; Perform the shift
  asl $04           ; 06 04
  rol $08           ; 26 08
  dex               ; CA
  bne @loop (-31)   ; D0 E1
  pla               ; 68
  sta $04           ; 85 04
  rts               ; 60
