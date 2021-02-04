$A95A#Increment Cursor#
$A924#Position Cursor Y#
$A94E#Decrement Cursor#
$A965#Set Cursor Position#
$A93C##; Check D-Pad Input
$A484#Hook: OnShopExit#
$A4BF#OnInventoryAdd#
$A4CD#Remove Gold for Item#
$AA6A#Select Item To Buy#
$A489#Hook: OnShopExit Reentry#
$AD00#executeHack (bank $06)#
$82F5#callHack0E#
$8469#onShopExit#
$8472#@exit#
$AA8E#Hook: OnItemSelected#
$AA9B#Hook: OnItemSelected (END)#
$A4E8#OnInventoryAdd (END)#
$A4AD#Check Item Inventory Limit (99)#
$A761#ReturnCommonJoyRead#
$A934##If B pressed ($25 != 0): GOTO $A96A
$A938##If A pressed ($24 != 0): GOTO $A974
$A96B##Clear controller related state.
$A492##Note: Carry is set when pressing B on the item select menu.
$A774##This can only be reached on an input other than up, down,
\A or B.
$84E3#onQuantityChange#
