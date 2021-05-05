;------- JSR/RTS Example Code --------------------------------------------------

C000: 20 04 C0  JSR $C004
C003: 60        RTS
C004: A9 01     LDA #1
C006: 85 00     STA $00
C008: 20 0C C0  JSR $C00C
C00B: 60        RTS
C00C: 85 02     STA $02
C00E: 60        RTS
