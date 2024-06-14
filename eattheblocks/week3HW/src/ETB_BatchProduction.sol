// SPDX-License-Identifier:MIT
pragma solidity 0.8.23;

contract BatchProcessor {
    mapping(address => uint) public balances;
    event Distribution (
        address sender,
        address recipient,
        uint amount
    );
    error RecipientsAndAmountsNotEqualError();
    error BalanceTooLowError();

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function batchProcess(address[] calldata recipients, uint[] calldata amounts) external {
        if(recipients.length != amounts.length) {
            revert RecipientsAndAmountsNotEqualError();
        }

        for (uint i = 0; i < recipients.length; i++) {
            uint initialBalanceSender = balances[msg.sender];
            if(initialBalanceSender < amounts[i]) {
                revert BalanceTooLowError();
            }
            balances[msg.sender] = initialBalanceSender - amounts[i];
            balances[recipients] += amounts[i];
            emit Distribution(msg.sender, recipients[i], amounts[i]);
        }
    }
}