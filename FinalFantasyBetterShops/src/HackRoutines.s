; HackRoutines.s
; This is the primary file containing the major hack routines. It also provides
; methods for easily swapping to Bank $06 and executing indexed hack methods.

;
; callHack0E
; Address: 0E:82F5 (038305)
; Length: 9 bytes
;
; Wrapper to call the hack method with the index given by the accumlator and
; return to bank $0E after execution. For clarity's sake, this method should
; only be executed from the $0E bank.
;
.org $82F5
callHack0E:
  callHack = $FDF2
  sta $01
  lda #$0E
  sta $00
  jmp callHack

;
; callHack
; Address: 0F:FDF2 (03FE02)
;
; This is the master $0F bank function that swaps to bank 6, initiates hack
; routine execution, then swaps back to the original bank before returning.
; This uses the value at $00 as the "return bank" and zero-fills that byte
; prior to exiting.
;
.org $FDF2
callHack:
  bankSwap = $FE1A
  swapAndJumpToHack = $FF82
  jsr swapAndJumpToHack
  lda $00
  jsr bankSwap
  lda #0
  sta $00
  rts

;
; swapAndJumpToHack
; Address: 0F:FF82 (03FF91)
;
.org $FF82
swapAndJumpToHack:
  bankSwap = $FE1A
  executeHack = $AD00
  lda #$06
  jsr bankSwap
  jmp executeHack

;
; hackMethod AddressTable
; Injected: 0D:ACA0 (01ACB0)
;
; Contains the indexed addresses for all of the externally available hack
; routines that exist in the $06 bank. This is used by `executeHackRoutine`
; to indirectly jump into a hack routine.
;
; The table has been allocated 96 bytes at the head of the great void, so our
; external API can support up to 48 callable methods.
;
.org $ACA0
hackMethodAddressTable:
  .byte $20, $AD    ; Index 0: cleanupZeroPage
  .byte $30, $AD    ; Index 1: initializePriceQuantity
  .byte $60, $AD    ; Index 2: changeQuantity
  .byte $90, $AD    ; Index 3: renderQuantityAndTotal
  .byte $60, $AE    ; Index 4: buyItems

;
; executeHack
; Address:  0D:AD00 (10AD10)
; Length:   18
;
; Master hack routine executor. Looks up indirect addresses in the master
; address table and jumps directly to them to execute hack methods.
;
.org $AD00
executeHack:
  hackMethodAddressTable = $ACA0
  asl $01
  ldx $01
  lda hackMethodAddressTable, x
  sta $02
  inx
  lda hackMethodAddressTable, x
  sta $03
  jmp ($0002)
