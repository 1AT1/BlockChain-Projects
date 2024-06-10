/* 
  Optimize gas consumption.
*/
// SPDX-License-Identifier: UNLICENSED
/*Before optimisation
	gas limit: 670844 gas
    transaction cost: 583342 gas
    execution cost: 492522 gas 
*/
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
/* After optimisation
    - Changed distributed mapping to an Event
    - Changed memory to calldata in batchProcess function 
    - Cache sender balance to minimise storage reads
    gas limit: 324125 gas
    transaction cost: 281847 gas 
    execution cost: 211655 gas
*/

contract BatchProcessor2 {
    mapping(address => uint) public balances;
    //mapping(address => mapping(address => uint)) public distributed;
    event distributed(address indexed receiver, address indexed contributor, uint256 amount);

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function batchProcess(address[] calldata recipients, uint[] calldata amounts) public {
        require(recipients.length == amounts.length, "Arrays must be of equal length");
        
        uint senderBalance = balances[msg.sender]; 

        for (uint i = 0; i < recipients.length; i++) {
            require(senderBalance >= amounts[i], "Insufficient balance");
            senderBalance -= amounts[i];
            balances[recipients[i]] += amounts[i];
            emit distributed(recipients[i],msg.sender,amounts[i]);
            //distributed[msg.sender][recipients[i]] = amounts[i];
        }
    }
}