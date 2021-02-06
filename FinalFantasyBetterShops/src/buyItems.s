;
; buyItems
; Address: 0D:AE60 (01AE70)
; Hack Index: 4
;
; Confirms purchases, widthdraws funds, and adds items to the inventory. On
; completion it sets a return address in $02-$03 that the OnBuy hook uses for an
; indirect jump to the appropriate game code depending on the state of the sale:
;
; - $A4B7 if there is not enough room in the inventory for the items
; - $A4A5 if the player does not have enough gold for the items
; - $A4E8 is set on success
;
buyItems:
  lda #$A4                ; A9 A4
  sta $03                 ; 85 03

  ; Determine if we have space for the item in the inventory
  ldx $030C               ; AE 0C 03
  lda $6020, x            ; BD 20 60
  adc $04                 ; 65 04
  cmp #$64                ; C9 64
  bcc +5                  ; 90 05
  lda #$B7                ; A9 B7
  sta $02                 ; 85 02
  rts                     ; 60

@itemsOk:
  ; Determine if we have enough gold for the items
  jsr cmpTotalToGold      ; 20 B0 BE
  beq @goldOk             ; F0 07
  bcc @goldOk             ; 90 05
  lda #$A5                ; A9 A5
  sta $02                 ; 85 02
  rts                     ; 60

@goldOk:
  ; Add items to inventory
  ldx $030C               ; AE 0C 03
  lda $6020, x            ; BD 20 60
  adc $04                 ; 65 04
  sta $6020, x            ; 9D 20 60

  ; Withdraw gold
  sec                     ; 38
  lda $601C               ; AD 1C 60
  sbc $05                 ; E5 05
  sta $601C               ; 8D 1C 60
  lda $601D               ; AD 1D 60
  sbc $06                 ; E5 06
  sta $601D               ; 8D 1D 60
  lda $601E               ; AD 1E 60
  sbc $07                 ; E5 07
  sta $601E               ; 8D 1E 60

  lda #$E8                ; A9 E8
  sta $02                 ; 85 02
  rts                     ; 60
