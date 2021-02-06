;
; incrementQuantity
; Address:  06:BED0 (01BEE0)
;
; Handles updates and wrapping when incrementing the item quantity in the store.
;
incrementQuantity:
  ldx $04         ; A6 04
  inx             ; E8
  txa             ; 8A
  cmp $0D         ; C5 0D
  beq @setValue   ; F0 04
  bcc @setValue   ; 90 02
  ldx #1          ; A2 01
@setValue:
  stx $04         ; 86 04
  rts             ; 60
