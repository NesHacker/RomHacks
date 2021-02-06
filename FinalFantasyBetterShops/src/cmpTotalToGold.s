;
; cmpTotalToGold
; Address: 06:BEB0 (01BEC0)
;
; Compares the item price total to the party's current gold. Sets the carry flag
; if the total >= gold, and sets the zero flag if total == gold.
;
cmpTotalToGold:
  lda $07         ; A5 07
  cmp $601E       ; CD 1E 60
  bne @return     ; D0 0C
  lda $06         ; A5 06
  cmp $601D       ; CD 1D 60
  bne @return     ; D0 05
  lda $05         ; A5 05
  cmp $601C       ; CD 1C 60
@return:
  rts             ; 60
