// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage public simplestorage;

    function setUp() public {
        simplestorage = new SimpleStorage();
        simplestorage.setNumber(0);
    }

    function test_setNumber() public {
        simplestorage.setNumber(1);
        assertEq(simplestorage.number(), 1);
    }

    function test_getNumber() public {
        simplestorage.setNumber(1);
        uint256 Return = simplestorage.getNumber();
        assertEq(Return, 1);
    }
}