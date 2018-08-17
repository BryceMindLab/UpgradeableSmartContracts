pragma solidity ^0.4.24;

import "../Storage/PropertyStorageInterfaceV1.sol";
import "./PropertyAccessControl.sol";

/// @title Property Access Control 
/// @author Bryce Doganer
/// @notice This contract is setup as an interface between the front-end and 
///   the storage contract arragement. 
/// @dev This contract sends calls to the `PropertyStorageProxy` contract through 
///   the `PropertyStorageInterface` contract by setting the address of the interface
///   to the address of the proxy. Inside, the proxy is linked to the `PropertyManagement`
///   contract which implements the functions in the interface contract. 
contract PropertyConnectorV1 is PropertyAccessControl {
    /// @notice This is the contracts pointer to the Interface
    PropertyStorageInterfaceV1 _storageInterface;

    /// @notice Sets the interface address as the address of the proxy contract
    /// @param _proxyAddress -Address of the proxy contract, which implements the 
    ///   interface functions 
    function setInterface(address _proxyAddress) 
        external 
        onlyCEO 
    {
        _storageInterface = PropertyStorageInterfaceV1(_proxyAddress);
    }

    /// @notice Get the name of a property with the given `tokenId`
    /// @param _tokenId -The ID of a property 
    /// @return string -The name of the property
    function getName(uint _tokenId) public view returns (string) {
        return _storageInterface.getPropertyNameAtID(_tokenId);
    }
    
    /// @notice Create a property with the given name and default values
    /// @param _name -The desired name of a new property 
    function createDefaultProperty(string _name) public { 
        require(
            _storageInterface.propertyExists(_name) == false,
            "Cannot create property with this name as it already exists"
        );
        _storageInterface.createDefaultProperty(_name);
    }

    /// @notice Sets the weiCost of a property with the given id 
    /// @param _tokenId -The ID of a given property 
    /// @param _weiCost -The new cost in wei 
    function setWeiCost(uint _tokenId, uint _weiCost)  public {
        _storageInterface.setPropertyWeiCost(getName(_tokenId), _weiCost);
    }
    
    /// @notice Sets the weiCost of a property with the given id 
    /// @param _tokenId -The ID of a given property 
    /// @return uint -The cost of the property in wei 
    function getWeiCost(uint _tokenId) public view returns (uint) {
        return _storageInterface.getPropertyWeiCost(getName(_tokenId));
    }
    

}