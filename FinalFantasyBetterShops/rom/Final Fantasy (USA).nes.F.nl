$D841#A Pressed#
$FE1A#bank_swap#
$FE03#Bank Switch#
$ECB9#GetItemPrice#Given an item index in the accumlator, this will write the
\price of the item to $10-$11.
$FF82#swapAndJumpToHack#
$FDF2#callHack#
$D7E2#CommonJoy1Read#This appears to be the common place where JOY1 is read
\prior to handling specialized behavior.
$FE9C#nmi#
$C43C#oamDmaSetup#
$E0A8##
\This routine seems to be used to clear the menus in the
\the shops. Since they are all the same width you can use
\the same routine.
\
\$54 - VRAM Address (Low)
\$55 - VRAM Address (High)
\
$DE29#renderMenuRowTiles#[$3E-$3F] - Indirect Indexed Pointer (see $DE45)
$E12E#ppuScrollClear#This routine will clear PPU_SCROLL if $37 is non-zero
