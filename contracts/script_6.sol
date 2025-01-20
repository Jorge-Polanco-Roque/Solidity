// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract ConquerStudents {
    // Estructura de datos para almacenar información de un estudiante
    struct Student {
        string name;
        string surname;
        uint8 age;
        bool exist;
    }

    // Mapping para almacenar estudiantes por ID
    mapping(uint256 => Student) public students;

    // Array para almacenar todos los IDs de los estudiantes registrados
    uint256[] public studentIds;

    // Contador global para asignar IDs únicos
    uint256 public studentCount;

    // Función para registrar un nuevo estudiante
    function registerStudent(
        string memory _name,
        string memory _surname,
        uint8 _age
    ) public {
        // Asignar un nuevo ID único
        uint256 newId = studentCount;

        // Crear el nuevo estudiante
        students[newId] = Student(_name, _surname, _age, true);

        // Agregar el ID al array de IDs
        studentIds.push(newId);

        // Incrementar el contador global de estudiantes
        studentCount++;
    }

    // Función para obtener un estudiante por su ID
    function getStudentById(uint256 id) public view returns (Student memory) {
        require(students[id].exist, "Student does not exist");
        return students[id];
    }

    // Función para obtener todos los estudiantes registrados
    function getAllStudents() public view returns (Student[] memory) {
        // Crear un array en memoria para devolver todos los estudiantes
        Student[] memory all = new Student[](studentIds.length);
        for (uint256 i = 0; i < studentIds.length; i++) {
            all[i] = students[studentIds[i]];
        }
        return all;
    }
}
