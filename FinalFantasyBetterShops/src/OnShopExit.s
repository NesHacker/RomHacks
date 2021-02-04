; OnShopExit.s
; Routines and notes for handling cleanup when exiting a shop.

;
; Entry Hook (0E:A484 - 0E:A489, 6 bytes)
;
; We need to RTS from 0E:A484 if carry is set or $62 is not zero (aka the cursor
; index == 1, visually on the "exit" option). We also need to execute the hack
; method `cleanupZeroPage` prior to the RTS.
;
; 1. Execute cleanupZeroPage
; 2. Perform an RTS to return out of the shop routine
;
jmp onShopExit        ; 4C 69 84

;
; onShopExit
; Address: 0E:8469
; Length: 14
;
; This routine is called to check if we are exiting the shop and, if so, call
; the zeropage cleanup hack method in bank 06.
;
onShopExit
  bcs @exit (+7)      ; B0 07
  lda $62             ; A5 62
  bne @exit (+3)      ; D0 03
  jmp $A489           ; 4C 89 A4    // Not exiting, continue on...
@exit:
  lda #0              ; A9 00       // `cleanupZeroPage` is hack index 0
  jsr callHack0E      ; 20 F5 82
  rts                 ; 60
