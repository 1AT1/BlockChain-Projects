// src/Wallet.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ICharity} from "./ICharity.sol";

contract Wallet {
    address public owner;
    ICharity public charity;
    uint256 charityPercentage;

    error CanNotDepositZeroEthers();
    error NotOwner();
    error NotEnoughMoney();
    error TransferFailed();

    constructor(address _owner, address _charityAddress, uint256 _charityPercentage) {
        owner = _owner;
        charity = ICharity(_charityAddress);
        charityPercentage = _charityPercentage;
    }

    function deposit() external payable {
        if(msg.value == 0) {
            revert CanNotDepositZeroEthers();
        }

        if(charity.canDonate()) {
            uint256 charityAmount = (msg.value * charityPercentage) / 1000; 
            charity.donate{value: charityAmount}();
        }
    }

    function withdraw(uint256 amount) external {
        if(msg.sender != owner) {
            revert NotOwner();
        }

        uint256 currentBalance = address(this).balance;
        if(amount > currentBalance) {
            revert NotEnoughMoney();
        }

        (bool success, ) = payable(owner).call{value: amount}("");

        if(!success) {
            revert TransferFailed();
        }
    }
}