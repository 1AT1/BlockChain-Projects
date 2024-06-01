// src/ICharity.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ICharity {
    function donate() external payable;
    function canDonate() external view returns(bool);
}