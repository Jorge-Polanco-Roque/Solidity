// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

contract TaskList {
    
    enum difficulty {LOW, MEDIUM, HARD}
    
    struct Task {
        string text;
        difficulty level;
        uint8 id;
    }

    mapping (uint8 => Task) tasks;
    uint8 numTask;
    address owner;

    string [] descr;

    constructor () {
        owner = msg.sender;
        numTask = 0;
    }

    function addTask (string memory _text, difficulty _dif) public returns (bool success) {
        tasks[numTask] = Task(_text, _dif, numTask);
        descr.push(tasks[numTask].text);
        numTask++;
        return true;
    }

    function getTaskByID (uint8 _id) public view returns (Task memory _task) {
        return tasks[_id];
    }

    function getAllTasks () public view returns (string [] memory _allTasks) {
        return descr;
    }

}