$A95A#Increment Cursor#
$A924#Position Cursor Y#
$A94E#Decrement Cursor#
$A965#Set Cursor Position#
$A93C#Check Cursor Move#
$A484#After A Pressed#
$A4BF#Add Bought Item to Inventory#
$A4B0#Check Item Inventory Limit (99)#
$A4CD#Remove Gold for Item#
$AA6A#Select Item To Buy#
$AA8E#JSR Hook: Initialize Price / Quantity - START#
$AA98#JSR Hook: Initialize Price / Quantity - END#
$A487#JSR Hook: Shop Exit[1]#
$A486#JSR Hook: Shop Exit#Need to jump into the shop exit cleanup routine here.
\Use all 4 bytes to handle this from $A486 - $A48B.
