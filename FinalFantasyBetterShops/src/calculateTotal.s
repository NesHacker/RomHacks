;
; calculateTotal
; Address:  06:BF90
; Length:   39
;
; Helper method to calculate a new grand total when buying more than one item.
; This routine is called by `changeQuantity` and is broken out here to make
; that implementation a bit more clear.
;
; The method also calculates the packed BCD representation of the price and
; stores the result in $01 through $03 for use in rendering the total amount
; into the nametable.
;
calculateTotal:
; Copy the item price to the zero page memo ($08-$09)
  lda $030E         ; AD 0E 03
  sta $08           ; 85 08
  lda $030F         ; AD 0F 03
  sta $09           ; 85 09
; Set the "total" to 0
  lda #0            ; A9 00
  sta $07           ; 85 07
; 16-bits in the item price
  ldx #16           ; A2 10
@shift:
; Shift the item price memo right to get the first bit
  lsr $09           ; 46 09
  ror $08           ; 66 08
  bcc @skip (+7)    ; 90 07
; Add the entirety of the quantity to the head of the result
  lda $04           ; A5 04
  clc               ; 18
  adc $07           ; 65 07
  sta $07           ; 85 07
@skip:
; Shift the entire result 1 to the right
  ror $07           ; 66 07
  ror $06           ; 66 06
  ror $05           ; 66 05
  dex               ; CA
  bne @shift (-22)  ; D0 EA
@calculateBCD:
  lda $05           ; A5 05
  pha               ; 48
  lda $06           ; A5 06
  pha               ; 48
  lda $07           ; A5 07
  pha               ; 48
  lda #$00          ; A9 00
  sta $01           ; 85 01
  sta $02           ; 85 02
  sta $03           ; 85 03
  ldy #$18          ; A0 18
@loop:
  ldx #$03          ; A2 03
@highNibble:
  lda $00, x        ; B5 00
  cmp #$50          ; C9 50
  bcc +5            ; 90 05
  clc               ; 18
  adc #$30          ; 69 30
  sta $00, x        ; 95 00
@lowNibble:
  and #$0f          ; 29 0F
  cmp #$05          ; C9 05
  bcc +7            ; 90 07
  lda #$03          ; A9 03
  clc               ; 18
  adc $00, x        ; 75 00
  sta $00, x        ; 95 00
  dex               ; CA
  bne @highNibble (-27)  ; D0 E5
  asl $05           ; 06 05
  rol $06           ; 26 06
  rol $07           ; 26 07
  rol $01           ; 26 01
  rol $02           ; 26 02
  rol $03           ; 26 03
  dey               ; 88
  bne @loop (-44)   ; D0 D4
  pla               ; 68
  sta $07           ; 85 07
  pla               ; 68
  sta $06           ; 85 06
  pla               ; 68
  sta $05           ; 85 05
  rts               ; 60
