;
; buyItems
; Address: 0D:AE60 (01AE70)
; Hack Routine Index: 4
;
; Confirms purchases, widthdraws funds, and adds items to the inventory. On
; completion it sets a return address in $02-$03 that the OnBuy hook uses for an
; indirect jump to the appropriate game code depending on the state of the sale:
;
; - $A4B7 if there is not enough room in the inventory for the items
; - $A4A5 if the player does not have enough gold for the items
; - $A4E8 is set on success
;
.org $AE60
buyItems:
  cmpTotalToGold = $BEB0

  lda #$A4
  sta $03

  ; Determine if we have space for the item in the inventory
  ldx $030C
  lda $6020, x
  adc $04
  cmp #$64
  bcc @itemsOk

  ; Return "not enough inventory space"
  lda #$B7
  sta $02
  rts

@itemsOk:
  ; Determine if we have enough gold for the items
  jsr cmpTotalToGold
  beq @goldOk
  bcc @goldOk

  ; Return "not enough gold"
  lda #$A5
  sta $02
  rts

@goldOk:
  ; Add items to inventory
  ldx $030C
  lda $6020, x
  adc $04
  sta $6020, x

  ; Withdraw gold
  sec
  lda $601C
  sbc $05
  sta $601C
  lda $601D
  sbc $06
  sta $601D
  lda $601E
  sbc $07
  sta $601E

  ; Return "buy successful"
  lda #$E8
  sta $02
  rts
