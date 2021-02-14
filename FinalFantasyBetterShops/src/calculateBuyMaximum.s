;
; calculateBuyMaximum
; Address:  06:BDA0 (01BDB0)
;
; For the selected consumable item in a shop, this helper determines a maximum
; for how many can be bought. It limits the maximum based on available inventory
; space and party gold. If the player cannot fit another item or does not have
; enough gold to buy the item then this sets the maximum to 1. The result of
; the routine is stored at `$0D`.
;
; I wrote the algorithm to do this in JavaScript first and hand compiled it here
; for fun. The original code I wrote is in `calculateBuyMaximum.js` and
; sprinkled throughout the implementation below in the form of comments.
;
.org $BDA0
calculateBuyMaximum:
  ; External routines
  calculateTotal = $BF90
  cmpTotalToGold = $BEB0

  ; Variables
  left = $02
  right = $03
  itemQuantity = $04
  result = $0D
  itemId = $030C
  inventoryTable = $6020

  ; // Determine based on inventory count
  ; let max = 99 - inventoryCount
  lda #99
  ldx itemId
  sec
  sbc inventoryTable, x
  sta itemQuantity

  ; let total = price * max
  jsr calculateTotal

  ; // If they have enough gold, then this is the maximum
  ; if (total <= gold) {
  ;   return max
  ; }
  jsr cmpTotalToGold
  beq *+4
  bcs @binarySearch
  lda itemQuantity
  bne *+4
  lda #1
  sta result
  rts

@binarySearch:
  ; // Use a binary search to find the maximum the party can afford

  ; let left = 0
  lda #0
  sta left

  ; let right = max - 1
  ldx itemQuantity
  dex
  stx right

  ; while (left < right) {
@loop:
  lda left
  cmp right
  bcs @break

  ;   max = (left + right) >> 1
  clc
  adc right
  lsr
  sta itemQuantity

  ;   total = price * max
  jsr calculateTotal

  ;   if (total < gold)
  ;     left = max + 1
  jsr cmpTotalToGold
  bcs @elseif
  ldx itemQuantity
  inx
  stx left
  jmp @loop

  ;   else if (total > gold)
  ;     right = max
@elseif:
  beq @break
  lda itemQuantity
  sta right
  jmp @loop

  ;   else
  ;     break
@break:

  ; // Return the maximum
  ; return max > 0 ? max : 1
  lda itemQuantity
  bne @skip
  lda #1
@skip:
  sta result
  rts
