
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DatasetsStoring {
    address public owner;
    uint256 public countone = 0;
    uint256 public counttwo = 0;

    //------------- Mapping
    mapping(uint256 => CustomDataset) public DatasetsListC; // by default Id;
    mapping(address => mapping(uint256 => CustomDataset)) public DatasetsByAddressC;
    mapping(uint256 => OwnDataset) public DatasetsListO; // by default Id;
    mapping(address => mapping(uint256 => OwnDataset)) public DatasetsByAddressO;
    mapping(uint256 => mapping(bool => OwnDataset)) public PublicDatasetsO;

    struct CustomDataset {
        uint256 id;
        string dName;
        string dLocation;
        string dSensor;
        string dStartDate;
        string dEndDate;
        string dFilehash;
        address createdBy;
        uint256 date;
    }

    struct OwnDataset {
        uint256 id;
        string dName;
        string dLocation;
        string dSensor;
        string dFilehash;
        bool visiblePublic;
        address createdBy;
        uint256 date;
    }

    event CustomDatasetCreated(
        uint256 id,
        string dName,
        string dLocation,
        string dSensor,
        string dStartDate,
        string dEndDate,
        string dFilehash,
        address createdBy,
        uint256 date
    );

    event OwnDatasetCreated(
        uint256 id,
        string dName,
        string dLocation,
        string dSensor,
        string dFilehash,
        bool visiblePublic,
        address createdBy,
        uint256 date
    );

    function addCustomDataset(
        string memory _name,
        string memory _loc,
        string memory _sensor,
        string memory _sdate,
        string memory _edate,
        string memory _fhash
    ) public {
        countone++;
        DatasetsListC[countone] = CustomDataset(
            countone,
            _name,
            _loc,
            _sensor,
            _sdate,
            _edate,
            _fhash,
            msg.sender,
            block.timestamp
        );
        DatasetsByAddressC[msg.sender][countone] = CustomDataset(
            countone,
            _name,
            _loc,
            _sensor,
            _sdate,
            _edate,
            _fhash,
            msg.sender,
            block.timestamp
        );
        emit CustomDatasetCreated(
            countone,
            _name,
            _loc,
            _sensor,
            _sdate,
            _edate,
            _fhash,
            msg.sender,
            block.timestamp
        );
    }

    function addOwnDataset(
        string memory _name,
        string memory _loc,
        string memory _sensor,
        string memory _fhash,
        bool _vStatus
    ) public {
        counttwo++;
        DatasetsListO[counttwo] = OwnDataset(
            counttwo,
            _name,
            _loc,
            _sensor,
            _fhash,
            _vStatus,
            msg.sender,
            block.timestamp
        );
        DatasetsByAddressO[msg.sender][counttwo] = OwnDataset(
            counttwo,
            _name,
            _loc,
            _sensor,
            _fhash,
            _vStatus,
            msg.sender,
            block.timestamp
        );
        PublicDatasetsO[counttwo][_vStatus] = OwnDataset(
            counttwo,
            _name,
            _loc,
            _sensor,
            _fhash,
            _vStatus,
            msg.sender,
            block.timestamp
        );
        emit OwnDatasetCreated(
            counttwo,
            _name,
            _loc,
            _sensor,
            _fhash,
            _vStatus,
            msg.sender,
            block.timestamp
        );
    }
}
