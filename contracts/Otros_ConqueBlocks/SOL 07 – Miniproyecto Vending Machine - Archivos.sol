// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

/*  PROPIEDADES DEL CONTRATO
1) Solo el propietario puede añadir productos nuevos
2) Solo el propietario puede reponer productos
3) Solo el propietario puede acceder al balance de la maquina
4) Cualquiera puede comprar productos
5) Solo el propietario puede traspasar el saldo de la maquina a su cuenta

*/

contract VendingMachine {

    address payable private owner; 

    struct Snack {
        uint32 id;
        string name;
        uint32 quantity;
        uint8 price;
    }

    Snack [] stock; 
    uint32 totalSnacks;

    //EVENTOS

    event newSnackAdded (string _name, uint8 _price);
    event snackRestocked (string _name, uint32 _quantity);
    event snackSold (string name, uint32 _amount) ;

    constructor () {
        owner = payable(msg.sender); 
        totalSnacks = 0;
    }

    modifier onlyOwner () {
        require (msg.sender == owner);
        _;
    }

    function getAllSnacks () external view returns (Snack [] memory _stock)
    {
        return stock;
    }

    function addNewSnack (string memory _name, uint32 _quantity, uint8 _price) external onlyOwner {
        require (bytes(_name).length !=0, "Null name");
        require (_price!=0, "Null price");
        require (_quantity != 0, "Null quantity");

        for (uint8 i = 0; i<stock.length; i++)
        {
            require(!compareStrings(_name, stock[i].name));
        }

        Snack memory newSnack = Snack (totalSnacks, _name, _quantity, _price*10^18);
        stock.push(newSnack);
        totalSnacks++;

        emit newSnackAdded (_name, _price);
    }

    function restock (uint32 _id, uint32 _quantity) external onlyOwner {
        require (_quantity != 0, "Null quantity");
        require (_id < stock.length);

        stock[_id].quantity+=_quantity;

        emit snackRestocked(stock[_id].name, stock[_id].quantity);
    }

    function getMachineBalance () external view onlyOwner returns(uint)
    {
        return address(this).balance;
    }

    function withdraw() external onlyOwner {
        owner.transfer (address(this).balance);
    }


    function buySnack (uint32 _id, uint32 _amount) external payable {
        require (_amount > 0, "Incorrect amount");
        require (stock[_id].quantity >= _amount, "Insufficient quantity");
        require (msg.value >=  _amount*stock[_id].price); 

        stock[_id].quantity -= _amount;
        emit snackSold(stock[_id].name, _amount);
    }


    function compareStrings (string memory a, string memory b) internal pure returns (bool) 
    {
        return (keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)));
    }


}