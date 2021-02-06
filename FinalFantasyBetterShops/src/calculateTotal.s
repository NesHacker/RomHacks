;
; calculateTotal
; Address:  06:BF90 (01BFA0)
;
; Helper method to calculate a new grand total when buying more than one item.
; This routine is called by `changeQuantity` and is broken out here to make
; that implementation a bit more clear.
;
; The method also calculates the packed BCD representation of the price and
; stores the result in $0A through $0C for use in rendering the total amount
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
  rts               ; 60
