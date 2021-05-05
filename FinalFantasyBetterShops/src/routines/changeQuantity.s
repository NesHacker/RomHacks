;
; changeQuantity
; Address: 0D:AD60 (01AD70)
; Hack Index: 2
;
; Handles logic for incrementing and decrementing the selected item quantity
; based on user input. This function also handles bounds checking and only
; applies changes if in the correct shop menu. Further, this method will only
; apply changes if the currently selected item is a consumable.
;
.org $AD60
changeQuantity:
  isConsumable = $BF80
  decrementQuantity = $BE80
  incrementQuantity = $BED0
  updateShopState = $BF20

  ; Return if we're not in the final buy menu
  lda $54
  cmp #$C9
  bne @return

  ; Return if we aren't buying an consumable item
  jsr isConsumable
  bcs @return
  lda $20

  ; Return if the player isn't pressing left or right
  and #%00000011
  beq @return

  ; If the player is pressing left, call `incrementQuantity`
  cmp #%00000001
  bne @decrement
  jsr incrementQuantity
  jmp @update

  ; Else, call `decrementQuantity`
@decrement:
  jsr decrementQuantity

  ; Update the shop state
@update:
  jsr updateShopState

@return:
  rts
