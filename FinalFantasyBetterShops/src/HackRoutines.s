; HackRoutines.s
; This is the primary file containing the major hack routines. It also provides
; methods for easily swapping to Bank $06 and executing indexed hack methods.

;
; callHack0E
; Address: 0E:82F5
; Length: 9 bytes
;
; Wrapper to call the hack method with the index given by the accumlator and
; return to bank $0E after execution. For clarity's sake, this method should
; only be executed from the $0E bank.
;
callHack0E:
  sta $01         ; 85 01
  lda #$0E        ; A9 0E
  sta $00         ; 85 00
  jmp callHack    ; 4C F2 FD

;
; callHack
; Address: 0F:FDF2
; Length: 13 bytes
;
; This is the master $0F bank function that swaps to bank 6, initiates hack
; routine execution, then swaps back to the original bank before returning.
; This uses the value at $00 as the "return bank" and zero-fills that byte
; prior to exiting.
;
callHack:
  jsr swapAndJumpToHack   ; 20 82 FF
  lda $00                 ; A5 00
  jsr bank_swap           ; 20 1A FE
  lda #00                 ; A9 00
  sta $00                 ; 85 00
  rts                     ; 60

;
; swapAndJumpToHack
; Address: 0F:FF82
; Length: 8
;
swapAndJumpToHack:
  lda #$06          ; A9 06
  jsr bank_swap     ; 20 1A FE
  jmp executeHack   ; 4C 00 AD

;
; hackMethod AddressTable
; Injected: 0D:ACA0
;
; Contains the indexed addresses for all of the externally available hack
; routines that exist in the $06 bank. This is used by `executeHackRoutine`
; to indirectly jump into a hack routine.
;
; The table has been allocated 96 bytes at the head of the great void, so our
; external API can support up to 48 callable methods.
;
hackMethodAddressTable:
  XX                ; Index 0: initializePriceQuantity
  XX
  YY                ; Index 1: incrementQuantity
  YY
  ZZ                ; Index 2: decrementQuantity
  ZZ
  XX                ; Index 3: multiAddItems
  XX
  YY                ; Index 4: subtractGold
  YY
  20                ; Index 5: cleanupZeroPage
  AD

;
; executeHack
; Address:  0D:AD00
; Length:   18
;
; Master hack routine executor. Looks up indirect addresses in the master
; address table and jumps directly to them to execute hack methods.
;
executeHack:
  asl $01                           ; 06 01
  ldx $01                           ; A6 01
  lda hackMethodAddressTable, x     ; BD A0 AC
  sta $02                           ; 85 02
  inx                               ; E8
  lda hackMethodAddressTable, x     ; BD A0 AC
  sta $03                           ; 85 03
  jmp ($0002)                       ; 6C 02 00

;
; cleanupZeroPage
; Address:  0D:AD20
; Length:   10
;
; Cleans up the temporary zero page values. This is called upon shop exit at the
; moment.
;
cleanupZeroPage:
  lda #0            ; A9 00
  ldx #9            ; A2 09
@loop:
  sta $00, x        ; 95 00
  dex               ; CA
  bne @loop (-5)    ; D0 FB
  rts               ; 60
