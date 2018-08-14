pragma solidity ^0.4.24;

import "./PropertyAccessControl.sol";
import "../Storage/PropertyStorageInterfaceV1.sol";
import "../Storage/PropertyStorageProxy.sol";

/// @title Crest Access Control 
/// @author Bryce Doganer - DApples.io
contract PropertyConnectorV1 is PropertyAccessControl {
/*
This contract facilitates the interaction between the crest logic (here) and 
the Crest Storage
*/
    PropertyStorageInterfaceV1 _storageInterface;

    function setInterface(address _interfaceAddress) 
        external 
        onlyCEO 
    {
        _storageInterface = PropertyStorageInterfaceV1(_interfaceAddress);
    }

    function getName(uint _tokenId) public view returns (string) {
        // TODO: Check if property exists
        return _storageInterface.getPropertyNameAtID(_tokenId);
    }
    
    function createDefaultProperty(string _name) public {
        _storageInterface.createDefaultProperty(_name);
    }

    function setWeiCost(uint _tokenId, uint _cost) 
        public 
    {
        _storageInterface.setPropertyWeiCost(getName(_tokenId), _cost);
    }

    function getWeiCost(uint _tokenId) public view returns (uint) {
        return _storageInterface.getPropertyWeiCost(getName(_tokenId));
    }
    

}