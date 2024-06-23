// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {simpleStorage} from "../src/simpleStorage.sol";

contract simpleStorageTest is Test {
    simpleStorage public SimpleStorage;

    function setUp() public {
        SimpleStorage = new simpleStorage();
        simpleStorage.setNumber(0);
    }

    function test_setNumberWorks() public {
        simpleStorage.setNumber(1);
        assertEq(simpleStorage.number(), 1);
    }
    
    function test_setNumberDoesNotWork() public {
        simpleStorage.setNumber(2);
        assertEq(simpleStorage.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}