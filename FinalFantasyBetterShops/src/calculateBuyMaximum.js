const calculateBuyMaximum = (inventoryCount, gold, price) => {
  // Determine based on inventory count
  let max = 99 - inventoryCount
  let total = price * max

  // If they have enough gold, then this is the maximum
  if (total <= gold) {
    return max
  }

  // Use a binary search to find the maximum the party can afford
  let left = 0
  let right = max - 1
  while (left < right) {
    max = (left + right) >> 1
    total = price * max
    if (total < gold)
      left = max + 1
    else if (total > gold)
      right = max
    else
      break
  }

  // Return the maximum
  return max > 0 ? max : 1
}

const test = (inventoryCount, gold, price, expected) => {
  console.log('TEST:')
  console.log(`> inventory: ${inventoryCount}`)
  console.log(`>      gold: ${gold}`)
  console.log(`>     price: ${price}`)
  console.log(`>  Expected: ${expected}`)
  const result = calculateBuyMaximum(inventoryCount, gold, price)
  console.log('---------------------------------------')
  console.log(`>    Result: ${result}`)
  console.log('---------------------------------------')
  console.log(result === expected ? 'PASS' : 'FAIL')
  console.log('---------------------------------------\n')
}

test(0, 123, 60, 2)
test(0, 10000, 75, 99)
test(13, 5000, 1500, 3)

test(4, 3301, 250, 13)
