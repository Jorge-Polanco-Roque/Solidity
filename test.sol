// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AccessToken is ERC721, Ownable {
    uint256 private _tokenIdCounter;

    constructor() ERC721("AccessToken", "ATK") Ownable(msg.sender) {}

    function mint(address to) external onlyOwner {
        _safeMint(to, _tokenIdCounter);
        _tokenIdCounter++;
    }
}

abstract contract DAO is Ownable {
    AccessToken public accessToken;
    address[] public councilMembers;
    uint256 public constant COUNCIL_SIZE = 3;

    constructor(address _accessToken) Ownable(msg.sender) {
        accessToken = AccessToken(_accessToken);
    }

    modifier onlyCouncil() {
        bool isCouncil = false;
        for (uint256 i = 0; i < councilMembers.length; i++) {
            if (councilMembers[i] == msg.sender) {
                isCouncil = true;
                break;
            }
        }
        require(isCouncil, "Not a council member");
        _;
    }

    function setCouncilMembers(address[] calldata _members) external onlyOwner {
        require(_members.length == COUNCIL_SIZE, "Invalid council size");
        councilMembers = _members;
    }

    function manageTreasury() external onlyCouncil {
        // Logic for managing the treasury
    }

    function vote() external view returns (bool) {
        require(accessToken.balanceOf(msg.sender) > 0, "Must hold token to vote");
        // Voting logic
        return true;
    }
}