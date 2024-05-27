// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

// interface is defined here
interface IpointManager{
    function addPoints(address user, uint256 points) external;
}

contract Bank{
    IpointManager pointManager;
    uint256 constant tenDays = 864000; // 10 dayas in seconds
    uint256 constant thirtyDays = 2592000 ; // 30 days in seconds
    uint256 constant minimumDeposit = 1000000000000000; // min wei that user can deposit(0.001)

    constructor(address _pointManagerAddress){
        pointManager = IpointManager(_pointManagerAddress);
    }

    //errors
    error UserAlreadyExist(Account account);
    error NoAccountCreated();
    error MinDeposit(uint256 minimumDeposit);
    error NoSufficientBalance();
    error transactionFailed();

    //events
    event AccountCreated(Account account);
    event Deposited(address addr, uint256 amount);
    event Withdrawn(address addr, uint256 amount);

    struct Account{
        address userAddress;
        uint256 creationDate;
        uint256 balance;
    }

    mapping(address => Account) accountDetails;
    mapping(address => bool) userExist;

    function getAccountDetails() external view returns(Account memory){
        return accountDetails[msg.sender];
    }

    function createAccount() external{
        if(userExist[msg.sender]){
            revert UserAlreadyExist(accountDetails[msg.sender]);
        }
        Account memory account = Account(msg.sender, block.timestamp, 0);
        accountDetails[msg.sender] = account;
        userExist[msg.sender] = true;
        emit AccountCreated(account);
    }

    function pointCalculation(uint256 _depositAmount, address _address) private {
        uint256 creationDate = accountDetails[_address].creationDate;
        uint256 timeDiff = block.timestamp - creationDate; // calculating time difference 

        uint256 depositEarnedPoint =  _depositAmount / 10; // calculating 10 percent of deposited money whic is point
        uint256 totalPoints;

        // adding points base on the duration of the account
        if( timeDiff < tenDays){
            totalPoints = depositEarnedPoint + 1;
            pointManager.addPoints(_address, totalPoints);
        }else if(timeDiff < thirtyDays){
            totalPoints = depositEarnedPoint + 3;
            pointManager.addPoints(_address, totalPoints);
        }else{
            totalPoints = depositEarnedPoint + 5;
            pointManager.addPoints(_address, totalPoints);
        }
    }

    function deposit() external payable{
        if(!userExist[msg.sender]){
            revert NoAccountCreated();
        }
        if(msg.value < minimumDeposit){
            revert MinDeposit(minimumDeposit);
        }

        accountDetails[msg.sender].balance += msg.value;
        pointCalculation(msg.value, msg.sender);
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 _withdrawalAmount) external{
        if(accountDetails[msg.sender].balance < _withdrawalAmount){
            revert NoSufficientBalance();
        }
         (bool success, ) = payable(msg.sender).call{value:_withdrawalAmount}("");
        if(!success){
            revert transactionFailed();
        }
        accountDetails[msg.sender].balance -= _withdrawalAmount;
        emit Withdrawn(msg.sender,_withdrawalAmount );

    }

}

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
    
}