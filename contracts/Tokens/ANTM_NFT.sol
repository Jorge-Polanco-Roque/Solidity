// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Marketplace para comprar NFTs, recompenza con NFTs

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ANTM_NFT is ERC721, Ownable {

    error ANTM_NFT_Non_Existent_TokenU();

    uint256 _tokenID;

    mapping(uint256 tokenID => string) private _tokenURIs;

    constructor() ERC721("ANTM NFT Collection", "ANTM NFT") Ownable(msg.sender) {
        _tokenID = 0;

    }
    
    function mint_ANTM_NFT(address to, string memory _tokenURI) external onlyOwner returns(uint256) {
        _tokenID = _tokenID+1;
        _safeMint(to, _tokenID);
        _setTokenURI(_tokenID, _tokenURI);
        return _tokenID;
    }

    function currentTokenID() external view returns(uint256) {
        return _tokenID;
    }

    function _setTokenURI(uint256 tokenID, string memory _tokenURI) internal virtual {
        _tokenURIs[tokenID] = _tokenURI;
    }

    function tokenURI(uint256 tokenID) public view virtual override returns (string memory) {
        if(tokenID > _tokenID) {
            revert ANTM_NFT_Non_Existent_TokenU();
        }
        
        return _tokenURIs[tokenID];
    }






}