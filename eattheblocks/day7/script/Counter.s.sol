// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Counter} from "../src/Counter.sol";
import {Script, console} from "forge-std/Script.sol";

contract CounterScript is Script {
    Counter counter;

    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast();
        counter = new Counter();
        counter.increment();
        counter.setNumber(29052024);
        vm.stopBroadcast();
    }
}