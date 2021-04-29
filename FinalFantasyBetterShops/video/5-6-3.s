;------- executeHack -----------------------------------------------------------

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

06 01     ASL $01
A6 01     LDX $01
BD A0 AC  LDA $ACA0, X
85 02     STA $02
E8        INX
BD A0 AC  LDA $ACA0, X
85 03     STA $03
6C 02 00  JMP ($0002)

;------- initializePriceQuantity -----------------------------------------------

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

06:AD30: A5 10     LDA $10
06:AD32: 8D 0E 03  STA $030E
06:AD35: 85 05     STA $05
06:AD37: A5 11     LDA $11
06:AD39: 8D 0F 03  STA $030F
06:AD3C: 85 06     STA $06
06:AD3E: 20 80 BF  JSR $BF80
06:AD41: 90 03     BCC @continue
06:AD43: 4C 20 AD  JMP $AD20
06:AD46: A9 00     @continue: LDA #0
06:AD48: 85 07     STA $07
06:AD4A: 20 A0 BD  JSR $BDA0
06:AD4D: A9 01     LDA #1
06:AD4F: 85 04     STA $04
06:AD51: 20 20 BF  JSR $BF20
06:AD54: 60        RTS
