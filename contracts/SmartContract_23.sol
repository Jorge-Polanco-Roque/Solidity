// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// MARKETPLACE

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MarketPlace is Ownable {
    // Variables
    IERC20 tokenERC20;
    IERC721 nft;

    enum SaleStatus {
        open, cancelled, executed
    }

    struct Sale {
        address owner;
        SaleStatus sale;
        uint256 price;
    }

    mapping(uint256 => Sale) sales;
    mapping(uint256 => uint256) security;

    modifier frontRunning(uint256 _nftID) {
        require(
            security[_nftID] == 0 ||
            security[_nftID] < block.number,
            "Security Error"
        );
        security[_nftID] = block.number;
        _;
    }

    constructor(address _tokenERC20, address _nfts) Ownable(msg.sender) {
    tokenERC20 = IERC20(_tokenERC20);
    nft = IERC721(_nfts);
    }

    
    function openSale(uint256 _nftID, uint256 _price) public frontRunning(_nftID) {
        require(msg.sender == nft.ownerOf(_nftID), "You don't have permissions");
        nft.transferFrom(msg.sender, address(this), _nftID);

        sales[_nftID] = Sale(msg.sender, SaleStatus.open, _price);
    }
    
    function cancelSale(uint256 _nftID) public frontRunning(_nftID) {
        require(msg.sender == sales[_nftID].owner, "You don't have permissions");
        require(sales[_nftID].sale == SaleStatus.open, "SOLD");

        sales[_nftID].sale = SaleStatus.cancelled;
        nft.transferFrom(address(this), msg.sender, _nftID);

    }

    function buyTokens(uint256 _nftID) public frontRunning(_nftID) {
        require(sales[_nftID].sale == SaleStatus.open, "It's not open");
        require(tokenERC20.transferFrom(msg.sender, sales[_nftID].owner, sales[_nftID].price));
        require(tokenERC20.transferFrom(msg.sender, address(this), sales[_nftID].price*5/100));

        nft.transferFrom(sales[_nftID].owner, msg.sender, _nftID); 

        sales[_nftID].owner = msg.sender;
        sales[_nftID].sale = SaleStatus.executed;

    }

    function getFees() public onlyOwner {
        require(tokenERC20.transfer(msg.sender, tokenERC20.balanceOf(address(this))), "Error transfering token");

    }


}
 