// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

interface AlphaProVaultFactory {
    function isVault(address _who) external view returns (bool);   
}