// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {AlphaProVault} from "../../src/interfaces/AlphaProVault.sol";

contract AlphaProVaultMock is AlphaProVault {
    uint256 lastRebalance;
    function rebalance() external {
        require(block.timestamp > lastRebalance + 1 days, "PE");
        lastRebalance = block.timestamp;
    }
}