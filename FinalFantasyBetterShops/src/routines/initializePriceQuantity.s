;
; initializePriceQuantity
; Addrtess: 0D:AD30 (01AD40)
; Hack Index: 1
;
; Initalizes price, total, and quantity for when a shop item has been selected.
;
.org $AD30
initializePriceQuantity:
  cleanupZeroPage = $AD20
  isConsumable = $BF80
  lda $10           ; Store the item price and initial total
  sta $030E
  sta $05
  lda $11
  sta $030F
  sta $06
  jsr isConsumable
  bcc @continue
  jmp cleanupZeroPage
@continue:
  lda #0
  sta $07
  jsr $BDA0         ; Call `calculateBuyMaximum`
  lda #1            ; Initialize quantity to 1
  sta $04
  jsr $BF20         ; Call `updateShopState`
  rts
