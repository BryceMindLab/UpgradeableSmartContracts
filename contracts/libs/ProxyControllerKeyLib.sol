pragma solidity ^0.4.18;

/**
 * @title ProxyControllerKeyLib
 * @dev Computes Keys to create and lookup values in Enternal Storage 
 */
library ProxyControllerKeyLib {
    /* 

    Proxy Controller Key

    */

    function getProxyControllerKey() public pure returns (bytes32) {
        return keccak256(abi.encodePacked("PROXY_CONTROLLER"));
    }
}