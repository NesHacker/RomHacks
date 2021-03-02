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
  lda $54
  cmp #$C9
  bne @return
  jsr isConsumable  ; Call `isConsumable`
  bcs @return
  lda $20
  and #%00000011
  beq @return
  cmp #%00000001
  bne @decrement
  jsr $BED0         ; Call `incrementQuantity`
  jmp @update
@decrement:
  jsr $BE80         ; Call 'decrementQuantity'
@update:
  jsr $BF20         ; Call `updateShopState`
@return:
  rts
