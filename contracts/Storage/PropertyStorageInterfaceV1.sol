pragma solidity ^0.4.24;

/// @title Property Storage Interface Version 1 
/// @author Bryce Doganer 
/// @notice These interface functions allow us to make function calls from 
///   the `controller` contract. 
/// @dev These functions must be implemented in the PropertyManagement Contract
interface PropertyStorageInterfaceV1 {
    function createDefaultProperty(string _propertyName) external returns (bool);

    function propertyExists(string _propertyName) external view returns (bool);
    function getPropertyNameAtID(uint _tokenId) external view returns (string);
    function getPropertyId(string _propertyName) external view returns (uint);
    function getPropertyWeiCost(string _propertyName) external view returns (uint);
    function getPropertyOwnerAddress(string _propertyName) external view returns (address);
    function getOwnerPropertyCount(address _owner) external view returns (uint);
    function getTotalPropertyCount() external view returns (uint);
    function getPropertyPower(string _propertyName) external view returns (uint);

    function setPropertyWeiCost(string _propertyName, uint _weiCost) external;
    function setPropertyOwnerAddress(string _propertyName, address _address) external;
}