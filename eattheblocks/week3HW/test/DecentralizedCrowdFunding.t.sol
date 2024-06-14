// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DecentralizedCrowdfunding} from "../src/DecentralizedCrowdfunding.sol";

contract CounterTest is Test {
    DecentralizedCrowdfunding public DCf;
    event CampaignCreated(uint256 indexed campaignId, address owner, uint256 goal, uint256 deadline);

     uint256 public numCampaigns = 0;



    function setUp() public {
        DCf = new DecentralizedCrowdfunding();
        
    }

    function test_createCampaign_invalidGoal() public{
        vm.expectRevert(DecentralizedCrowdfunding.InvalidGoal.selector);
        DCf.createCampaign(0, 100 days);
    }
    function test_createCampaign() public{
        vm.expectEmit();
        emit CampaignCreated(numCampaigns + 1, msg.sender, 1, block.timestamp + 100 days);
        DCf.createCampaign(1, 100 days);
        
    }
    function test_contribute_CampaignEnded() public{
        vm.expectRevert(DecentralizedCrowdfunding.CampaignEnded.selector);
        hoax(msg.sender, 1 ether);
        DCf.contribute{value: 1 ether}(0);
    }   
    function test_contribute_GoalNotReached() public{
        test_createCampaign();
        vm.expectRevert(DecentralizedCrowdfunding.CampaignEnded.selector);
        hoax(msg.sender, 1 ether);
        DCf.contribute{value: 0 ether}(1);
    }    
}