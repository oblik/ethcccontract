# EthCCTipFest Interaction Script

## Overview
The `InteractTipFest.s.sol` script demonstrates how to interact with the EthCCTipFest contract. It includes comprehensive testing of all contract features.

## Features Tested

### 1. ETH Tips
- Sending ETH tips between users
- Verifying balance changes
- Testing with different amounts

### 2. USDC Tips
- Instructions for testing USDC tips (requires actual tokens)
- Approval and transfer flow

### 3. Edge Cases
- ✅ Preventing self-tipping
- ✅ Rejecting zero-amount tips
- ✅ Validating ETH value matches tip amount
- ✅ Restricting to only ETH and USDC tokens

### 4. Owner Functions
- Emergency withdraw functionality
- Access control verification

## How to Run

### Local Testing
```bash
forge script script/InteractTipFest.s.sol:InteractTipFestScript
```

### On Testnet (e.g., Base Sepolia)
```bash
forge script script/InteractTipFest.s.sol:InteractTipFestScript \
    --rpc-url https://sepolia.base.org \
    --private-key $PRIVATE_KEY \
    --broadcast
```

### With Contract Already Deployed
1. Update the `DEPLOYED_CONTRACT` constant in the script with your deployed contract address
2. Run the script

## Script Functions

- `testETHTips()` - Tests ETH tipping functionality
- `testUSDCTips()` - Shows how to test USDC tips
- `testEdgeCases()` - Tests security measures and validation
- `testOwnerFunctions()` - Tests owner-only functions
- `checkBalances()` - Helper to view all balances

## Example Output
```
=== EthCCTipFest Interaction Script ===
Contract address: 0x5aAdFB43eF8dAF45DD80F4676345b7676f1D70e3
Alice address: 0x328809Bc894f92807417D2dAD6b7C998c1aFdac6
Bob address: 0x1D96F2f6BeF1202E4Ce1Ff6Dad0c2CB002861d3e

--- Testing ETH Tips ---
Alice balance before tip: 10 ETH
Bob balance before tip: 5 ETH
Tip sent successfully! Bob received: 0.1 ETH

--- Testing Edge Cases ---
SUCCESS: Self-tip correctly rejected: Cannot tip yourself
SUCCESS: Zero amount tip correctly rejected: Amount must be > 0
```

## Contract Events
The script will trigger the following events:
- `TipSent` - Emitted when a tip is successfully sent
- `OwnershipTransferred` - Emitted during contract deployment

## Notes
- The script creates test addresses (alice, bob, charlie) for demonstration
- All tests use try/catch blocks to handle expected failures gracefully
- The script is safe to run multiple times
- For USDC testing, you'll need actual USDC tokens on the target network
- 0xbB0C6AC2BfA02299B7572e429d9736892B45D0e7 tetsnet contract address
- 0xAD8b3c1C7706662a0A3bdc3757c0E5A02987BA98 mainnet contract