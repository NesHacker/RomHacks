; Section 1: check inventory space
0E:A4AD: AE 0C 03   LDX $030C
0E:A4B0: BD 20 60   LDA $6020, X
0E:A4B3: C9 63      CMP #$63
0E:A4B5: 90 08      BCC $A4BF

; Section 2: inventory full
0E:A4B7: A9 0C      LDA #$0C
0E:A4B9: 20 5B AA   JSR $AA5B
0E:A4BC: 4C 81 A4   JMP $A481

; Section 3: Add the items and remove gold
0E:A4BF: FE 20 60   INC $6020, X
0E:A4C2: 20 CD A4   JSR $A4CD

; Section 4: Sale Success
0E:A4C5: A9 13      LDA #$13
0E:A4C7: 20 5B AA   JSR $AA5B
0E:A4CA: 4C 81 A4   JMP $A481

; ------------------------------------------------------------------------------

; Section 1
0E:A4AD: AE 0C 03   LDX $030C
0E:A4B0: BD 20 60   LDA $6020, X
0E:A4B3: 18         CLC
0E:A4B4: 65 02      ADC $02
0E:A4B6: C9 64      CMP #$64
0E:A4B8: B0 0B      BCS $A4C5

; Section 3
0E:A4BA: 9D 20 60   STA $6020, X
0E:A4BD: 20 CD A4   JSR $A4CD

; Section 4
0E:A4C0: A9 13      LDA #$13
0E:A4C2: 4C C7 A4   JMP $A4C7

; Section 2
0E:A4C5: A9 0C      LDA #$0C
0E:A4C7: 20 5B AA   JSR $AA5B
0E:A4CA: 4C 81 A4   JMP $A481


; ------------------------------------------------------------------------------

0E:A4AD: AE 0C 03   LDX $030C
0E:A4B0: BD 20 60   LDA $6020, X

; Add the quantity, stored in RAM at $02
0E:A4B3: 18         CLC
0E:A4B4: 65 02      ADC $02

; Cancel the sale if the result is >= 100
0E:A4B6: C9 64      CMP #$64
0E:A4B8: B0 0B      BCS $A4C5

; Otherwise, add the items to the inventory
0E:A4BA: 9D 20 60   STA $6020, X
0E:A4BD: 20 CD A4   JSR $A4CD
0E:A4C0: A9 13      LDA #$13
0E:A4C2: 4C C7 A4   JMP $A4C7

; Set the "not enough room message"
0E:A4C5: A9 0C      LDA #$0C
; Render message and return
0E:A4C7: 20 5B AA   JSR $AA5B
0E:A4CA: 4C 81 A4   JMP $A481

; ------------------------------------------------------------------------------

.org $A4AD
  ldx $030C
  lda $6020, x
  clc
  adc $01
  cmp #$64
  bcs @no_space
  sta $6020, x
  jsr $A4CD
  lda #$13
  jmp @return
@no_space:
  lda #$0C
@return:
  jsr $AA5B
  jmp $A481
