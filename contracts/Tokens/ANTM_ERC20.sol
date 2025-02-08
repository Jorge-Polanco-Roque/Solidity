// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Marketplace para comprar NFTs, recompenza con NFTs

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ANTM_ERC20 is ERC20, Ownable {

    constructor() ERC20("ANTM ERC20", "ANTM") Ownable(msg.sender) {}
    
    function mint_ANTM_ERC20(address account, uint256 value) external onlyOwner {
        _mint(account, value);
    }










}