// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MembershipNFT is ERC721Enumerable, Ownable {
    
    error ANTMMembershipInsufficientBalance();
    error ANTMMembershipNonExistenseToken();
    error ANTMMembershipNotTheOwner();
    error ANTMMembershipNotTAllow();
    error ANTMMembershipExpired();

    event NewMembershipMinted(address indexed to, uint256 tokenID, MembershipLevel level);
    event MembershipRenewed(address indexed to, uint256 tokenID, MembershipLevel level, uint256 expiration);
    event MembershipBurned(address indexed owner, uint256 tokenID);

    uint256 private _currentTokenId;
    enum MembershipLevel {Bronze, Silver, Gold}

    mapping (uint256 tokenID => MembershipLevel) public membershipLevels;
    mapping (uint256 tokenID => uint256 expiration) public membershipExpiration;

    uint256 bronzePrice = 0.01 ether;
    uint256 silverPrice = 0.1 ether;
    uint256 goldPrice = 0.5 ether;

    constructor() ERC721("ANTM Membership", "ANTM") Ownable(msg.sender) {
        _currentTokenId = 0;

    }
    
    function mintANTMMembership(MembershipLevel level) external payable {
        uint256 price = getPriceForLevel(level);

        if(msg.value < price) {
            revert ANTMMembershipInsufficientBalance();
        }

        _currentTokenId = _currentTokenId + 1;

        _safeMint(msg.sender, _currentTokenId);
        membershipLevels[_currentTokenId] = level;
        membershipExpiration[_currentTokenId] = block.timestamp + 365 days;

        emit NewMembershipMinted(msg.sender, _currentTokenId, level);

    }

    function renewMembership(uint256 tokenID) external payable {
        if(!_exists(tokenID)) {
            revert ANTMMembershipNonExistenseToken();
        }

        if(ownerOf(tokenID)!=msg.sender) {
            revert ANTMMembershipNotTheOwner();
        }

        MembershipLevel level = membershipLevels[tokenID];
        uint256 price = getPriceForLevel(level);

        if(msg.value < price) {
            revert ANTMMembershipInsufficientBalance();
        }

        uint256 newExpirationData = membershipExpiration[tokenID] + 365 days;
        membershipExpiration[tokenID] = newExpirationData;

        emit MembershipRenewed(msg.sender, tokenID, level, newExpirationData);


    }


    function getPriceForLevel(MembershipLevel _level) public view returns(uint256) {
        if(_level == MembershipLevel.Gold) {
            return goldPrice;
        } else if (_level == MembershipLevel.Silver) {
            return silverPrice;
        } else {
            return bronzePrice;
        }
    }

    function _exists(uint256 _tokenID) internal view returns (bool) {
        return ownerOf(_tokenID) != address(0);
    }

    function checkMembershipLevel(address _user) public view returns(MembershipLevel) {
        uint256 balance = balanceOf(_user);

        if(balance==0) {
            revert ANTMMembershipInsufficientBalance();
        }

        MembershipLevel level = MembershipLevel.Bronze;

        for(uint256 i = 0; i<balance-1; i++) {
            uint256 tokenID = tokenOfOwnerByIndex(_user, i);
            MembershipLevel currentLevel = membershipLevels[tokenID];
        
            if(currentLevel>level) {
                level = currentLevel;
            }

        }

        return level;

    }

    function burnMembership(uint256 tokenID) external {
        if(!_exists(tokenID)) {
            revert ANTMMembershipNonExistenseToken();
        }

        if(ownerOf(tokenID)!=msg.sender) {
            revert ANTMMembershipNotTheOwner();
        }

        _burn(tokenID);
        emit MembershipBurned(msg.sender, tokenID);

    }

    function isMembershipActive(address _user) public view returns(bool) {
        uint256 balance = balanceOf(_user);

        if(balance==0) {
            revert ANTMMembershipInsufficientBalance();
        }

        uint256 tokenID = tokenOfOwnerByIndex(_user, balance-1);

        return membershipExpiration[tokenID]>block.timestamp;
    }

    function exclusiveGold() external view {
        if(!isMembershipActive(msg.sender)){
            revert ANTMMembershipExpired();
        }
        
        if(checkMembershipLevel(msg.sender)!= MembershipLevel.Gold) {
            revert ANTMMembershipNotTAllow();
        }
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }



}