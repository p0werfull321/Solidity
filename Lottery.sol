// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Lottery {
    address public manager; // single manager therfore simple variable.
    address payable[] public participants; // there can be multiple participants therefore array type.

    constructor(){
        manager= msg.sender;
    }

    receive() external payable{ //amt of ether transferred by participant. this function used only once and it must external payable.
       require(msg.value == 1 ether);
       participants.push(payable(msg.sender));   
    }

    function getBalance() public view returns (uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));

    }

    function selectWinner() public {
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint r= random();
        address payable winner; 
        uint index = r % participants.length;
        winner= participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0); 
    }
}
