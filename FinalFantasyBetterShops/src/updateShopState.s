;
; updateShopState
; Address: 0D:BF20 (01BF30)
;
; Calls a collection of shop state update methods and toggles the rendering
; flag for all shop hacks.
;
updateShopState:
  jsr $BF90         ; 20 90 BF    // Call `calculateTotal`
  jsr $BE20         ; 20 20 BE    // Call `totalToBCD`
  jsr $BF50         ; 20 50 BF    // Call `quantityToBCD`
  lda #$80          ; A9 80
  sta $09           ; 85 09
  rts               ; 60
