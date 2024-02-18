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


}