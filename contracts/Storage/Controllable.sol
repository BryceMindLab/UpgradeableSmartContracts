pragma solidity ^0.4.24;

import "../libs/ProxyControllerKeyLib.sol";
import "./StorageState.sol";

contract Controllable is StorageState {
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

    function setProxyControllerAddress(address _proxyController) 
        external 
        // FIXME: Anyone can change this right meow. Need to add modifier 
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