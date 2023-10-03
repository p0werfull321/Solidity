// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract SendEther{

    mapping (address => uint) public Richestaddresses;
    uint max = 0;
    address richest;

    constructor() payable{
        Richestaddresses[msg.sender] = msg.value;
        max = msg.value;
        richest = msg.sender;
        payable(msg.sender).transfer(msg.value);
    }

    function sendEther() external payable{
        require(msg.value > max, "Not the richest");
        max = msg.value;
        richest = msg.sender;
        Richestaddresses[msg.sender] = max; 
    }

    function Withdraw() public payable{
        uint amount = Richestaddresses[msg.sender];
        payable(msg.sender).transfer(amount);
        Richestaddresses[msg.sender] = 0;

    }


}