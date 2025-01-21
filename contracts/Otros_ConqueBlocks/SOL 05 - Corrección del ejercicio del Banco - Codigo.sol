// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract ConquerStudents {

    struct Students
    {
        string name; // nombre
        string surname; //apellido
        uint8 age; //edad
        bool exist; //control
    }

    uint32 numStudents; //numero de estudiantes apuntados en total
    mapping (address => Students) students; //Lista en la que se registran los estudiantes
    address [] studentAddress; // Address de los estudiantes
    Students [] allStudents; //array que contiene los estudiantes

    function register_student (string memory _name, string memory _surname, uint8 _age) public
    {
        if(!students[msg.sender].exist){

            studentAddress.push(msg.sender);
            students[msg.sender] = Students (_name, _surname, _age, true);
            allStudents.push(students[msg.sender]) ;
            numStudents++;
        }
    }


    function getStudentByAddress (address _dir) public view returns (Students memory) 
    {
        return students[_dir];
    }

    function getStudentById (uint8 _id) public view returns (Students memory) 
    {
        return (students[studentAddress[_id]]);
    }

    function getAllStudents() public view returns (Students[] memory)
    {
        return allStudents;
    }

}