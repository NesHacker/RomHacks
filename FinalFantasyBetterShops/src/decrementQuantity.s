;
; decrementQuantity
; Address:  06:BE80 (01BE90)
;
; TODO Document me
;
decrementQuantity:
  lda $04           ; A5 04
  cmp #1            ; C9 01
  beq +2            ; F0 02
  dec $04           ; C6 04
  rts
