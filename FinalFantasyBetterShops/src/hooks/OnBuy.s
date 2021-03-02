; OnBuy.s
; Routines and notes for handling adding multiple items when buying in shops.

;
; Entry Hook (OE:A4A0, 03A4B0)
;
; The original code is used to handle the checks for gold and inventory space
; and then when displaying the "you don't have enough gold" message. The code is
; only executed when in an item type shop (tested on all other shops and neither
; of the possible entrypoints were executed).
;
; Original Code:
; 0E:A4A0: 20 EB A4  JSR $A4EB
;
.org $A4A0
  jmp $AD19

;
; onBuy
; Address: 0E:AD19
;
; Calls out to the buying hack method jumps to the indirect address it writes
; out. On success we also need to fake a stack frame so that the code executes
; as expected and correctly causes post sale transition to occur.
;
.org $AD19
OnBuy:
  callHack0E = $82F5
  lda #4
  jsr callHack0E
  lda $02
  cmp #$E8
  bne @skipPush
  lda #$A4
  pha
  lda #$C4
  pha
@skipPush:
  jmp ($0002)
