// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {AlphaProVaultFactory} from "../../src/interfaces/AlphaProVaultFactory.sol";
import {AlphaProVaultMock} from "./AlphaProVaultMock.sol";

contract AlphaProVaultFactoryMock is AlphaProVaultFactory {
    mapping(address _who => bool existed) public isVault;

    function createVault() external returns (address) {
        AlphaProVaultMock vault = new AlphaProVaultMock();
        isVault[address(vault)] = true;
        return address(vault);
    }
}