pragma solidity ^0.4.24;

import "../libs/ProxyControllerKeyLib.sol";
import "./StorageState.sol";
import "../Ownable.sol";

/// @title Controllable Contract
/// @author Bryce Doganer
/// @notice A contract that holds an address that can make calls to functions
///   with the 'onlyController' modifier. This allows sensitive data to be
///   accessed by a specific `controller` contract/user address.
/// @dev This specific contract is setup to store the controller address in 
contract Controllable is StorageState, Ownable {
    modifier onlyController() {
        require(
            msg.sender == getProxyControllerAddress(),
            "Only this contract's 'controller' can perform this action."
        );
        _;
    }

    function getProxyControllerAddress() public view returns (address) {
        return _storage.getAddress(ProxyControllerKeyLib.getProxyControllerKey());
    }

    /// @notice This function allows the controller address to be changed. 
    ///  When this contract is created the 'owner' is set in the 'Ownable'
    ///  contract.
    /// @dev I'm not 100% certain if this should use the `onlyOwner` or 
    ///   `onlyController` function modifier 
    function setProxyControllerAddress(address _proxyController) 
        external 
        onlyOwner
    {
        require(
            _proxyController != address(0),
            "Cannot set the Proxy Controller to address(0)"
        );
        _storage.setAddress(
            ProxyControllerKeyLib.getProxyControllerKey(), 
            _proxyController
        );
    }
}