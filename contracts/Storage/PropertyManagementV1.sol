pragma solidity ^0.4.24;

import "./Controllable.sol";
import "../libs/StorageKeyLib.sol";

contract PropertyManagementV1 is Controllable {  
    using StorageKeyLib for string; 

    //// @dev Create a default property with a starting price
    function createDefaultProperty(string _propertyName)
        public
    {
        createProperty(
            _propertyName, 
            10**20 // 100 Ether
        );
    }

    // TEST: Updated this method for the new storage system
    function createProperty(string _propertyName, uint _cost)
        public
        onlyController // NOTE: apparently I'm supposed to 'fix the COO logic?'
    {
      // Check to see if there is a value initialized on the shield, if so 
      //  then this Property has already been created.
        uint propertyId = getPropertyId(_propertyName);
        require(
            propertyId == 0, 
            "Cannot create a new Property with this name. There appears to already be a property with that name."
        );
        // Initialize the property data to default values 
        _setPropertyWeiCost(_propertyName, _cost); 
        _setPropertyOwnerAddress(_propertyName, msg.sender);
        _incrementOwnerPropertyCount(msg.sender);
        _addPropertyAndID(_propertyName);

        // FIXME: Need to reimplement this method (Possibly in a nother countract))
        // _increaseFactionPower(id);
    }

    // NOTE: We are one indexing the propertys to more easily see
    //  if they exist or not. 
    function _addPropertyAndID(string _propertyName) private {
        uint propertyId = getTotalPropertyCount() + 1;
        // Update the total propertys count 
        _storage.setUint(
            StorageKeyLib.getTotalPropertysKey(), 
            propertyId
        );
        // Linking propertyId to the propertyName in Eternal Storage
        _storage.setString(
            StorageKeyLib.getPropertyNameFromIDKey(propertyId), 
            _propertyName
        );
        // Linking propertyName to the propertyId  in Eternal Storage
        _storage.setUint(
            _propertyName.getPropertyIDFromNameKey(), 
            propertyId
        );  
    }

    function getPropertyNameAtID(uint _tokenId) public view returns (string) {
        return _storage.getString(StorageKeyLib.getPropertyNameFromIDKey(_tokenId));
    }

    function getPropertyId(string _propertyName) public view returns (uint) {
        return _storage.getUint(_propertyName.getPropertyIDFromNameKey());
    }

    // TEST: Test all of the 'get' logic 
    function getPropertyWeiCost(string _propertyName) public view returns (uint) {
        return _storage.getUint(_propertyName.getCostKey());
    }

    function getPropertyOwnerAddress(string _propertyName) public view returns (address) {
        return _storage.getAddress(_propertyName.getPropertyOwnerKey());
    }

    function getOwnerPropertyCount(address _owner) public view returns (uint) {
        return _storage.getUint(StorageKeyLib.getOwnerPropertyCountKey(_owner));
    }

    function getTotalPropertyCount() public view returns (uint) {
        return _storage.getUint(StorageKeyLib.getTotalPropertysKey());
    }

    // TEST: All these setters are new along with the new storage schema
    // *** Public SETTERS - Only the 'Controller' can update these  *** 
    function setPropertyWeiCost(string _propertyName, uint _weiCost) public onlyController {
        _setPropertyWeiCost(_propertyName, _weiCost);
    }

    function setPropertyOwnerAddress(string _propertyName, address _address) public onlyController {
        _setPropertyOwnerAddress(_propertyName, _address); // Set the owner as the sender
    }

    // *** Internal SETTERS  *** 
    function _setPropertyWeiCost(string _propertyName, uint _weiCost) internal {
        _storage.setUint(_propertyName.getCostKey(), _weiCost);
    }

    function _setPropertyOwnerAddress(string _propertyName, address _address) internal {
        _storage.setAddress(_propertyName.getPropertyOwnerKey(), _address); // Set the owner as the sender
    }

    function _incrementOwnerPropertyCount(address _owner) internal {
        bytes32 key = StorageKeyLib.getOwnerPropertyCountKey(_owner);
        _storage.setUint(
          key, 
          _storage.getUint(key) + 1
        );
    }

    function _decrementOwnerPropertyCount(address _owner) internal {
        bytes32 ownerPropertyCountKey = StorageKeyLib.getOwnerPropertyCountKey(_owner);
        uint propertyCount = _storage.getUint(ownerPropertyCountKey);
        require(propertyCount > 0, "Cannot decrement property count below zero.");
        _storage.setUint(
          ownerPropertyCountKey, 
          propertyCount - 1
        );
    }

    // Need to look through these functions to see which ones need reimplementation 
    // // FIXME: probably deleting this function
    // function getFactionPowerLevelAddress(uint _index) public view returns (address _addresse) {
    //     return factionPowerLevelAddresses[_index];
    // }
}