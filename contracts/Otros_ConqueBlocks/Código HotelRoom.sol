// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;
/*
1. Debe tener un propietario al que se van a realizar los pagos cuando se ocupe la habitación.
2. Debe tener una estructura que defina los dos posibles estados de la habitación de hotel:ocupada o libre.
3. Al desplegarse el contrato, el estado de la habitación será libre.
4. Debe tener una función que permita ocupar y pagar la habitación. El precio será 1 ether
y se transferirá directamente al propietario del contrato. Si la transacción se realiza
correctamente, emitiremos un evento con la información que veamos conveniente.
5. Para poder pagar y ocupar una habitación, esta tiene que estar libre.
*/

contract HotelRoom {

    address payable owner; 
    
    enum Status {
        vacant,
        occupied
    }

    Status public currentStatus;

    event Occupy (address _occupant, uint value);

    constructor () {
        owner = payable(msg.sender);
        currentStatus = Status.vacant;
    }

    modifier onlyVacant {
        require (currentStatus == Status.vacant, "The room is occupied");
        _;
    }

    modifier costs (uint amount)
    {
        require(msg.value >= amount, "Not enough money");
        _;
    }
    

    function book() public payable onlyVacant costs(1 ether){
        
        (bool sent, bytes memory data) = owner.call {value: msg.value}("");
        require(sent);

        currentStatus = Status.occupied;
        emit Occupy(msg.sender, msg.value);
    }


}