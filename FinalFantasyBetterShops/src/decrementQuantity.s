;
; decrementQuantity
; Address:  06:BE80 (01BE90)
;
; Handles updates and wrapping when decrementing the item quantity in the store.
;
decrementQuantity:
  ldx $04         ; A6 04
  dex             ; CA
  bne @setValue   ; D0 02
  ldx $0D         ; A6 0D
@setValue:
  stx $04         ; 86 04
  rts             ; 60
