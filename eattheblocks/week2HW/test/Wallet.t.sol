// test/BoxStorage.t.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";
import {ICharity} from "../src/ICharity.sol";
import {Charity} from "../src/Charity.sol";

contract BoxStorageTest is Test {
   Wallet public wallet;
   address owner = msg.sender;
   address charityOwner = address(1);
   Charity public charity;
   uint256 public charityPercentage = 50; // 5 percent

   function setUp() public{
     charity = new Charity(charityOwner, 1 days);
     wallet = new Wallet(owner, address(charity), charityPercentage);
   }

   function test_RevertWhen_CanNotDepositZeroEthers() public {
        vm.expectRevert(Wallet.CanNotDepositZeroEthers.selector);
        wallet.deposit{value: 0}();
    }
    function test_deposit() public {
        address depositor = address(3);
        vm.startPrank(depositor);
        vm.deal(depositor, 1 ether);
        wallet.deposit{value: 1 ether}();
        uint256 expectedCharityDonation = (1 ether * charityPercentage) / 1000;
        assertEq(expectedCharityDonation,address(charity).balance);
        vm.stopPrank();
    }

    function test_NotOwner() public{
        address theif = address(5);
        wallet.deposit{value: 1 ether}();
        vm.expectRevert(Wallet.NotOwner.selector); 
        vm.startPrank(theif);
        wallet.withdraw(1 ether);
        vm.stopPrank();
       
    }
    function test_NotEnoughMoney() public{
        vm.expectRevert(Wallet.NotEnoughMoney.selector);
        vm.startPrank(owner);
        wallet.withdraw(1 ether);
        vm.stopPrank();
    }
    function test_withdraw() public{
        uint256 currentBalance = owner.balance;
        wallet.deposit{value: 2 ether}();
        vm.startPrank(owner);
        wallet.withdraw(1 ether);
        vm.stopPrank();
        assertEq(currentBalance+1 ether,owner.balance);

    }

    function test_TransferFailed() public{
        //MY CODE

        vm.prank(owner);
        vm.expectRevert(Wallet.TransferFailed.selector);
        vm.mockCall(
            address(owner),
            1 ether,
            abi.encodeWithSelector(Charity.withdraw.selector),
            abi.encode( bytes32(0))
        );
        charity.withdraw(1 ether);
    }

}