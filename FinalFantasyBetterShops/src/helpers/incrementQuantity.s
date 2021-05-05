;
; incrementQuantity
; Address:  06:BED0 (01BEE0)
;
; Handles updates and wrapping when incrementing the item quantity in the store.
;
.org $BED0
incrementQuantity:
  ldx $04
  inx
  txa
  cmp $0D
  beq @setValue
  bcc @setValue
  ldx #1
@setValue:
  stx $04
  rts
