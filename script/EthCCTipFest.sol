// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {EthCCTipFest} from "../src/EthCCTipFest.sol";

contract EthCCTipFestScript is Script {
    EthCCTipFest public tipFest;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        tipFest = new EthCCTipFest();
        console.log("EthCCTipFest deployed to:", address(tipFest));

        vm.stopBroadcast();
    }
}
