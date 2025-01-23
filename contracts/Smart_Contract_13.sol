// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract Purpose {
    
    address private owner;
    string contractPurpose = "Texto base";

    constructor() {
        owner = msg.sender;
    }

    event changedPurpose(string _contractPurpose);

    function getPurpose() external view returns (string memory) {
        return contractPurpose;
    }

    function changePurpose(string memory _newPurpose) public {
        contractPurpose = _newPurpose;
        emit changedPurpose(_newPurpose);
    }
}
