/**
 * Converts a text string to a series of bytes encoded for the legend of zelda.
 * I used this to quickly convert text strings so I could find and update them
 * in the ROM.
 *
 * @param {string} text Text to convert.
 * @return {string} The byte string for the text in legend of zelda encoding.
 */
function text2bytes (text) {
  const specialCharMap = {
    ' ': '24',
    ',': '28',
    '!': '29',
    '\'': '2A',
    '&': '2B',
    '.': '63',
    '"': '2D',
    '?': '2E',
    '-': '2F'
  }
  const ch2byte = c => {
    if (specialCharMap[c]) {
      return specialCharMap[c]
    }
    if (c.match(/[A-Z]/)) {
      let hex = (c.charCodeAt(0) - 55).toString(16)
      return (hex.length === 1 ? `0${hex}` : hex).toUpperCase()
    }
    throw new Error(`Cannot convert invalid character '${c}'.`)
  }
  return text.split('').map(ch2byte).join('')
}

console.log(
  // text2bytes('THE LEGEND OF ZELDA')      // 1A52E
  // text2bytes('THE WARRIOR PRINCESS')

  // text2bytes('MANY  YEARS  AGO  PRINCE') // 1A595
  // text2bytes('ONE NIGHT, WHILE ZELDA  ')

  // text2bytes('DARKNESS') // 1A5DB
  // text2bytes('WAS AT WORK, HER SCRUB  ')

  // text2bytes('ONE OF') // 1A621
  // text2bytes('ASS BOYFRIEND LINK BROKE')

  // text2bytes('POWER.') // 1A667
  // text2bytes('THE DAMN TRIFORCE AND   ')

  // text2bytes('HAD  ONE') // 1A6AD
  // text2bytes('HID THE PIECES!         ')

  // text2bytes('WITH WISDOM.') // 1A6F3
  // text2bytes('                        ')

  // text2bytes('IT INTO') // 1A739
  // text2bytes('GANNON THEN KIDNAPPED   ')

  // text2bytes('IT FROM') // 1A77F
  // text2bytes('LINK\'S DUMB ASS AND NOW ')

  // text2bytes('SHE WAS') // 1A7C5
  // text2bytes('ZELDA HAS TO SAVE HIM,  ')

  // text2bytes('  GO') // 1A80B
  // text2bytes('BEAT GANNON, AND FIND   ')

  // text2bytes('    LINK') // 1A851
  // text2bytes('THE TRIFORCE...         ')
)
