;
; updateShopState
; Address: 0D:BF20 (01BF30)
;
; Calls a collection of shop state update methods and toggles the rendering
; flag for all shop hacks.
;
.org $BF20
updateShopState:
  jsr $BF90         ; Call `calculateTotal`
  jsr $BE20         ; Call `totalToBCD`
  jsr $BF50         ; Call `quantityToBCD`
  lda #$80
  sta $09
  rts
