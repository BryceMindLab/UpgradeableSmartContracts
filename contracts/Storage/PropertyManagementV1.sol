pragma solidity ^0.4.24;

import "./Controllable.sol";
import "../libs/StorageKeyLib.sol";

contract PropertyManagementV1 is Controllable {  
    using StorageKeyLib for string; 


    /// @notice Crestes a default property with a price of 100 Ether.
    /// @param _propertyName -The name of the property.
    /// @dev The value is stored on the blockcahin in wei. 1 Ether = 10**18 wei
    function createDefaultProperty(string _propertyName) public returns (bool _success) {
        _success = createProperty(_propertyName, 10**20); // 100 Ether
    }

    /// @notice Create a property with a given name and wei cost.
    /// @param _propertyName -The name of the property.
    /// @param _weiCost -The cost of the property in wei.
    /// @return bool -Return if the creation was a success 
    function createProperty(string _propertyName, uint _weiCost)
        public
        onlyController
        returns (bool)
    {
        // The way the DB is setup, we cannot have two properties 
        //  with the same name
        if(propertyExists(_propertyName)) return false;
        // Initialize the property data to default values 
        _setPropertyWeiCost(_propertyName, _weiCost); 
        _setPropertyOwnerAddress(_propertyName, msg.sender);
        _incrementOwnerPropertyCount(msg.sender);  
        _addPropertyAndID(_propertyName);
        return true;
    }

    /// @notice Updates total properties count and 
    ///     links the property name and id together .
    /// @param _propertyName -The name of the property.
    /// @dev If you choose to implement ERC721 standard, then you need a way
    ///     to look up properties by ID. The name and id linking in this 
    ///     function allows us to do just that.  
    function _addPropertyAndID(string _propertyName) private {
        // NOTE: We are '1' indexing to tell if they have been init'ed or not
        uint propertyId = getTotalPropertyCount() + 1;
        // Update the total properties count 
        _storage.setUint(
            StorageKeyLib.getTotalPropertiesKey(), 
            propertyId
        );
        // Linking propertyId to the propertyName in Eternal Storage
        _storage.setString(
            StorageKeyLib.getPropertyNameFromIDKey(propertyId), 
            _propertyName
        );
        // Linking propertyName to the propertyId in Eternal Storage
        _storage.setUint(
            _propertyName.getPropertyIDFromNameKey(), 
            propertyId
        );  
    }

    /*

    *** Public GETTERS

    */
    /// @notice Find if a property exists by checking it's id number
    /// @dev We '1-indexed' the property id's so that if and id of 0 was 
    ///     returned from the database we know it has not been created yet
    function propertyExists(string _propertyName) public view returns (bool) {
        return (getPropertyId(_propertyName) > 0);
    }

    function getPropertyNameAtID(uint _tokenId) public view returns (string) {
        return _storage.getString(StorageKeyLib.getPropertyNameFromIDKey(_tokenId));
    }

    function getPropertyId(string _propertyName) public view returns (uint) {
        return _storage.getUint(_propertyName.getPropertyIDFromNameKey());
    }

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
        return _storage.getUint(StorageKeyLib.getTotalPropertiesKey());
    }

    /*
    
    *** Public SETTERS - Only the 'Controller' can update these  *** 

    */
    /// @dev In this section, only the contracts 'controller' 
    ///     can access these functions
    function setPropertyWeiCost(string _propertyName, uint _weiCost) 
        public 
        onlyController 
    {
        _storage.setUint(_propertyName.getCostKey(), _weiCost);
    }

    function setPropertyOwnerAddress(string _propertyName, address _address) 
        public 
        onlyController 
    {
        _storage.setAddress(_propertyName.getPropertyOwnerKey(), _address); 
    }

    /*
    
     *** Internal SETTERS  *** 

    */
    
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
}