; OnShopExit.s
; Routines and notes for handling cleanup of the zero page on shop exit.

;
; Routine Entry Hook @ 0E:A486 (03A496)
; This replaces the original game code and jumps into our hacked routine.
;
; Original Code:
; 0E:A486: A5 62     LDA $62    // This will be non-zero when exiting
; 0E:A488: D0 E7     BNE $A471  // This address is an RTS instruction
;
jmp $BFEF         ; 4C EF BF
nop               ; EA          // (Address: A489)

;
; On Shop Exit ZeroPage Cleanup
; Injected: $0E:BFEF - $0E:BFFD (15 bytes)
;
; This zero-fills the memory used to handle multi-buy functionality when the
; player exits a store. No need to save X, it gets overwritten before use in
; both logical paths after finishing the routine.
;
ldx $62           ; A6 62
bne +3            ; D0 03
jmp $A489         ; 4C 89 A4    // Not exiting shop, jump to NOP
dex               ; CA          // X will be 1 at this point (the cursor index)
sta $01           ; 85 01
sta $02           ; 85 02
sta $03           ; 85 03
rts               ; 60          // Exiting Shop, fire an RTS
