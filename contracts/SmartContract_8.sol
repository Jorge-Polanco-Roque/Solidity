// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract EtherSender {
    
    // Eventos
    event sendStatus (bool success);
    event callStatus (bool success, bytes data);
    
    // Constructores
    constructor () payable {}

    receive() external payable { }

    // Transfer: Safe but limited
    function usingTransfer (address payable _to) public payable {
        _to.transfer(1 ether); // 1 ether = 1*10^18 wei
    }

    // Send: Requires manual handling of success/failure
    function usingSend (address payable _to) public payable {
        bool success = _to.send(1 ether);
        emit sendStatus(success);
    }


    // Call: Flexible but needs extra caution for security (e.g., reentrancy attacks)
    function usingCall (address payable _to) public payable {
        (bool success, bytes memory data) = _to.call{value: 1 ether}("");
        emit callStatus(success, data);
    }

}

contract EtherReceiver {

    // Evento
    event transactInfo(uint amount, uint gas);

    receive() external payable {
        // address(this): Dirección de este contrato
        emit transactInfo(address(this).balance, gasleft());
    }

}