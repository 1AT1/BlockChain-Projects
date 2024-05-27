// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract Bank{
    //Declaringg point manager interface 
    IPointManager pointManager;
    uint256 constant tenDays = 10 days; // 10 dayss in seconds
    uint256 constant thirtyDays = 30 days; // 30 days in seconds
    uint256 constant minimumDeposit = 0.001 ether; // min eth that user can deposit

    //declaration of struct
    struct Account{
        address user;
        uint256 creationDate;
        uint256 balance;
    }
    Account[] accounts;

    //mappings
    mapping(address => Account) accountDetails;
    mapping(address => bool) userExist;

    //errors
    error AccountAlreadyExists(address account);
    error AccountDoesNotExist(address account);
    error NotEnoughDeposit();
    error InsufficientBalance(uint256 amountRequested, uint256 currentBalance);
    error TransferFailed();

    //events
    event AccountCreated(Account account);
    event Deposited(address addr, uint256 amount);
    event Withdrawn(address addr, uint256 amount);

    // defining point manager interface in constructor
    constructor(address _pointManagerAddress){
        pointManager = IPointManager(_pointManagerAddress);
    }

    //functions
    function createAccount() external {
        if(userExist[msg.sender]){
            revert AccountAlreadyExists(msg.sender);
        }
        Account memory account = Account(msg.sender, block.timestamp, 0);
        accountDetails[msg.sender] = account;
        userExist[msg.sender] = true;
        emit AccountCreated(account);
    }
    function deposit() external payable {
        if(!userExist[msg.sender]){
            revert AccountDoesNotExist(msg.sender);
        }
        if(msg.value < minimumDeposit){
            revert NotEnoughDeposit();
        }

        accountDetails[msg.sender].balance += msg.value;
        pointCalculation(msg.value, msg.sender);
        emit Deposited(msg.sender, msg.value);
    }
    function withdraw(uint256 _withdrawalAmount) external{
       if(accountDetails[msg.sender].balance < _withdrawalAmount){
            revert InsufficientBalance(_withdrawalAmount, accountDetails[msg.sender].balance);
        }
         (bool success, ) = payable(msg.sender).call{value:_withdrawalAmount}("");
        if(!success){
            revert TransferFailed();
        }
        accountDetails[msg.sender].balance -= _withdrawalAmount;
        emit Withdrawn(msg.sender,_withdrawalAmount );
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
}

//Interface for Point Manager
interface IPointManager {
    function addPoints(address user, uint256 points) external;
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