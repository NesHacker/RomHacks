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
; 0E:A4A0: 20 EB A4  JSR $A4EB Check If Enough Gold
;
jmp $AD19           ; 4C 19 AD

;
; onBuy
; Address: 0E:AD19
; Length: 20
;
; Calls out to the buying hack method jumps to the indirect address it writes
; out. On success we also need to fake a stack frame so that the code executes
; as expected and correctly causes post sale transition to occur.
;
lda #4              ; A9 04
jsr callHack0E      ; 20 F5 82
lda $02             ; A5 02
cmp #$E8            ; C9 E8
bne +6              ; D0 06
lda #$A4            ; A9 A4
pha                 ; 48
lda #$C4            ; A9 C4
pha                 ; 48
jmp ($0002)         ; 6C 02 00
