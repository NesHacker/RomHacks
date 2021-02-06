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
callHack0E:
  sta $01         ; 85 01
  lda #$0E        ; A9 0E
  sta $00         ; 85 00
  jmp callHack    ; 4C F2 FD

;
; callHack
; Address: 0F:FDF2 (03FE02)
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
; Address: 0F:FF82 (03FF91)
; Length: 8
;
swapAndJumpToHack:
  lda #$06          ; A9 06
  jsr bank_swap     ; 20 1A FE
  jmp executeHack   ; 4C 00 AD

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
  20                ; Index 0: cleanupZeroPage
  AD
  30                ; Index 1: initializePriceQuantity
  AD
  60                ; Index 2: changeQuantity
  AD
  90                ; Index 3: renderQuantityAndTotal
  AD
  XX                ; Index 4: buyItems
  XX

;
; executeHack
; Address:  0D:AD00 (10AD10)
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
; Address: 0D:AD20 (01AD30)
; Hack Index: 0
;
; Cleans up the temporary zero page values. This is called upon shop exit at the
; moment.
;
cleanupZeroPage:
  lda #0            ; A9 00
  ldx #$0D          ; A2 0D
@loop:
  sta $00, x        ; 95 00
  dex               ; CA
  bne @loop (-5)    ; D0 FB
  rts               ; 60

;
; initializePriceQuantity
; Addrtess: 0D:AD30 (01AD40)
; Hack Index: 1
;
; Initalizes price, total, and quantity for when a shop item has been selected.
;
initializePriceQuantity:
  jsr isConsumable  ; 20 80 BF  // Only initialize for consumable items
  bcs +25           ; B0 19
  lda $10           ; A5 10     // Store the item price and initial total
  sta $030E         ; 8D 0E 03
  sta $05           ; 85 05
  lda $11           ; A5 11
  sta $030F         ; 8D 0F 03
  sta $06           ; 85 06
  lda #0            ; A9 00
  sta $07           ; 85 07
  lda #1            ; A9 01     // Initialize quantity to 1
  sta $04           ; 85 04
  jsr $BF20         ; 20 20 BF  // Call `updateShopState`
@return:
  rts               ; 60

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

A554C9C9D01B2080BFB016A5202903F010C901D00620D0BE4C6EAD2080BE2020BF60


;
; buyItems
; Address:  0D:????
; Length:   ?
;
; TODO: Implement me.
;
buyItems:
  rts
