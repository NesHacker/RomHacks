; OnItemSelected.s
; Routines for initializing state for multi-buying when an item is selected in
; a shop.

;
; Entry Hook (0E:AA88 - 0E:AA95)
;
; The original code that we're replacing executes right after a routine is
; called to fetch the selected shop item price. It then transfers the price from
; the return value location ($10-$11) into its main ram location ($030E-$030F).
;
; The `initializePriceQuantity` hack method in the $06 bank will handle the
; transfer of the data to $030E and also initialize the temporary item quantity
; state and total gold cost.
;
; An interesting note here: "GetItemPrice" ($ECB9) routine is hard coded to
; switch banks to $0D and back to $0E so we can't call it directly from bank $06
; in the hack function. Otherwise I would have probably did that whole routine
; call in the hack function for clarity. Regardless, I show the context for the
; hook site below.
;
; Original Code:
;
; 0E:AA88: AD 0C 03  LDA $030C          ; ShopItemId
; 0E:AA8B: 20 B9 EC  JSR $ECB9          ; Routine: GetItemPrice
;   >>> Entry Hook Start <<<
; 0E:AA8E: A5 10     LDA $10
; 0E:AA90: 8D 0E 03  STA $030E
; 0E:AA93: A5 11     LDA $11
; 0E:AA95: 8D 0F 03  STA $030F
; 0E:AA98: 4C 32 AA  JMP $AA32
;   >>> Entry Hook End <<<
; 0E:AAA0: AD 00 03  LDA $0300 = #$19
;
.org $AA8E
OnItemSelected:
  callHack0E = $82F5
  lda #1              ; `initializePriceQuantity` is hack index 1
  jsr callHack0E
  jmp $AA32
  .byte 0, 0, 0, 0, 0 ; Zero-fill the rest
