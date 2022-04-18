# profit-maximizer
Profit-maximizer is a smart contract designed to maximize profit for organizations sharing a common price policy. The scope of such organisations involve the ones that have bidirectional sales  relationship where the customers can sell to as well as buying from the organisation. Example of such organisations are precious metals companies and currency excange offices.  The contract allows such organisations to provide their recent buy and sell information. After the information is collected the contract can be called with a reference buy and sell price. Once the contract receives the reference buy and sell price from one of the members, the contract will return an array involving a suggested buy price and a suggested sell price. The suggested buy and sell price is created by shift the standard profit margin back and forth between buy and sell region depending of the recent trend that was provided to the contract by the organisations authorised by the contract.

## Contract
```ts
 import { PersistentDeque, Context } from "near-sdk-as";


  //create 2 persistent deques to store bought items and sold items
  let dequeItemsBought = new PersistentDeque<u32>("db");
  let dequeItemsSold = new PersistentDeque<u32>("ds");

 //collect the numbers of items bought and sold from a member
 export function collectMyBoughtSoldNums(boughtNum: u32, soldNum: u32): string {
  assert(authorizeAccount(), "You are not authorized to provide stats")
  dequeLengthLimiter(dequeItemsBought)
  dequeLengthLimiter(dequeItemsSold)
  dequeItemsBought.pushBack(boughtNum)
  dequeItemsSold.pushBack(soldNum)
  return "Thank you for submitting your information"
}

//allows certaim number of  elements in the PersistentDeque and removes one from the front if there are more.
export function dequeLengthLimiter(dequeName: PersistentDeque<u32>): void {
  if (dequeName.length > 2) {
    dequeName.popFront()
  }
}

//calculate the average(mean) from a sum and length of a given PersistentDeque
export function calculateDequeAverage(dequeName: PersistentDeque<u32>): f32 {
  assert(!dequeName.isEmpty, "Members did not provide any information yet")
  return (calculateDequeSum(dequeName) as f32) / (dequeName.length as f32)
}

//calculate the sum of the elements of a PersistentDeque
export function calculateDequeSum(dequeName: PersistentDeque<u32>): u32 {
  let dequeSum: u32 = 0;
  for (let i = 0; i < dequeName.length; ++i) {
   dequeSum = dequeSum + dequeName[i];
  }
  return dequeSum
}
//calculate a coefficient depending on the ratio of average number of items bought and sold
export function calculateProfitMaximizingCoefficient(): f32 {
  return calculateDequeAverage(dequeItemsBought) / calculateDequeAverage(dequeItemsSold)
}

//return an array containing the suggested buy price and the suggested sell price
export function getSuggestedBuyAndSellPrice(referenceBuyPrice: u32, referenceSellPrice: u32  ): Array<u32> {
  assert(authorizeAccount(), "You are not authorized to get suggested buy and sell price")
  /*The function aims to return suggested buy and sell price via the array below,
  suggestedBuyAndSellPrice[0] will be the suggested buy-price while suggestedBuyAndSellPrice[1] will be the suggested sell-price*/
  let suggestedBuyAndSellPrice = new Array<u32>(2);
  //standard profit can be manipulated by changing the value of standardProfit 
  const standardProfit: u32 = 10;
  const standardBuyPrice:u32 = referenceBuyPrice - standardProfit;
  const standardSellPrice:u32 = referenceSellPrice + standardProfit;
  let coefficientNum: f32 = calculateProfitMaximizingCoefficient();
  
   /*(coefficientNum>1) is the case where members bought more than they sold. Hence, the suggested price decreases the standard sell price
   by the amount of coefficientNum to profit more. It also decreases the suggested buy price
   in order to keep the margin unchanged */
   if (coefficientNum > 1) {
    suggestedBuyAndSellPrice[0]=  standardBuyPrice - (coefficientNum as u32)
    suggestedBuyAndSellPrice[1]=  standardSellPrice - (coefficientNum as u32)
   }
   /* (coefficientNum == 1) is a rare case where members bought exactly same as they sold. In such
   a case standard prices apply.*/
   if (coefficientNum == 1) {
    suggestedBuyAndSellPrice[0]= standardBuyPrice
    suggestedBuyAndSellPrice[1]= standardSellPrice
   }
   /*(coefficientNum < 1) is the case where members bought less than they sold from the customers, 10/(coefficientNum*10) allows us 
   to reverse-divide the elements of calculateProfitMaximizingCoefficient()*/
   if (coefficientNum < 1) {
    coefficientNum = (10 as f32) / (coefficientNum * (10 as f32))
    /*since members bought less than they sold, the suggested price increases the standard sell price
    by the amount of coefficientNum to profit more. It also increases the suggested buy price
    in order to keep the margin unchanged */
    suggestedBuyAndSellPrice[0]=  standardBuyPrice + (coefficientNum as u32)
    suggestedBuyAndSellPrice[1]=  standardSellPrice + (coefficientNum as u32)
   }
  return suggestedBuyAndSellPrice
}

//the important functions of the contract can only be called by the following accounts
export function authorizeAccount(): boolean {
  return (
    Context.sender == "<Your account ids here>" ||
    Context.sender == "<Your account ids here>"
  );
}
```
