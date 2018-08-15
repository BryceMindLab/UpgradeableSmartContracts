/* global describe it abi */
pragma solidity ^0.4.24;

/**
 * @title StorageKeyLib
 * @dev Computes Keys to create and lookup values in Enternal Storage 
 */
library StorageKeyLib {
    /* 

    PROPERTY Keys

    */

    // To store PROPERTY values in Eternal Storage, the PROPERTY name is hashed
    //  along with one of these values. 
    bytes32 constant internal PROPERTY_COST = "PROPERTY_COST";
    bytes32 constant internal PROPERTY_POWER_MULTIPLIER = "PROPERTY_POWER_MULTIPLIER";
    bytes32 constant internal PROPERTY_SHIELD_EXPIRATION = "PROPERTY_SHIELD_EXPIRATION";
    bytes32 constant internal PROPERTY_OWNER = "PROPERTY_OWNER";
    bytes32 constant internal PROPERTY_COUNT = "PROPERTY_COUNT";
    bytes32 constant internal PROPERTY_ID = "PROPERTY_ID";
    bytes32 constant internal TOTAL_PROPERTYS = "TOTAL_PROPERTYS";
    
    function getCostKey(string _propertyName) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_propertyName, PROPERTY_COST));
    }

    function getPowerMultiplierKey(string _propertyName) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_propertyName, PROPERTY_POWER_MULTIPLIER));
    }

    function getShieldExpirationKey(string _propertyName) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_propertyName, PROPERTY_SHIELD_EXPIRATION));
    }
    
    function getPropertyOwnerKey(string _propertyName) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_propertyName, PROPERTY_OWNER));
    }

    function getOwnerPropertyCountKey(address _owner) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_owner, PROPERTY_COUNT));
    }

    function getPropertyIDFromNameKey(string _propertyName) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_propertyName, PROPERTY_ID));
    }

    function getPropertyNameFromIDKey(uint _id) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_id, PROPERTY_ID));
    }

    function getTotalPropertiesKey() public pure returns (bytes32) {
        return keccak256(abi.encodePacked("TOTAL_PROPERTIES"));
    }

    /*

    Admin Keys

    */
    bytes32 constant internal CEO_ADDRESS = "CEO_ADDRESS";
    bytes32 constant internal CFO_ADDRESS = "CFO_ADDRESS";
    bytes32 constant internal COO_ADDRESS = "COO_ADDRESS";
    
    bytes32 constant internal PAUSED = "PAUSED";
    bytes32 constant internal PAUSED_CEO = "PAUSED_CEO";

    function getCEOAddressKey() public pure returns (bytes32) {
        return keccak256(abi.encodePacked(CEO_ADDRESS));
    } 
    
    function getCFOAddressKey() public pure returns (bytes32) {
        return keccak256(abi.encodePacked(CFO_ADDRESS));
    } 

    function getCOOAddressKey() public pure returns (bytes32) {
        return keccak256(abi.encodePacked(COO_ADDRESS));
    } 
    
    function getPausedKey() public pure returns (bytes32) {
        return keccak256(abi.encodePacked(PAUSED));
    } 
    
    function getCEOPausedKey() public pure returns (bytes32) {
        return keccak256(abi.encodePacked(PAUSED_CEO));
    } 
}