// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {EthCCTipFest} from "../src/EthCCTipFest.sol";

contract EthCCTipFestTest is Test {
    EthCCTipFest public tipFest;
    address public alice = address(0x1);
    address public bob = address(0x2);

    function setUp() public {
        tipFest = new EthCCTipFest();
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
    }

    function test_SendETHTip() public {
        vm.prank(alice);
        tipFest.sendTip{value: 1 ether}(bob, 1 ether, address(0), "Great presentation!");
        
        assertEq(bob.balance, 11 ether);
    }

    function test_CannotTipYourself() public {
        vm.prank(alice);
        vm.expectRevert("Cannot tip yourself");
        tipFest.sendTip{value: 1 ether}(alice, 1 ether, address(0), "Self tip");
    }
}
