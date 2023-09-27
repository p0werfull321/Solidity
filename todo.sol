// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract todo{

    struct todoList{
        string text;
        bool completed;
    }

    todoList[] public todoarr;

    function create(string calldata _text) external{
        todoarr.push(todoList({text: _text, completed: false}));
    }

    function updateText(string calldata _text, uint _index) external{
       //todoarr[_index].text = _text;   

        //todoList storage todo = todoarr[_index];
        todoList[] storage storageArray = todoarr;
        storageArray[_index].text = _text;
    }

    function get(uint _index) external view returns(string memory) {
        todoList[] storage storageArray = todoarr;
        return storageArray[_index].text;
    }

}