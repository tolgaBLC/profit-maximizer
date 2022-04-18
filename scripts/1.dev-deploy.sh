echo ---------------------------------------------------------
echo "Step 1: Build the contract (may take a few seconds)"
echo ---------------------------------------------------------
echo

yarn build:release

echo
echo
echo ---------------------------------------------------------
echo "Step 2: Deploy the contract"
echo ---------------------------------------------------------
echo

near dev-deploy ./build/release/simple.wasm

echo ---------------------------------------------------------
echo "Step 3: Prepare your environment for next steps"
echo
echo "(a) find the contract (account) name in the message above"
echo "    it will look like this: [ Account id: dev-###-### ]"
echo
echo "(b) set an environment variable using this account name"
echo "    see example below (this may not work on Windows)"
echo
echo ---------------------------------------------------------
echo 'export CONTRACT=<dev-123-456>'
echo
echo
echo ---------------------------------------------------------
echo "Step 4: Provide numbers of items bought and sold to the contract from each account: "
echo
echo "near call $CONTRACT --accountId <Your Account Number> collectMyBoughtSoldNums '{"boughtNum":<Your u32 number here>,"soldNum":<Your u32 number here>}'"
echo
echo ---------------------------------------------------------
echo
echo "Step 5: Provide a reference buy price and a reference sell price to the contract in order to get a suggested buy and sell price: "
echo
echo "near call $CONTRACT --accountId <Your Account Number> getSuggestedBuyAndSellPrice '{"referenceBuyPrice":<Your u32 number here>,"referenceSellPrice":<Your u32 number here>}'"
echo
echo ----------------------------------------------------------
echo
exit 0
