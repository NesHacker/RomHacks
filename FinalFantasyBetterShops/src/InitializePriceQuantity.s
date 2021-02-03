; InitializePriceQuantity.s
; Routines for initializing the zero-page state for handling multi-buy.

;
; Routine Entry Hook @ 0E:AA98 (03AAA8)
; Replaces original game code and jumps into our routine.
;
; Original Code:
; 0E:AA98: 4C 32 AA  JMP $AA32
;
jmp $84EF         ; 4C EF 84

;
; Initializes Price & Quantity State
; Injected: 0E:84EF - 0E:84FB (13 bytes)
;
; This initializes the quantity and price in the zero page for use with the
; increment, decrement, and buy logic. Note: X is overwritten immediately
; after exiting this routine.
;
sta $03           ; 85 03       // A should still contain the hi-byte of the price
ldx $10           ; A6 10       // $10 contains the lo-byte of the price
stx $02           ; 86 02
ldx #1            ; A2 01
stx $01           ; 86 01
jmp $AA32         ; 4C 32 AA

