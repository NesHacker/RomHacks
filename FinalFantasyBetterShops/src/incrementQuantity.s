;
; incrementQuantity
; Address:  06:BED0 (01BEE0)
;
; Handles boundary cases and state updates in reaction to a request by the user
; to increment the quantity of the selected item in a shop. This will only be
; called for consumable items.
;
incrementQuantity:
  ldx $030C       ; AE 0C 03
  lda $6020, x    ; BD 20 60
  tax             ; AA
  inx             ; E8
  txa             ; 8A
  clc             ; 18
  adc $04         ; 65 04
  cmp #$63        ; C9 63
  bcc +5          ; 90 05
@wrapAround:
  lda #1          ; A9 01
  sta $04         ; 85 04
  rts             ; 60
  clc             ; 18

  lda $030E       ; AD 0E 03
  adc $05         ; 65 05
  sta $05         ; 85 05
  lda $030F       ; AD 0F 03
  adc $06         ; 65 06
  sta $06         ; 85 06
  lda #$00        ; A9 00
  adc $07         ; 65 07
  sta $07         ; 85 07

  sec             ; 38
  lda $601C       ; AD 1C 60
  sbc $05         ; E5 05
  sta $05         ; 85 05

  sec             ; 38
  lda $601D       ; AD 1D 60
  sbc $06         ; E5 06

  sta $06         ; 85 06
  lda $601E       ; AD 1E 60
  sbc $07         ; E5 07

  bpl +5          ; 10 05
@wrapAround:
  lda #1          ; A9 01
  sta $04         ; 85 04
  rts             ; 60
  inc $04         ; E6 04
  rts             ; 60
