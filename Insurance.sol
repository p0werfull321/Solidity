// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Insurance {
    address[] public policyholders; // holds the address of the policy holders
    mapping (address => uint) public policies;
    mapping (address => uint) public claims;
    address payable owner;
    uint public totalpremium;

    constructor() {
        owner = payable(msg.sender);
    }

    function purchasePolicy (uint premium) public payable{
        require(msg.value == premium, "Invalid premium amount");
        require(premium > 0, "Insufficient premium amount");

        policyholders.push(msg.sender);
        policies[msg.sender] = premium;
        totalpremium +=premium;
    }

    function fileCliam(uint amount) public payable {
        require(policies[msg.sender] > 0, "Must have a valid policy to claim");
        require(amount > 0, "Invalid claim amount");
        require(policies[msg.sender] >= amount, "Amount must be less than policy amount");

        claims[msg.sender] += amount;
    }

    function approveClaim(address policyholder) public {
        require(owner == msg.sender, "Only owner can access");
        require(claims[policyholder] > 0, "Insufficient claims amount");

        payable(policyholder).transfer(policies[policyholder]);
        policies[policyholder] = 0;
    } 

    function getpolicy(address policyholder) public view returns(uint){
        require(owner == msg.sender, "Only owner can access");
         
        return policies[policyholder];
    }

    function getclaim(address policyholder) public view returns(uint){
        require(owner == msg.sender, "Only owner can access");
         
        return policies[policyholder];
    }

    function getpremium(address policyholder) public view returns(uint){
        require(owner == msg.sender, "Only owner can access");
         
        return policies[policyholder];
    }

    function gettotalpremium() public view returns(uint){
        require(owner == msg.sender, "Only owner can access");
         
        return totalpremium;
    }

    function grantaccess(address payable user) public {
         require(owner == msg.sender, "Only owner can access");
         owner = user;
    }


}