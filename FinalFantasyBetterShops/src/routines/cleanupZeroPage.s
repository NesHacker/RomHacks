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
