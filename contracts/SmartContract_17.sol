// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.0/access/Ownable.sol";

//npm install @openzeppelin/contracts@5.0.0

contract ConquerERC20 is ERC20, Ownable {

    error ConquerERC20MaxSupply();

    event MintConquerERC20(address indexed account, uint256 amount);
    event BurnConquerERC20(address indexed account, uint256 amount);
    
    uint256 private _maxSupply;

    constructor(uint256 _maxSupply_) ERC20("Conquer ERC20", "CT") Ownable(msg.sender) {
        _maxSupply = _maxSupply_;
    }

    function mint(address account, uint256 value) external onlyOwner {
        if (totalSupply()+value > _maxSupply) {
            revert ConquerERC20MaxSupply();
        }
        _mint(account, value);

        emit MintConquerERC20(account, value);
    }

    function burn(uint256 value) external {
        _burn(msg.sender, value);

        emit BurnConquerERC20(msg.sender, value);
    }



}
