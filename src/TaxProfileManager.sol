 // SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.19;
 

//depreciation -> business owner. Claim car
//write off based on depreciation 
//business owner, not 
//different assets classes future readme
//
 contract TaxProfileManager{
    uint public taskCount = 0;
    mapping(uint => Task) public tasks;
    
    struct Task{
        uint id;
        string content;
        bool completed;
    }
    
    constructor() public{
        createTask("Like, link, and subscribe!");
    }

    function createTask(string memory _content) public{
        taskCount++;
        tasks[taskCount] = Task(taskCount, _content, false);
        emit TaskCreated(taskCount, _content, false);
    }

    function toggleCompleted(uint _id) public {
        Task memory _task = tasks[_id];
        _task.completed = !_task.completed;
        tasks[_id] = _task;
        emit TaskCompleted(_id, _task.completed);
    }
}