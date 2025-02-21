// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ConquerERC1155 is ERC1155, Ownable {

    error ANTM_ERC1155_InvalidAmount();
    error ANTM_ERC1155_InvalidURI();
    error ANTM_ERC1155_AlreadyExists();
    error ANTM_ERC1155_InvalidArrayLength();

    mapping(uint256 tokenId => string) private _tokenURIs;

    constructor() ERC1155("") Ownable(msg.sender) {}

    function mint_ANTM_Multitoken(
        address to, 
        uint256 tokenId, 
        uint256 amount, 
        string memory _tokenURI
    ) public onlyOwner returns (uint256) {
        if(amount <= 0) {
            revert ANTM_ERC1155_InvalidAmount();
        }
        if(bytes(_tokenURI).length == 0) {
            revert ANTM_ERC1155_InvalidURI();
        }
        
        if(bytes(_tokenURIs[tokenId]).length != 0) {
            revert ANTM_ERC1155_AlreadyExists();
        }

        _setTokenURI(tokenId, _tokenURI);
        _mint(to, tokenId, amount, "");
        return tokenId;
    }

    function mint_ANTM_MultiToke_Batch(address to, uint256[] memory ids, uint256[] memory values, string[] memory _tokenURI) external onlyOwner returns(uint256[] memory) {
        for (uint i=0; i < values.length; i++) {
            if(values[i] <= 0) {
                revert ANTM_ERC1155_InvalidAmount();
            }
        }
        
        if(ids.length != _tokenURI.length) {
            revert ANTM_ERC1155_InvalidArrayLength();
        }

        for (uint j = 0; j <= ids.length; j++) {
            uint256 id = ids[j];

            if(bytes(_tokenURIs[id]).length == 0) {
                revert ANTM_ERC1155_AlreadyExists();
            }

            if(bytes(_tokenURI[j]).length == 0) {
                revert ANTM_ERC1155_InvalidURI();
            }

        }

        _mintBatch(to, ids, values, "");

        return ids;

    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        
        string memory tokenUri =_tokenURIs[tokenId];

        if(bytes(tokenUri).length == 0) {
            revert ANTM_ERC1155_InvalidURI();
        }
        
        return _tokenURIs[tokenId];
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        _tokenURIs[tokenId] = _tokenURI;
    }
}
