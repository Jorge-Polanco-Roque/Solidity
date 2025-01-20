// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

contract Variables {
    
    // Variables enteras
    int32 numero = 1;
    uint32 numero2 = 0;

    // Strings
    string cadena = 'Hola';
    string cadena2 = "Adios";

    // Booleano
    bool falso = false;
    bool verdadero = true;

    // Direcciones
    //address dir = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address public dir2 = 0xD7ACd2a9FD159E69Bb102A1ca21C9a3e3A5F771B;
    address public owener = msg.sender;

    // Bytes
    bytes32 public hashing =  keccak256(abi.encodePacked("ANTM"));

    // Enum
    enum disponible {LIBRE, OCUPADA}
    disponible public estado1 = disponible.LIBRE;
    disponible public estado2 = disponible.OCUPADA;


}
