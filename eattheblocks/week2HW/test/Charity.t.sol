// test/BoxStorage.t.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Console.sol";
import {Test} from "forge-std/Test.sol";
import {Charity} from "../src/Charity.sol";

contract CharityTest is Test {
    event Donated(address indexed donator, uint256 amount);
    event Withdrawn(uint256 amount);
    Charity public charity;
    address owner = msg.sender;
    uint256 moneyCollectingDeadline;

    function test_canNotDonate() public {
        moneyCollectingDeadline = 0;
        charity = new Charity(owner,moneyCollectingDeadline);
        bool result=charity.canDonate();
        assertEq(result,false);
    }

    function test_canDonate() public {
        moneyCollectingDeadline = 1;
        charity = new Charity(owner,moneyCollectingDeadline);
        bool result=charity.canDonate();
        assertEq(result,true);
    }

    function test_canNotDonateAnymore() public {
        moneyCollectingDeadline = 1;
        charity = new Charity(owner,moneyCollectingDeadline);
        console.log(block.timestamp);
        vm.warp(block.timestamp + moneyCollectingDeadline + 1);
        console.log(block.timestamp);
        vm.expectRevert(Charity.CanNotDonateAnymore.selector);
        charity.donate{value: 1 ether}();
    }
    function test_NotEnoughDonationAmount() public {
        moneyCollectingDeadline = 1;
        charity = new Charity(owner,moneyCollectingDeadline);
        vm.expectRevert(Charity.NotEnoughDonationAmount.selector);
        charity.donate{value: 0 ether}();
    }
    function test_donate() public{
        moneyCollectingDeadline = 1;
        charity = new Charity(owner,moneyCollectingDeadline);
        address myAddress = address(1);
        uint256 donationAmount = 10 ether;
        vm.expectEmit(true, false, false, true);
        emit Donated(myAddress, donationAmount);
         
        console.log("Current balance of Charity contract:" , address(charity).balance);
        
        hoax(myAddress, donationAmount);

        charity.donate{value: donationAmount}();
        console.log("Current balance of Charity contract:" , address(charity).balance);

        assert(charity.userDonations(myAddress) == donationAmount);
        
    }

    function test_NotOwner() public{
        moneyCollectingDeadline = 1;
        charity = new Charity(owner,moneyCollectingDeadline);
        vm.expectRevert(Charity.NotOwner.selector);
        vm.deal(address(charity), 1 ether); 
        charity.withdraw(1 ether);
    }
    function test_NotEnoughMoney() public{
        moneyCollectingDeadline = 1;
        charity = new Charity(owner,moneyCollectingDeadline);
        vm.expectRevert(Charity.NotEnoughMoney.selector);
        vm.deal(address(charity), 1 ether);
        vm.prank(owner); 
        charity.withdraw(2 ether);
    }
    function test_TransferFailed() public{
        moneyCollectingDeadline = 1;
        charity = new Charity(owner,moneyCollectingDeadline);
        vm.deal(address(charity), 2 ether);

        vm.prank(owner);
        vm.expectRevert(Charity.TransferFailed.selector);
        vm.mockCall(
            address(charity),
            1 ether,
            abi.encodeWithSelector(Charity.withdraw.selector),
            abi.encode( bytes32(0))
        );
        charity.withdraw(1 ether);
    }
    function test_withdraw() public {
        uint256 currentBalance = address(this).balance;
        moneyCollectingDeadline = 1;
        charity = new Charity(owner,moneyCollectingDeadline);
        vm.deal(address(charity), 1 ether);
        vm.expectEmit(true, true, true, true);
        emit Withdrawn(address(charity).balance);
        vm.prank(owner);
        charity.withdraw(1 ether);

        assertEq(address(charity).balance, 0);
    }

}