// SPDX-License-Identifier: GPL-3.0

/*
Prueba #1
*/

// Librería de Smart Contracts - Open Zeppelin: https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/token

pragma solidity ^0.8.26;

import "@openzeppelin/contracts@4.5.0/token/ERC20/ERC20.sol";

contract Contrato190125 is ERC20 {
    address public owner;
    constructor (string memory _name, string memory _symbol) ERC20 (_name, _symbol) {
        owner = msg.sender;
    }
}