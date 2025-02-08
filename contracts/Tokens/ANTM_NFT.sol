// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Marketplace para comprar NFTs, recompenza con NFTs

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ANTM_NFT is ERC721, Ownable {

    uint256 _tokenID;

    constructor() ERC721("ANTM NFT Collection", "ANTM NFT") Ownable(msg.sender) {
        _tokenID = 0;

    }
    
    function mint_ANTM_NFT(address to) external onlyOwner returns(uint256) {
        _tokenID = _tokenID+1;
        _safeMint(to, _tokenID);
        return _tokenID;
    }










}