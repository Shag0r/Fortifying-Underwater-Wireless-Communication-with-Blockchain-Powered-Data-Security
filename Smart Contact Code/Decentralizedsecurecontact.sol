// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SensorData {
    struct SensorReading {
        uint id; // Auto-incremented ID
        string deviceID;
        string location;
        string pressure;
        string pHValue;
        string temperature;
        string velocity;
    }

    SensorReading[] public readings;
    mapping(string => uint[]) private readingsByDeviceID;

    event DataUploaded(
        string indexed deviceID,
        string location,
        string date,
        string ipfsHash,
        string messageChannelSender,
        string status
    );

    function addReading(
        string memory _deviceID,
        string memory _location,
        string memory _pressure,
        string memory _pHValue,
        string memory _temperature,
        string memory _velocity
    ) external {
        uint id = readings.length; // Auto-incremented ID
        SensorReading memory newReading = SensorReading({
            id: id,
            deviceID: _deviceID,
            location: _location,
            pressure: _pressure,
            pHValue: _pHValue,
            temperature: _temperature,
            velocity: _velocity
        });

        readings.push(newReading);
        readingsByDeviceID[_deviceID].push(id);
    }

    function getReading(uint index) external view returns (
        uint id,
        string memory deviceID,
        string memory location,
        string memory pressure,
        string memory pHValue,
        string memory temperature,
        string memory velocity
    ) {
        SensorReading storage reading = readings[index];
        return (
            reading.id,
            reading.deviceID,
            reading.location,
            reading.pressure,
            reading.pHValue,
            reading.temperature,
            reading.velocity
        );
    }

    function getReadingsCount() external view returns (uint) {
        return readings.length;
    }

    function getReadingsByDeviceID(string memory _deviceID) external view returns (
        string[] memory,
        string[] memory,
        string[] memory,
        string[] memory,
        string[] memory
    ) {
        uint[] storage readingIDs = readingsByDeviceID[_deviceID];
        uint count = readingIDs.length;
        string[] memory locations = new string[](count);
        string[] memory pressures = new string[](count);
        string[] memory pHValues = new string[](count);
        string[] memory temperatures = new string[](count);
        string[] memory velocities = new string[](count);

        for (uint i = 0; i < count; i++) {
            SensorReading storage reading = readings[readingIDs[i]];
            locations[i] = reading.location;
            pressures[i] = reading.pressure;
            pHValues[i] = reading.pHValue;
            temperatures[i] = reading.temperature;
            velocities[i] = reading.velocity;
        }

        return (locations, pressures, pHValues, temperatures, velocities);
    }

    function uploadData(
        string memory _deviceID,
        string memory _location,
        string memory _secretKey,
        string memory _date,
        string memory _dataType,
        string memory _messageChannelSender
    ) external {
        require(bytes(_deviceID).length > 0, "Device ID must not be empty");
        require(bytes(_location).length > 0, "Location must not be empty");
        require(bytes(_date).length > 0, "Date must not be empty");

        string memory x;
        uint j;
        uint i;

        if (keccak256(bytes(_dataType)) == keccak256("Customer")) {
            while (j < readingsByDeviceID[_deviceID].length) {
                while (i < readings.length) {
                    if (keccak256(bytes(readings[i].deviceID)) == keccak256(bytes(_deviceID)) &&
                        keccak256(bytes(readings[i].location)) == keccak256(bytes(_location)) &&
                        keccak256(bytes(readings[i].temperature)) == keccak256(bytes(_date))) {
                        x = readings[i].temperature;
                        break;
                    }
                    i++;
                }
                j++;
            }

            if (bytes(x).length > 0) {
                x = encryptionAES(x, _secretKey);
                string memory fh = IPFSAdd(fileToBytes(x));
                emit DataUploaded(_deviceID, _location, _date, fh, _messageChannelSender, "");
            }
        } else if (keccak256(bytes(_dataType)) == keccak256("Data Owner")) {
            if (bytes(x).length > 0) {
                x = encryptionAES(x, _secretKey);
                string memory fh = IPFSAdd(fileToBytes(x));
                emit DataUploaded(_deviceID, _location, _date, fh, _messageChannelSender, "status");
            }
        }
    }

    function encryptionAES(string memory data, string memory secretKey) internal pure returns (string memory) {
    // Placeholder: Just return the original data without any encryption
    return data;
    }

    function fileToBytes(string memory data) internal pure returns (bytes memory) {
        // Placeholder: Convert the string to bytes without any actual conversion
        return bytes(data);
    }

    function IPFSAdd(bytes memory data) internal pure returns (string memory) {
        // Placeholder: Just return a constant IPFS hash without any addition
        return "QmPlaceholderHash";
    }

}