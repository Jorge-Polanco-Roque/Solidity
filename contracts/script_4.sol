// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

// Estructuras
contract Estructuras {
    
    struct Alumnos {
        string nombre;
        string apellido;
        uint8 edad;
    }

Alumnos public alumno1 = Alumnos("Jorge", "Lopez", 25);

// Arrays estático
uint8 [4] public numeros = [1, 2, 3, 4];

// Arrays dinámico
Alumnos [] public ConquerAlumnos;

// Mappings
mapping(address => uint256) direccion_numero;
mapping(address => Alumnos) direccion_struc;
mapping(string => uint256[]) string_numero;
mapping(address => mapping(address => string)) mapping2;

}



