// SPDX-License-Identifier: MIT
/*
Warmup:
Fill the body of vote function:
- first check if msg.sender has already voted, if yes then revert with proper error
- check if candidate exists (so if either _candidateId == 0 or _candidateId > candidatesCount is true then revert with proper error)
- if every condition is met then:
  - mark that msg.sender has already voted
  - increment candidate vote count
  - emit proper event
*/

pragma solidity 0.8.24;

contract DecentralizedVotingSystem {

    error AddressAlreadyVoted(address voter);
    error CandidateNotExists(uint candidateId);
    error TieDetected();
    error NoVotes();

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    uint public candidatesCount;
    Candidate public winner;

    event CandidateAdded(uint candidateId, string name);
    event VoteCasted(uint candidateId, address voter);
    event WinnerChosen(uint candidateId);

    function addCandidate(string memory _name) external {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        emit CandidateAdded(candidatesCount, _name);
    }

    function vote(uint _candidateId) external {
       if (_candidateId == 0 || _candidateId > candidatesCount) {
            revert CandidateNotExists(_candidateId);
       }
       if(hasVoted[msg.sender]==true){
            revert AddressAlreadyVoted(msg.sender);
       }
       candidates[_candidateId].voteCount = candidates[_candidateId].voteCount + 1;
       hasVoted[msg.sender] = true;
       emit VoteCasted(_candidateId,msg.sender);
    }

    function chooseTheWinner() external {
        // declare some useful variables
        uint highestVoteCount = 0;
        uint winnerCount = 0;
        uint[] memory tempWinners = new uint[](candidatesCount);

        // search for the highest vote count and how many candidates has the highest vote count
        // also assign tempWinners every time we find higher vote count than before
        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > highestVoteCount) {
                highestVoteCount = candidates[i].voteCount;
                winnerCount = 1;
                tempWinners[0] = i;
            } 
            else if (candidates[i].voteCount == highestVoteCount) {
                tempWinners[winnerCount] = i;
                winnerCount++;
            }
        } 

        // check if the highest vote count is 0, if yes it means that nobody voted yet
        if (highestVoteCount == 0) {
            revert NoVotes();
        }

        // check if we have more than one candidate with the highest vote count, if yes then revert
        if (winnerCount > 1) {
            revert TieDetected();
        } 
        
        // else we assign the winner and emit event
        winner = candidates[tempWinners[0]];
        emit WinnerChosen(tempWinners[0]);
    }
}