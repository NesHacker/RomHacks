;
; decrementQuantity
; Address:  06:BE80 (01BE90)
;
; Handles updates and wrapping when decrementing the item quantity in the store.
;
.org $BE80
decrementQuantity:
  itemQuantity = $04
  maxQuantity = $0D
  ldx itemQuantity
  dex
  bne @setValue
  ldx maxQuantity
@setValue:
  stx itemQuantity
  rts
