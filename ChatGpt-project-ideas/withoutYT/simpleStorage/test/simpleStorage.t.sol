// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {SimpleStorageDeployment} from "../script/SimpleStorage.s.sol";

contract SimpleStorageTest is Test {
    SimpleStorageDeployment public simplestorage;

    function setUp() public {
        simplestorage = new SimpleStorageDeployment();

    }

}