;-------- Original Assembly ----------------------------------------------------

0E:AA88: AD 0C 03  LDA $030C
0E:AA8B: 20 B9 EC  JSR $ECB9
0E:AA8E: A5 10     LDA $10
0E:AA90: 8D 0E 03  STA $030E
0E:AA93: A5 11     LDA $11
0E:AA95: 8D 0F 03  STA $030F
0E:AA98: 4C 32 AA  JMP $AA32

;-------- New Source -----------------------------------------------------------

0E:AA88: A9 0E     LDA #$0E
0E:AA8A: 85 00     STA $00
0E:AA8C: A9 01     LDA #1
0E:AA8E: 85 01     STA $01
0E:AA90: 20 F2 FD  JSR $FDF2  ; callHack
0E:AA93: 4C 32 AA  JMP $AA32
