// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

/* 
Task:
1. Find and fix vulnerabilities
2. Optionally - Prove with tests that contract is safe

---------Changes-----------
    - rearranged transfers to follow pul over push method
    - rearranged lines for checks-effects-interactions pattern

*/

contract DecentralizedCrowdfunding {
    struct Campaign {
        address payable owner;
        uint256 goal;
        uint256 deadline;
        uint256 fundsRaised;
        bool claimed;
        address[] contributors;
        mapping(address => uint256) contributions;
    }

    uint256 public numCampaigns = 0;
    mapping(uint256 => Campaign) public campaigns;

    event CampaignCreated(uint256 indexed campaignId, address owner, uint256 goal, uint256 deadline);
    event ContributionMade(uint256 indexed campaignId, address contributor, uint256 amount);
    event FundsClaimed(uint256 indexed campaignId, uint256 amount);

    error CampaignExists();
    error InvalidGoal();
    error CampaignEnded();
    error InvalidContribution();
    error NoContributionMade();
    error CampaignNotEnded();
    error GoalReached();
    error GoalNotReached();
    error FundsAlreadyClaimed();

    function createCampaign( uint256 _goal, uint256 _duration) external {
        if (_goal == 0) revert InvalidGoal();

        uint256 deadline = block.timestamp + _duration;
        numCampaigns++;
        Campaign storage newCampaign = campaigns[numCampaigns];
        newCampaign.owner = payable(msg.sender);
        newCampaign.goal = _goal;
        newCampaign.deadline = deadline;
        newCampaign.fundsRaised = 0;
        newCampaign.claimed = false;
        emit CampaignCreated(numCampaigns, msg.sender, _goal, deadline);
    }

    function contribute(uint256 _campaignId) external payable {
        Campaign storage campaign = campaigns[_campaignId];
        if (block.timestamp >= campaign.deadline) revert CampaignEnded();
        if (msg.value == 0) revert InvalidContribution();
        
        campaign.fundsRaised += msg.value;
        campaign.contributions[msg.sender] += msg.value;
        campaign.contributors.push(msg.sender);
        emit ContributionMade(_campaignId, msg.sender, msg.value);
    }

    function claimFunds(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];
        if (block.timestamp < campaign.deadline) revert CampaignNotEnded();
        if (campaign.fundsRaised < campaign.goal) revert GoalNotReached();
        if (campaign.claimed) revert FundsAlreadyClaimed();
        
        //rearranged the following three lines to follow checks-effects-interactions pattern
        campaign.claimed = true;
        campaign.owner.transfer(campaign.fundsRaised);
        emit FundsClaimed(_campaignId, campaign.fundsRaised);
    }

    function refundCampaign(uint256 _campaignId) external {
        // changed memory to storage as it contains a (nested) mapping
        Campaign storage campaign = campaigns[_campaignId];
        if (block.timestamp < campaign.deadline) revert CampaignNotEnded();
        if (campaign.fundsRaised >= campaign.goal) revert GoalReached();
        
        //pull over push method
        address contributorAddress = msg.sender;
        uint256 contributedAmount = campaign.contributions[contributorAddress];
        if(contributedAmount > 0) {
                campaign.contributions[contributorAddress] = 0;
                payable(contributorAddress).transfer(contributedAmount);
        }
       
       
       /* for(uint256 i = 0; i < campaign.contributors.length; i++) {
            address contributorAddress = campaign.contributors[i];
            uint256 contributedAmount = campaign.contributions[contributorAddress];
            if(contributedAmount > 0) {
                payable(contributorAddress).transfer(contributedAmount);
                campaign.contributions[contributorAddress] = 0;
            }
        }*/
    }
}