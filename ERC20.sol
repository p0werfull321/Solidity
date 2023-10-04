// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Block is IERC20{

    string public name = "Block"; //name of the token
    string public symbol = "BLK"; // symbol of the token 
    uint public decimal = 0;
    address public founder; //Initially this will have the total supply
    mapping (address => uint) public balances; //information of balances of each address

    mapping (address => mapping(address => uint)) allowed;

    uint public totalSupply;

    constructor() {
        totalSupply = 1000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    //balance of token of an account
    function balanceOf(address account) external view returns (uint256){
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) external returns (bool){
        require(amount > 0, "Invalid amount transfer");
        require(balances[msg.sender] > 0, "Balance must be greater than 0");
        require(balances[msg.sender] > amount, "Balance must be greater than 0");

        balances[msg.sender]-= amount;
        balances[recipient]+= amount;
//In this case tokens are transferred, thus functions are not payable, and transfer function not used.

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256){ //How many tokens are allowed by owner for spender
       //Acts like a passbook(74add03b442faf1bfadf0f336e11582f)
       return allowed[owner][spender];
    }

//This is like signing a cheque
    function approve(address spender, uint256 amount) external returns (bool){
        require(amount > 0, "Must be greater than zero");
        require(balances[msg.sender] >= amount, "Balance must be greater than 0");
        require (spender != address(0));

        allowed[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

//In order to cash out the cheque we use the function transferFrom()
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){
        require(amount > 0, "Must be greater than zero");
        require(balances[sender] > amount, "Balance must be greater than 0");
        require(allowed[sender][recipient] >= amount, "Recipient doesn't have enough authority to spend sender token");

        balances[sender]-=amount;
        balances[recipient]+=amount;

        emit Transfer(sender, recipient, amount);

        return true;
    }

}