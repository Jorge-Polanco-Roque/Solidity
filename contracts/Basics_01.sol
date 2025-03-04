// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract PrimerContrato {
    
    // Variables de longitud fija
    uint X;
    bool presentado; // true o false
    address direccion; // 0xdFD92bA7D9aD36aaFF0d219C820CEa55D9022bb1
    bytes32 datos;
    uint[25] numeros;

    // Variables de longitud variable
    string nombre;
    bytes datoss;
    mapping(string => uint) edades; // edades['Antonio'] = 25
    mapping(address => uint) ethereums; // ethereums[0xdFD92bA7D9aD36aaFF0d219C820CEa55D9022bb1] = 25
    uint[] numeros_v2;

    // Variables definidas por los usuarios
    struct Usuario {
        uint edad;
        string nombre;
        address direccionEthereum;
    }

    enum Colores {
        ROJO,
        VERDE,
        AZUL
    }

    // Variables incorporadas
    /*
    msg.sender;
    msg.value;
    now;
    block.timestamp;
    block.number;
    */
    
    // Constructor de una clase
    uint valor;

    constructor(uint _valor) {
        valor = _valor;
    }
    
    function getValue() external view returns(uint) {
        return valor;
    }

    function setValue(uint _valor) external {
        valor = _valor;
    }

    // Orden de visibilidad: public, external, internal, private



}
