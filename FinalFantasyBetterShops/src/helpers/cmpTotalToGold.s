;
; cmpTotalToGold
; Address: 06:BEB0 (01BEC0)
;
; Compares the item price total to the party's current gold. Sets the carry flag
; if the total >= gold, and sets the zero flag if total == gold.
;
.org $BEB0
cmpTotalToGold:
  lda $07
  cmp $601E
  bne @return
  lda $06
  cmp $601D
  bne @return
  lda $05
  cmp $601C
@return:
  rts
