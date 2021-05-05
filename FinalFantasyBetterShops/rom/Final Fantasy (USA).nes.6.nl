$ACA0#hackMethodAddressTable#
$AD00#executeHack#
$AD20#cleanupZeroPage#
$AD30#initializePriceQuantity#
$BF90#calculateTotal#
$AD90#renderQuantityAndTotal#
$BF50#quantityToBCD#
$BF59#@loop#
$BF20#updateShopState#
$ADC1#@loop#
$AE02#renderDigits#
$AE17#@lowNibble#
$AE2A#@return#
$AE11#renderDigits#
$BED0#incrementQuantity#
$BF80#isConsumable#
$BE80#decrementQuantity#
$AD60#changeQuantity#
$AD81#@return#
$AD7E#@update#
$AD7B#@decrement#
$BE20#totalToBCD#
$BE33#@loop#
$BE35#@highNibble#
$BE40#@lowNibble#
$BEB0#cmpTotalToGold#
$BDA0#calculateBuyMaximum#// Determine based on inventory count
\let max = 99 - inventoryCoun
$BEC3#@return#
$BE87#@setValue#
$BEDC#@setValue#
$AD38#@continue#
$AD46#@continue#
$AE60#buyItems#
$BDB5#@return#
$BDBE#@continue#let left = 0
$AE75#@itemsOk#
$AE81#goldOk#
$BFA4#@shift#
$BFB1#@skip#
$BDC7#@loop#while (left < right) {
$BDAB##let total = price * max
$BDAE##// If they have enough gold, then this is the maximum
\if (total <= gold) {
\  return max
\}
$BDC2##let right = max - 1
$BDCD##  max = (left + right) >> 1
$BDD3##  total = price * ma
$BDD6##  if (total < gold)
\    left = max + 1
$BDE3##  else if (total > gold)
\    right = max
$BDEC##  else break
\}
\
\return max > 0 ? max : 1
