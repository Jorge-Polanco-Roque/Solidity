// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract ConquerStudents {

    address private owner;

    struct Students {
        string name;
        string surname;
        uint8 age;
        bool exist;
    }

    mapping(address => Students) students;
    uint32 numStudents;

    Students[] allStudents;
    address[] studentAddress;

    constructor () {
        owner = msg.sender;
    }

    function register_Students(string memory _name, string memory _surname, uint8 _age) public {
        require(bytes(_name).length != 0, "Error: No name");
        require(bytes(_surname).length != 0, "Error: No surname");
        require(_age != 0, "Error: No age");

        if (!students[msg.sender].exist) {
            students[msg.sender] = Students(_name, _surname, _age, true);
            allStudents.push(students[msg.sender]);
            
            studentAddress.push(msg.sender);
            numStudents++;
        }
    }

    function getStudentByAddress () public view returns (Students memory) {
        return students[msg.sender];
    }

    function getAllStudents() public view returns (Students[] memory) {
        //require(msg.sender == owner);
        return allStudents;
    }

    function getStudentById(uint8 id) public view returns (Students memory) {
        return students[studentAddress[id]];
    }

    modifier onlyOwner () {
        require(msg.sender == owner);
        _;
    }


}
