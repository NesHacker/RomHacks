# Zelda: Warrior Princess
A Graphics ROM Hack for "The Legend of Zelda"

## Notes

### Overview

1. Replaced the movement sprites
  - Used YY-CHR to find the sprite locations and data
  - Copied it over to photoshop to do the art
  - Copied it back and did palette replacements in YY-CHR
  - Once the bulk of the work was done I just used YY-CHR for touchups
2. Title screen text update (warrior princess)
  - Found this using YY-CHR
  - Had to fidget with the settings a bit to zone in on the location
  - Did all the graphics in YY-CHR
3. Closing text "Thanks Link" replacement
  - Wrote a zelda text encoding script
  - Found the text using the script, did a simple byte replacement
4. Opening Story Text Rewrite
  - Found all text using the script I wrote & replaced story
  - Cleaned up "quotation" marks from original story
5. Opening Story Attribute Table Changes
  - Ran the game until the PPU attribute table was updated, then looked
    the PPU memory to see its contents.
  - Found the ROM locations for the attribute table by simply copying the
    values from the PPU memory and searching for them in the ROM.
  - Tables were split with the upper half in one spot and the lower in another.
  - Upper Table ROM Address: `1A8B6`
  - Lower Table ROM Address: `1A8D9`
  - Did a live edit of the attribute PPU memory to get the colors right and
    then just copied the PPU ram and replaced the ROM values I had already
    found.


### Story Attribute Table Replacements

**First Half (1A8B6):**
```
FFFF00000000FFFF
FF0B0A0A0A0A0EFF
FF000000C03A0AFF
FF000005050100FF
```

**Second Half (1A8D9):**
```
FFA02000000000FF
FF00000000C0F0FF
FF005A5A000000FF
FFFFFFFFFFFFFFFF
```


### New Story Text
```
------------------------
ONE NIGHT, WHILE ZELDA
WAS AT WORK, HER SCRUB
ASS BOYFRIEND LINK BROKE
THE DAMN TRIFORCE AND
HID THE PIECES...

GANNON THEN KIDNAPPED
LINK'S DUMB ASS AND NOW
ZELDA HAS TO SAVE HIM,
BEAT GANNON, AND FIND
THE TRIFORCE...
------------------------
```

- `THE LEGEND OF ZELDA`: `$00A52E`

### Ending "THANKS" Text

- `Address: 00A969`
- `Old: 1D 11 0A 17 14 1C 24 15 12 17 14 28 22 18 1E 2A 1B`
- `New: 22 18 28 24 23 0E 15 0D 0A 28 24 24 22 18 1E 2A 1B`


