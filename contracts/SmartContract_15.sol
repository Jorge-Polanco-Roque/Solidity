// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract HotelRoom {

    // Persona que recibe los pagos
    // Necesita el payable?
    address payable public owner;

    // Estados de la habitación
    enum Status {libre, ocupada}

    // Que el estado sea público
    Status public currentStatus;

    // Evento de cuando se ocupa
    event Occupy (address _occupant, uint price);

    // Constructor es una función que se ejecuta una vez al inicio
    constructor () {
        owner = payable(msg.sender);
        currentStatus = Status.libre;
    }

    // Sólo se puede recibir en habitaciones libres
    modifier onlyVacant {
        require(currentStatus == Status.libre, "The room is occupied");
        _;
    }

    // Asegurarse de que hayan dinero suficiente para la transacción
    modifier costs (uint amount) {
        require(msg.value >= amount, "Not enough money");
        _;
    }
    
    // Función para reservar
    function book() public payable onlyVacant costs(1 ether) {
        (bool sent, bytes memory data) = owner.call {value: msg.value}("");
        require(sent);
        
        currentStatus = Status.ocupada;
        emit Occupy(msg.sender, msg.value);


    }




}