// src/Charity.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Charity{
    address public owner;

    event Donated(address indexed donator, uint256 amount);
    event Withdrawn(uint256 amount);

    error CanNotDonateAnymore();
    error NotEnoughDonationAmount();
    error NotOwner();
    error NotEnoughMoney();
    error TransferFailed();

    mapping(address => uint256) public userDonations;

    uint256 public moneyCollectingDeadline;

    constructor(address _owner, uint256 _moneyCollectingDeadline) {
        owner = _owner;
        moneyCollectingDeadline = block.timestamp + _moneyCollectingDeadline;
    }
    function canDonate() public view returns(bool) {
        return moneyCollectingDeadline > block.timestamp;
    }

    function donate() external payable {
        if (!canDonate()) {
            revert CanNotDonateAnymore();
        }
        if(msg.value == 0) {
            revert NotEnoughDonationAmount();
        }

        userDonations[msg.sender] += msg.value;

        emit Donated(msg.sender, msg.value);
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

        emit Withdrawn(currentBalance);
    }
}

