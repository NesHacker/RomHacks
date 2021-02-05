;
; Entry Hook (0E:A733)
;
; Original
; 0E:A733: A9 02     LDA #$02
; 0E:A735: 8D 14 40  STA OAM_DMA = #$02
;
jsr $84EB           ; 20 EB 84
nop                 ; EA
nop                 ; EA

;
; onVblank
; Address: 0E:84EB
; Length: 9
;
; Called at the beginning of a Vblank to ensure the hack code can perform any
; rendering required after changing state.
;
bit $09             ; 24 09
bpl +5              ; 10 05
lda #3              ; A9 03
jsr callHack0E      ; 20 F5 82
lda #$02            ; A9 02
STA $4014           ; 8D 14 40
rts                 ; 60
