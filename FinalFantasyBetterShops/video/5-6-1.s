;------- OnItemSelected Hook (START) ------------------------------------------

0E:AA88: A9 0E     LDA #$0E
0E:AA8A: 85 00     STA $00
0E:AA8C: A9 01     LDA #1
0E:AA8E: 85 01     STA $01
0E:AA90: 20 F2 FD  JSR $FDF2  ; callHack
0E:AA93: 4C 32 AA  JMP $AA32

;------- callHack --------------------------------------------------------------

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

0F:FDF2: 20 82 FF  JSR $FF82
0F:FDF5: A5 00     LDA $00
0F:FDF7: 20 1A FE  JSR $FE1A
0F:FDFA: A9 00     LDA #0
0F:FDFC: 85 00     STA $00
0F:FDFE: 60        RTS

;------- swapAndJumpToHack -----------------------------------------------------

.org $FF82
swapAndJumpToHack:
  bankSwap = $FE1A
  executeHack = $AD00
  lda #$06
  jsr bankSwap
  jmp executeHack

0F:FF82: A9 06     LDA #$06
0F:FF84: 20 1A FE  JSR $FE1A
0F:FF87: 4C 00 AD  JMP $AD00

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

