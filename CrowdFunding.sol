// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract CrowdFunding{
    mapping (address => uint) public contributors; 
    address public manager;
    uint public minimumContibution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributions;

    struct Request {
        string  description;
        address payable recepient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping (address => bool) voters; //maps addresses of voters with have they voted or not
    }

    mapping (uint => Request) public requests;
    uint public numRequests;

    modifier onlyManager() {
        require(msg.sender == manager, "Not Manager can call this function");
        _;
    }

    constructor(uint _target, uint _deadline){
        target = _target;
        deadline = block.timestamp+_deadline;
        minimumContibution = 100 wei;
        manager = msg.sender;
    }

    function sendEther() public payable {
        require(block.timestamp < deadline, "Deadline has passed");
        require(msg.value >= minimumContibution, "Minimum contribution is not met");

        if (contributors[msg.sender] == 0){
           noOfContributions ++; 
        }
        contributors[msg.sender]+=msg.value;
        raisedAmount+= msg.value;
    }
    function getContractBalance() public view returns (uint){
        return address(this).balance;
    }

    function refund() public {
        require (block.timestamp > deadline && raisedAmount < target, "You are not eligible for refund");
        require (contributors[msg.sender]> 0);
        address payable user= payable (msg.sender); // Made "msg.sender" payable by creating "user" variable
        user.transfer(contributors[msg.sender]); // Now use transfer function and send refund amount "contributors[msg.sender]" to "msg.sender"
        contributors[msg.sender] = 0;
    }

    function createRequests (string memory _description, address payable _recipient, uint _value) public onlyManager{ //Manager creates new request for crowdfunding project
       Request storage newRequest = requests[numRequests];
       numRequests++;  
       newRequest.description= _description;
       newRequest.recepient= _recipient;
       newRequest.value= _value;
       newRequest.completed= false;
       newRequest.noOfVoters= 0;
    }

    function voteRequest(uint _requestNo) public {
        require (contributors[msg.sender] > 0, "You must be a contributor");
        Request storage thisRequest = requests[_requestNo];
        require (thisRequest.voters[msg.sender]== false, "You have already voted");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    } 
}

