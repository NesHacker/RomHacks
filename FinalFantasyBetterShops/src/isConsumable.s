;
; isConsumable
; Address: 0D:BF80 (01BF90)
;
; Clears the carry flag if the current shop item is a consumable. Consumables
; are the following items: Tent, Cabin, House, Heal, Pure, Soft.
;
isConsumable:
  lda $030C         ; AD 0C 03
  cmp #$1C          ; C9 1C       // Consumables are ids 16 through 1B
  rts               ; 60
