// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ZethereumCore {
    bool public isInitialized;
    
    constructor() {
        isInitialized = true;
    }
    
    function getStatus() public view returns (bool) {
        return isInitialized;
    }
}