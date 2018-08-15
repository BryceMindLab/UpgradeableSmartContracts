pragma solidity ^0.4.18;

import "../Ownable.sol";
import "./StorageState.sol";
import "../libs/ProxyControllerKeyLib.sol";

/*
 * This article explains how this proxy works:
 * https://medium.com/quillhash/how-to-write-upgradable-smart-contracts-in-solidity-d8f1b95a0e9a
 */

/// @title Property Storage Proxy
/// @author Adapted from Quillhash/upgradeableToken 
/// @notice This proxy 'leeches' onto another contract and handles calls to 
///   that contract as if this was the same contract. 
/// @dev Even though the calls are being made to the 'leeched' contract,
///   the address sent is the address of the proxy. Funds are also stored in this 
///   proxy contract.
contract PropertyStorageProxy is StorageState, Ownable {
   
    constructor(EternalStorage storage_, address _proxyController) public {
    // constructor(EternalStorage storage_) public {
        _storage = storage_;
        // _proxyController is the address of the proxy that handles 
        _storage.setAddress(
            ProxyControllerKeyLib.getProxyControllerKey(), 
            _proxyController
        );
    }

    event Upgraded(address indexed implementation);

    /// @notice The implementation address of the 'leeched' contract
    address public _implementation;

    /// @notice Gets the current implementation address
    function implementation() public view returns (address) {
        return _implementation;
    }

    /// @notice Allows the owner to change the implementaion address
    ///   to the next version of the 'leeched' contract.
    /// @param impl -The address of the upgraded 'leeched' contract 
    function upgradeTo(address impl) public onlyOwner {
        require(
            _implementation != impl,
            "New implementation cannot equal current implementation."
        );
        _implementation = impl;
        emit Upgraded(impl);
    }
  
    /// @notice This is where the magic happens. Using `delegatecall()` 
    ///   we are able to make calls to the 'leeched' contract
    function () public payable {
        address _impl = implementation();
        require(
            _impl != address(0),
            "Implementation cannot be address(0)."
        );
        bytes memory data = msg.data;

        /*
        "Let's break down this function:
        `delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0);`

        In this function, delegate call is calling code at “_impl” address 
        with the input “add(data,0x20)” and with input memory size “mload(data)”,
        delegate call will return 0 on error and 1 on success and result of the 
        fallback function is whatever will be returned by the called contract 
        function."
        */
        assembly {
            let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
            let size := returndatasize
            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)
            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
}