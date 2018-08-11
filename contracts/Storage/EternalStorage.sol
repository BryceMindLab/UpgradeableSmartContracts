pragma solidity ^0.4.24;

contract EternalStorage {

    mapping(address => mapping(bytes32 => uint256)) _uintStorage;
    mapping(address => mapping(bytes32 => address)) _addressStorage;
    mapping(address => mapping(bytes32 => bool)) _boolStorage;
    mapping(address => mapping(bytes32 => string)) _stringStorage;

    /*********** Getter Methods ***********/

    function getAddress(bytes32 key) public view returns (address) {
        return _addressStorage[msg.sender][key];
    }

    function getUint(bytes32 key) public view returns (uint) {
        return _uintStorage[msg.sender][key];
    }

    function getBool(bytes32 key) public view returns (bool) {
        return _boolStorage[msg.sender][key];
    }

    function getString(bytes32 key) public view returns (string) {
        return _stringStorage[msg.sender][key];
    }

    /*********** Get At Address Methods ***********/

    function getAddressFromAddress(bytes32 key, address addr) public view returns (address) {
        return _addressStorage[addr][key];
    }

    function getUintFromAddress(bytes32 key, address addr) public view returns (uint) {
        return _uintStorage[addr][key];
    }

    function getBoolFromAddress(bytes32 key, address addr) public view returns (bool) {
        return _boolStorage[addr][key];
    }

    function getStringFromAddress(bytes32 key, address addr) public view returns (string) {
        return _stringStorage[addr][key];
    }

    /*********** Setter Methods ***********/

    function setAddress(bytes32 key, address value) public {
        _addressStorage[msg.sender][key] = value;
    }

    function setUint(bytes32 key, uint value) public {
        _uintStorage[msg.sender][key] = value;
    }

    function setBool(bytes32 key, bool value) public {
        _boolStorage[msg.sender][key] = value;
    }

    function setString(bytes32 key, string value) public {
        _stringStorage[msg.sender][key] = value;
    }

    /*********** Delete Methods ***********/

    function deleteAddress(bytes32 key) public {
        delete _addressStorage[msg.sender][key];
    }

    function deleteUint(bytes32 key) public {
        delete _uintStorage[msg.sender][key];
    }

    function deleteBool(bytes32 key) public {
        delete _boolStorage[msg.sender][key];
    }
    
    function deleteString(bytes32 key) public {
        delete _stringStorage[msg.sender][key];
    }
}
