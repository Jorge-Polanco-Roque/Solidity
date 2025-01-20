
//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

contract Memoria 
{
    struct Alumno {
        string nombre;
    }

    mapping (uint8 => Alumno) alumnos ;

    function get_Alumno () external view returns (string memory)
    {
        return alumnos[0].nombre;
    }
/*
    function modificar_alumno () external {
        Alumno storage _alumno = alumnos[0];

        _alumno.nombre = "Luis";
    }
*/

    function modificar_alumno () external {
        Alumno memory _alumno = alumnos[0];

        _alumno.nombre = "Luis";
    }


}