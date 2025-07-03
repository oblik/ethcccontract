// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {EthCCTipFest} from "../src/EthCCTipFest.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract InteractTipFestScript is Script {
    EthCCTipFest public tipFest;
    
    // Contract addresses (update these based on your deployment)
    address constant DEPLOYED_CONTRACT = address(0); // Update this after deployment
    address constant USDC_BASE = 0x036CbD53842c5426634e7929541eC2318f3dCF7e; // Base Sepolia USDC
    address constant ETH_ADDRESS = address(0);
    
    // Test addresses
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address charlie = makeAddr("charlie");
    
    function setUp() public {
        // If contract is already deployed, use that address
        if (DEPLOYED_CONTRACT != address(0)) {
            tipFest = EthCCTipFest(payable(DEPLOYED_CONTRACT));
        } else {
            // Deploy for testing
            tipFest = new EthCCTipFest();
            console.log("EthCCTipFest deployed at:", address(tipFest));
        }
        
        // Fund test accounts
        vm.deal(alice, 10 ether);
        vm.deal(bob, 5 ether);
        vm.deal(charlie, 3 ether);
    }
    
    function run() public {
        console.log("=== EthCCTipFest Interaction Script ===");
        console.log("Contract address:", address(tipFest));
        console.log("Alice address:", alice);
        console.log("Bob address:", bob);
        console.log("Charlie address:", charlie);
        console.log("");
        
        // Test scenarios
        testETHTips();
        testUSDCTips();
        testEdgeCases();
        testOwnerFunctions();
        
        console.log("=== Interaction script completed ===");
    }
    
    function testETHTips() public {
        console.log("--- Testing ETH Tips ---");
        
        // Alice tips Bob 0.1 ETH
        vm.startPrank(alice);
        uint256 tipAmount = 0.1 ether;
        uint256 bobBalanceBefore = bob.balance;
        
        console.log("Alice balance before tip:", alice.balance / 1e18, "ETH");
        console.log("Bob balance before tip:", bobBalanceBefore / 1e18, "ETH");
        
        tipFest.sendTip{value: tipAmount}(
            bob,
            tipAmount,
            ETH_ADDRESS,
            "Great presentation at EthCC!"
        );
        
        uint256 bobBalanceAfter = bob.balance;
        console.log("Alice balance after tip:", alice.balance / 1e18, "ETH");
        console.log("Bob balance after tip:", bobBalanceAfter / 1e18, "ETH");
        console.log("Tip sent successfully! Bob received:", (bobBalanceAfter - bobBalanceBefore) / 1e18, "ETH");
        vm.stopPrank();
        
        // Bob tips Charlie
        vm.startPrank(bob);
        tipAmount = 0.05 ether;
        uint256 charlieBalanceBefore = charlie.balance;
        
        tipFest.sendTip{value: tipAmount}(
            charlie,
            tipAmount,
            ETH_ADDRESS,
            "Thanks for the networking!"
        );
        
        console.log("Bob tipped Charlie:", tipAmount / 1e18, "ETH");
        console.log("Charlie balance increased by:", (charlie.balance - charlieBalanceBefore) / 1e18, "ETH");
        vm.stopPrank();
        console.log("");
    }
    
    function testUSDCTips() public pure {
        console.log("--- Testing USDC Tips ---");
        
        // Note: This would require actual USDC tokens on the test network
        // For demonstration, we'll show how it would work
        console.log("USDC tips require actual USDC tokens on the network");
        console.log("To test USDC tips:");
        console.log("1. Acquire USDC tokens at:", USDC_BASE);
        console.log("2. Approve the tipFest contract to spend your USDC");
        console.log("3. Call sendTip with token parameter set to USDC address");
        console.log("");
        
        // Example of how to approve and tip USDC (commented out for demo)
        /*
        vm.startPrank(alice);
        IERC20 usdc = IERC20(USDC_BASE);
        uint256 usdcAmount = 10 * 1e6; // 10 USDC (6 decimals)
        
        // First approve the contract to spend USDC
        usdc.approve(address(tipFest), usdcAmount);
        
        // Then send the tip
        tipFest.sendTip(bob, usdcAmount, USDC_BASE, "USDC tip for you!");
        vm.stopPrank();
        */
    }
    
    function testEdgeCases() public {
        console.log("--- Testing Edge Cases ---");
        
        vm.startPrank(alice);
        
        // Test 1: Try to tip yourself (should fail)
        console.log("Testing self-tip (should fail)...");
        try tipFest.sendTip{value: 0.01 ether}(alice, 0.01 ether, ETH_ADDRESS, "Self tip") {
            console.log("ERROR: Self-tip should have failed!");
        } catch Error(string memory reason) {
            console.log("SUCCESS: Self-tip correctly rejected:", reason);
        }
        
        // Test 2: Try to tip with 0 amount (should fail)
        console.log("Testing zero amount tip (should fail)...");
        try tipFest.sendTip{value: 0}(bob, 0, ETH_ADDRESS, "Zero tip") {
            console.log("ERROR: Zero amount tip should have failed!");
        } catch Error(string memory reason) {
            console.log("SUCCESS: Zero amount tip correctly rejected:", reason);
        }
        
        // Test 3: Try to tip with mismatched ETH value (should fail)
        console.log("Testing mismatched ETH value (should fail)...");
        try tipFest.sendTip{value: 0.1 ether}(bob, 0.2 ether, ETH_ADDRESS, "Mismatched value") {
            console.log("ERROR: Mismatched value should have failed!");
        } catch Error(string memory reason) {
            console.log("SUCCESS: Mismatched value correctly rejected:", reason);
        }
        
        // Test 4: Try to tip with invalid token (should fail)
        console.log("Testing invalid token (should fail)...");
        try tipFest.sendTip{value: 0.01 ether}(bob, 0.01 ether, address(0x123), "Invalid token") {
            console.log("ERROR: Invalid token should have failed!");
        } catch Error(string memory reason) {
            console.log("SUCCESS: Invalid token correctly rejected:", reason);
        }
        
        vm.stopPrank();
        console.log("");
    }
    
    function testOwnerFunctions() public {
        console.log("--- Testing Owner Functions ---");
        
        address owner = tipFest.owner();
        console.log("Contract owner:", owner);
        
        // Test emergency withdraw (only if there are funds in the contract)
        uint256 contractBalance = address(tipFest).balance;
        console.log("Contract ETH balance:", contractBalance / 1e18, "ETH");
        
        if (contractBalance > 0) {
            vm.startPrank(owner);
            uint256 ownerBalanceBefore = owner.balance;
            
            tipFest.emergencyWithdraw(ETH_ADDRESS, contractBalance);
            
            uint256 ownerBalanceAfter = owner.balance;
            console.log("Emergency withdraw successful!");
            console.log("Owner balance increased by:", (ownerBalanceAfter - ownerBalanceBefore) / 1e18, "ETH");
            vm.stopPrank();
        } else {
            console.log("No ETH in contract to withdraw");
        }
        
        // Test that non-owner cannot call emergency withdraw
        vm.startPrank(alice);
        try tipFest.emergencyWithdraw(ETH_ADDRESS, 0.01 ether) {
            console.log("ERROR: Non-owner should not be able to call emergencyWithdraw!");
        } catch (bytes memory /* reason */) {
            console.log("SUCCESS: Non-owner correctly rejected from emergencyWithdraw");
        }
        vm.stopPrank();
        
        console.log("");
    }
    
    // Helper function to simulate receiving some ETH in the contract
    function fundContract() public {
        vm.deal(address(tipFest), 1 ether);
        console.log("Contract funded with 1 ETH for testing");
    }
    
    // Function to check balances
    function checkBalances() public view {
        console.log("=== Current Balances ===");
        console.log("Alice:", alice.balance / 1e18, "ETH");
        console.log("Bob:", bob.balance / 1e18, "ETH");
        console.log("Charlie:", charlie.balance / 1e18, "ETH");
        console.log("Contract:", address(tipFest).balance / 1e18, "ETH");
        console.log("========================");
    }
}
