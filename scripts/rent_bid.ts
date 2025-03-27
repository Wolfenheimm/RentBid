

import { deploy } from './ethers-lib'

(async () => {
  try {
    const result = await deploy('RentBid', ['0x9F1e4bdE1110d76a0d140c8e7A44375E6EaEcc04', 1])
    console.log(`Contract deployed at address: ${result.address}`)

    const bid = await result.highestBid()
    console.log(`Highest bid amount: ${bid.amount.toString()}`)
    console.log(`Highest bidder: ${bid.bidder}`)
  } catch (e) {
    console.log('Error:', e.message)
  }
})()