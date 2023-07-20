// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 vote;
    }
    
    struct Proposal {
        string name;
        uint256 voteCount;
    }
    
    mapping(address => Voter) public voters;
    Proposal[] public proposals;
    uint256 public proposalCounter;
    
    event ProposalAdded(uint256 indexed proposalId, string name);
    event ProposalVoted(uint256 indexed proposalId, address indexed voter);
    
    function addProposal(string memory _name) public onlyOwner {
        proposals.push(Proposal(_name, 0));
        proposalCounter++;
        emit ProposalAdded(proposalCounter - 1, _name);
    }
    
    function registerVoter(address _voter) public onlyOwner {
        require(!voters[_voter].isRegistered, "Voter is already registered");
        voters[_voter].isRegistered = true;
    }
    
    function vote(uint256 _proposalId, uint256 _vote) public {
        require(voters[msg.sender].isRegistered, "Voter is not registered");
        require(!voters[msg.sender].hasVoted, "Voter has already voted");
        require(_proposalId < proposals.length, "Invalid proposal ID");
        require(_vote < 2, "Invalid vote");
        proposals[_proposalId].voteCount++;
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].vote = _vote;
        emit ProposalVoted(_proposalId, msg.sender);
    }
    
    function getProposalCount() public view returns (uint256) {
        return proposals.length;
    }
    
    function getProposal(uint256 _proposalId) public view returns (string memory, uint256) {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        return (proposals[_proposalId].name, proposals[_proposalId].voteCount);
    }
    
    function getVoter(address _voter) public view returns (bool, bool, uint256) {
        return (voters[_voter].isRegistered, voters[_voter].hasVoted, voters[_voter].vote);
    }
}
