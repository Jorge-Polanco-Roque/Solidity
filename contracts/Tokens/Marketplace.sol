// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Marketplace para comprar NFTs, recompenza con NFTs

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "./ANTM_ERC20.sol";
import "./ANTM_NFT.sol";

contract Marketplace is Ownable, ERC721Holder {

    error ANTM_NFT_Minting_Error();
    error ANTM_Marketplace_Insufficient_Funds();
    error ANTM_Insufficient_Tokens();

    event NFT_added_To_Marketplace(uint256 tokenID);
    event NFT_Purchased(address to, uint256 tokenID);

    ANTM_ERC20 public erc20Contract;
    ANTM_NFT public nftContract;

    mapping(uint256 tokenID => bool) availableNFTs;

    uint256 public nftPrice;
    uint256 public rewardTokens;

    constructor(uint256 _nftPrice, uint256 _rewardTokens) Ownable(msg.sender) {
        nftPrice = _nftPrice;
        rewardTokens = _rewardTokens;

        erc20Contract = new ANTM_ERC20();
        nftContract = new ANTM_NFT();
    }

    function add_NFT_To_Marketplace() external onlyOwner {
        uint256 tokenID = nftContract.mint_ANTM_NFT(address(this));

        if(tokenID == 0) {
            revert ANTM_NFT_Minting_Error();
        }

        availableNFTs[tokenID] = true;
        emit NFT_added_To_Marketplace(tokenID);


    }   

    function buy_ANTM_NFT(uint256 tokenID) external payable {
        if(msg.value < nftPrice) {
            revert ANTM_Marketplace_Insufficient_Funds();
        }

        if(!availableNFTs[tokenID]) {
            revert ANTM_Insufficient_Tokens();
        }

        availableNFTs[tokenID] = false;
        nftContract.safeTransferFrom(address(this), msg.sender, tokenID);

        erc20Contract.mint_ANTM_ERC20(msg.sender, rewardTokens);

        emit NFT_Purchased(msg.sender, tokenID);

    }


    function set_NFT_Price(uint256 _nftPrice) external onlyOwner {
        nftPrice = _nftPrice;
    }

    function set_Reward_Tokens(uint256 _rewardTokens) external onlyOwner {
        rewardTokens = _rewardTokens;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);

    }



}