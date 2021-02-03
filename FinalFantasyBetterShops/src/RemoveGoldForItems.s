; RemoveGoldForItems.s
; Hacks to remove the correct amount of gold for multiple items.

; TODO: This needs to be updated for 3 byte subtractions

; Every time the quantity to buy changes we recalculate the cost and store it
; in the zero page memory at $02-$03. So all we need to do to correctly remove
; the gold is replace the subtraction instructions to reference the zero page
; as opposed to the main memory where the item price is stored.

; [REPLACE] 0E:A4D1: ED 0E 03  SBC $030E
sbc $02         ; E5 02
nop             ; EA

; [REPLACE] 0E:A4DA: ED 0F 03  SBC $030F
sbc $03         ; E5 03
nop             ; EA
