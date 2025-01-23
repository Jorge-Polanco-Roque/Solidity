// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";

/* Propiedades del contrato
1) Solo el propietario puede añadir productos nuevos
2) Solo el propietario puede reponern productos
3) Solo el propietario puede acceder al balance de la máquina
4) Cualquiera puede comprar productos
5) Solo el propietario puede traspasar el saldo de la máquina a su cuenta
*/

contract VendingMachine is Ownable {

    //address payable private owner;

    struct Snack {
        uint id;
        string name;
        uint32 quantity;
        uint8 price;
    }

    Snack [] stock;
    mapping(uint32 => Snack) stock1;

    uint32 totalSnacks;

    // Eventos
    event newSnackAdded (string _name, uint8 _price);
    event snackRestocked (string _name, uint32 _quantity);
    event snackSold (string name, uint32 _amount);

    constructor () Ownable(msg.sender) {
        //owner = payable(msg.sender);
        totalSnacks = 0;
    }

/*
    modifier onlyOwner () {
        require(msg.sender == owner);
        _;
    }
*/

    function getAllSnacks() external view returns (Snack [] memory _stock) {
        return stock;
    }

    function addNewSnack (string memory _name, uint32 _quantity, uint8 _price) external onlyOwner {
        require(bytes(_name).length !=0, "Null Name");
        require(_quantity !=0, "Null Quantity");
        require(_price !=0, "Null Price");

        for (uint8 i = 0; i < stock.length; i++) {
            require(!compareStrings(_name, stock[i].name));
            require(!compareStrings(_name, stock1[i].name));

        }   
 
        Snack memory newSnack = Snack(totalSnacks, _name, _quantity, _price*10^8);
        stock.push(newSnack);
        stock1[totalSnacks] = newSnack;
        totalSnacks++;

        emit newSnackAdded(_name, _price);
 
    }

    function restock (uint32 _id, uint32 _quantity) external onlyOwner {
        require(_quantity != 0, "Null Quantity");
        require(_id < stock.length);

        stock[_id].quantity += _quantity;
        stock1[_id].quantity += _quantity;

        emit snackRestocked(stock[_id].name, stock[_id].quantity);

    }

    function getMachineBalance () external view onlyOwner returns (uint) {
        return address(this).balance;
    }

    function withdraw () external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function buySnack(uint32 _id, uint32 _amount) external payable {
        require(_amount > 0, "Incorrect amount");
        require(stock[_id].quantity >= _amount,"Insufficient quantity");
        // el msg.value hace referencia a los Ethers que se tienen en el smart contract
        require(msg.value >= _amount*stock[_id].price);

        stock[_id].quantity -= _amount;
        emit snackSold(stock[_id].name, _amount);

    }

    function compareStrings (string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked(a))==keccak256(abi.encodePacked(b)));
    }





}
