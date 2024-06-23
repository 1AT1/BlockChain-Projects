// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

contract SimpleStorage {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function getNumber() public view returns(uint256) {
        return number;
    }
}
