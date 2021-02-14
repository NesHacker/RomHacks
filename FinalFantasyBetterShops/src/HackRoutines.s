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
  sta $01         ; 85 01
  lda #$0E        ; A9 0E
  sta $00         ; 85 00
  jmp callHack    ; 4C F2 FD

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
; Address: 0D:AD20 (01AD30)
; Hack Index: 0
;
; Cleans up the temporary zero page values. This is called upon shop exit at the
; moment.
;
.org $AD20
cleanupZeroPage:
  lda #0
  ldx #$0D
@loop:
  sta $00, x
  dex
  bne @loop
  rts

;
; initializePriceQuantity
; Addrtess: 0D:AD30 (01AD40)
; Hack Index: 1
;
; Initalizes price, total, and quantity for when a shop item has been selected.
;
.org $AD30
initializePriceQuantity:
  cleanupZeroPage = $AD20
  isConsumable = $BF80
  lda $10           ; Store the item price and initial total
  sta $030E
  sta $05
  lda $11
  sta $030F
  sta $06
  jsr isConsumable
  bcc @continue
  jmp cleanupZeroPage
@continue:
  lda #0
  sta $07
  jsr $BDA0         ; Call `calculateBuyMaximum`
  lda #1            ; Initialize quantity to 1
  sta $04
  jsr $BF20         ; Call `updateShopState`
  rts

;
; changeQuantity
; Address: 0D:AD60 (01AD70)
; Hack Index: 2
;
; Handles logic for incrementing and decrementing the selected item quantity
; based on user input. This function also handles bounds checking and only
; applies changes if in the correct shop menu. Further, this method will only
; apply changes if the currently selected item is a consumable.
;
changeQuantity:
  lda $54           ; A5 54
  cmp #$C9          ; C9 C9
  bne @return       ; D0 1B
  jsr isConsumable  ; 20 80 BF
  bcs @return       ; B0 16
  lda $20           ; A5 20
  and #%00000011    ; 29 03
  beq @return       ; F0 10
  cmp #%00000001    ; C9 01
  bne @decrement    ; D0 06
  jsr $BED0         ; 20 D0 BE  // Call `incrementQuantity`
  jmp @update       ; 4C 7E AD
@decrement:
  jsr $BE80         ; 20 80 BE  // Call 'decrementQuantity'
@update:
  jsr $BF20         ; 20 20 BF  // Call `updateShopState`
@return:
  rts               ; 60
