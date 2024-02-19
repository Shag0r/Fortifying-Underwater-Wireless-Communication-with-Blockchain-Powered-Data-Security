
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RequestedData {
    uint256 public countthree = 0;

    //------------- Mapping
    mapping(uint256 => RequestedDataset) public RequestedDatasetsList; // by default Id;
    mapping(address => mapping(uint256 => RequestedDataset)) public RequestedDatasetByOwner;
    mapping(address => mapping(uint256 => RequestedDataset)) public RequestedDatasetByRequestor;

    struct RequestedDataset {
        uint256 id;
        uint256 datasetId;
        string status;
        address ownerAddress;
        address requestedBy;
        string userPublicKey;
        string ownerSecretKeyEnc;
        string fileHash;
        uint256 date;
    }

    event RequestedDatasetCreated(
        uint256 id,
        uint256 datasetId,
        string status,
        address ownerAddress,
        address requestedBy,
        string userPublicKey,
        string ownerSecretKeyEnc,
        string fileHash,
        uint256 date
    );

    function addRequestedDataset(
        uint256 _datasetId,
        string memory _status,
        address _owneradrs,
        string memory _userPublicKey,
        string memory _fileHash
    ) public {
        countthree++;
        RequestedDatasetsList[countthree] = RequestedDataset(
            countthree,
            _datasetId,
            _status,
            _owneradrs,
            msg.sender,
            _userPublicKey,
            '',
            _fileHash,
            block.timestamp
        );
        RequestedDatasetByOwner[_owneradrs][countthree] = RequestedDataset(
            countthree,
            _datasetId,
            _status,
            _owneradrs,
            msg.sender,
            _userPublicKey,
            '',
            _fileHash,
            block.timestamp
        );
        RequestedDatasetByRequestor[msg.sender][countthree] = RequestedDataset(
            countthree,
            _datasetId,
            _status,
            _owneradrs,
            msg.sender,
            _userPublicKey,
            '',
            _fileHash,
            block.timestamp
        );
        emit RequestedDatasetCreated(
            countthree,
            _datasetId,
            _status,
            _owneradrs,
            msg.sender,
            _userPublicKey,
            '',
            _fileHash,
            block.timestamp
        );
    }

    function updateResponseRequestedData(
        uint256 _id,
        string memory _statusupdate,
        address _reqadrs,
        string memory _ownerSecretKeyEnc
    ) public {
        RequestedDataset storage _reqone = RequestedDatasetsList[_id];
        RequestedDataset storage _reqtwo = RequestedDatasetByOwner[msg.sender][_id];
        RequestedDataset storage _reqthree = RequestedDatasetByRequestor[_reqadrs][_id];
        _reqone.status = _statusupdate;
        _reqtwo.status = _statusupdate;
        _reqthree.status = _statusupdate;
        _reqone.ownerSecretKeyEnc = _ownerSecretKeyEnc;
        _reqtwo.ownerSecretKeyEnc = _ownerSecretKeyEnc;
        _reqthree.ownerSecretKeyEnc = _ownerSecretKeyEnc;
        // Update the dataset
        RequestedDatasetsList[_id] = _reqone;
        RequestedDatasetByOwner[msg.sender][_id] = _reqtwo;
        RequestedDatasetByRequestor[_reqadrs][_id] = _reqthree;
        // Trigger an event
        emit RequestedDatasetCreated(
            _id,
            _reqone.datasetId,
            _statusupdate,
            _reqone.ownerAddress,
            msg.sender,
            _reqone.userPublicKey,
            _ownerSecretKeyEnc,
            _reqone.fileHash,
            block.timestamp
        );
    }
}