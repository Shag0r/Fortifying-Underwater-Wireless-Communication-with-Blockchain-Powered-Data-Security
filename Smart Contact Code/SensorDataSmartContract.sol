
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SensorDataSmartContract {
    address public owner;
    
    // Mapping to store data on-chain
    mapping(string => mapping(string => string)) public psData;

    // Event emitted when data is added
    event DataAdded(string deviceID, string key, string value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addPSData(string memory deviceID, string memory key, string memory value) external onlyOwner {
        // Store data on-chain
        psData[deviceID][key] = value;
        emit DataAdded(deviceID, key, value);
    }

    function getPSData(string memory deviceID, string memory key) external view returns (string memory) {
        // Retrieve data from the mapping
        return psData[deviceID][key];
    }
}
