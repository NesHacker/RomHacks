;
; Entry Hook (0E:A733)
;
; Original
; 0E:A733: A9 02     LDA #$02
; 0E:A735: 8D 14 40  STA OAM_DMA = #$02
;
.org $A733
  jsr $84EB
  nop
  nop

;
; OnVblank
; Address: 0E:84EB
; Length: 9
;
; Called at the beginning of a Vblank to ensure the hack code can perform any
; rendering required after changing state.
;
.org $84EB
OnVblank:
  callHack0E = $82F5
  bit $09
  bpl @skipRender
  lda #3            ; Index 3: renderQuantityAndTotal
  jsr callHack0E
@skipRender:
  lda #$02
  STA $4014
  rts
