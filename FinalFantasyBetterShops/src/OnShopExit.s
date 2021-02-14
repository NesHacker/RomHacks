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
.org $A484
  jmp onShopExit

;
; onShopExit
; Address: 0E:8469
; Length: 14
;
; This routine is called to check if we are exiting the shop and, if so, call
; the zeropage cleanup hack method in bank 06.
;
onShopExit:
  callHack0E = $82F5
  bcs @exit
  lda $62
  bne @exit
  jmp $A489           ; Not exiting, continue on...
@exit:
  lda #0              ; `cleanupZeroPage` is hack index 0
  jsr callHack0E
  rts
