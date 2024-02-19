
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataLogic {

    address public owner;
    uint256 public count = 0;

    //------------- Mapping
    mapping(uint256 => RegisterUser) public UserList; // by default Id;
    mapping(address => RegisterUser) public UserAddress; // by address;

    struct RegisterUser {
        uint256 id;
        string userName;
        string requestingType;
        string emailaddress;
        string userRole;
        bool userStatus;
        address userAddress;
        address createdBy;
        uint256 date;
    }

    event RegisterUserCreated(
        uint256 id,
        string userName,
        string requestingType,
        string emailaddress,
        string userRole,
        bool userStatus,
        address userAddress,
        address createdBy,
        uint256 date
    );
    event UserStatusUpdate(
        string userRole,
        bool userStatus,
        address createdBy
    );

    modifier alreadyRegistered() {
        require(msg.sender != owner, "You have already applied for this account registration, wait for approval.");
        _;
    }

    function addNewUser(
        string memory _name,
        string memory _type,
        string memory _email,
        string memory _role,
        bool _status
    ) public alreadyRegistered {
        count++;
        owner = msg.sender;
        UserList[count] = RegisterUser(
            count,
            _name,
            _type,
            _email,
            _role,
            _status,
            msg.sender,
            msg.sender,
            block.timestamp
        );
        UserAddress[msg.sender] = RegisterUser(
            count,
            _name,
            _type,
            _email,
            _role,
            _status,
            msg.sender,
            msg.sender,
            block.timestamp
        );

        emit RegisterUserCreated(
            count,
            _name,
            _type,
            _email,
            _role,
            _status,
            msg.sender,
            msg.sender,
            block.timestamp
        );
    }

    function assignRoleToUser(
        uint256 _id,
        string memory _userRole,
        bool _userStatus,
        address _userAddress
    ) public {
        RegisterUser storage _user = UserList[_id];
        RegisterUser storage _useradrs = UserAddress[_userAddress];
        _user.userRole = _userRole;
        _user.userStatus = _userStatus;
        _user.createdBy = msg.sender;
        _useradrs.userRole = _userRole;
        _useradrs.userStatus = _userStatus;
        _useradrs.createdBy = msg.sender;
        // Update the role
        UserList[_id] = _user;
        UserAddress[_userAddress] = _useradrs;
        // Trigger an event
        emit RegisterUserCreated(
            count,
            _user.userName,
            _user.requestingType,
            _user.emailaddress,
            _user.userRole,
            _user.userStatus,
            _user.userAddress,
            _user.createdBy,
            block.timestamp
        );
    }
}
