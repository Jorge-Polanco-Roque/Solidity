// SPDX-License-Identifier: GPL-3.0

// Ejemplo de cómo usar tipos de datos enum

pragma solidity ^0.8.0;

contract ExampleEnum {
    // Declaración de un enum
    enum Status { Pending, Active, Closed }
    
    // Variable para almacenar el estado actual
    Status public currentStatus;

    // Constructor para inicializar el estado
    constructor() {
        currentStatus = Status.Pending; // Estado inicial
    }

    // Cambiar el estado a Active
    function activate() public {
        currentStatus = Status.Active;
    }

    // Cambiar el estado a Closed
    function close() public {
        currentStatus = Status.Closed;
    }

    // Obtener el estado como un entero
    function getStatus() public view returns (uint) {
        return uint(currentStatus); // Devuelve el índice (0, 1, o 2)
    }
}
