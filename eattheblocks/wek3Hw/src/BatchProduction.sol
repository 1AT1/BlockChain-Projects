/* 
  Optimize gas consumption.
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

contract BatchProcessor {
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public distributed;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function batchProcess(address[] memory recipients, uint[] memory amounts) public {
        require(recipients.length == amounts.length, "Arrays must be of equal length");

        for (uint i = 0; i < recipients.length; i++) {
            require(balances[msg.sender] >= amounts[i], "Insufficient balance");
            balances[msg.sender] -= amounts[i];
            balances[recipients[i]] += amounts[i];
            distributed[msg.sender][recipients[i]] = amounts[i];
        }
    }
}