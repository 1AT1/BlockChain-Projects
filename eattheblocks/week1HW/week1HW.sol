/*Objective: Develop a smart contract "Bank" where users can create account, receives deposits and let withdraw them.
Each time user deposits any amount it should call `PointManager` function "addPoints". `PointManager` is a kind of loyalty program.

Requirements:
1. Create an interface of "PointManager" IPointManager with necessary function declaration.
2. In "Bank" smart contract define `IPointManager pointManager` which will be set in constructor.
3. Create a struct `Account` with fields:
  3a. address user
  3b. uint256 creationDate
  3c. uint256 balance
4. Implement function which will calculate how many points user should receive. 
   Option 1: It can calculate 10% of deposited amount as points 
   Option 2: It can check when account was created and the longer user have the account the more points receives, 
             like if created <10 days ago then receives 1 point
             if created <30 days ago then receives 3 points
             else receives 5 points
5. Create function for creating account, so it should check if account already exists, if yes then reverts, else it creates.
6. Create deposit function which will be able to receive ETH from users. Use calculating function defined above to calculate points and call `PointManager` to add points to user.
  6a. Check if user has created account, if not then revert.
  6b. Require that minimum deposit should be 0.001 ETH, in other way it should revert.
  6c. Update user balance and call `PointManager` `addPoints` function if every requirement is met.
7. Create withdraw function which will let user specify how much ethers wants to withdraw.
  7a. Make sure user has equal or more ethers in balance than provided in parameter, revert if not
8. For all errors create custom errors.
9. Create all necessary events, like AccountCreated, Deposited, Withdrawn.


Hints
To check the Ether's value sent to function use msg.value.
To track users accounts use mapping(address => Account) accounts. If either `user` is address(0) or `creationDate` is 0 then it means user have not created account yet.
PointManagers "addPoints" function requires to be called by owner, so after deploying both contracts you should use "changeOwner" function to set owner to "Bank" contract address.

*/


// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract PointManager {
    address owner;
    mapping(address => uint256) public userPoints;
    
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function addPoints(address user, uint256 points) external onlyOwner {
        userPoints[user] += points;
    }

    function changeOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }
    
    /*
    
      other functions
    
    */
}