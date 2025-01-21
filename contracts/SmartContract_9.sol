// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

/*
    msg.data: jala información de la transacción

    msg.data ¿Vacío?
    A. No => Se llama a la función fallback()
    B. Sí =A> ¿Existe una función receive()?
        i)  Sí => Se llama a la función receive()
        ii) No => Se llama a la función fallback()

*/

contract Receive_Fallback {
    // Evento
    event info(string _function, address _sender, uint _amount, bytes _data);

    fallback() external payable { 
        emit info ("Fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable { 
        emit info ("Receive", msg.sender, msg.value, "");
    }


}