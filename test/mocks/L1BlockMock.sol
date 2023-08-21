// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { L1Block } from "../../src/interfaces/L1Block.sol";

contract L1BlockMock is L1Block {
    uint256 public basefee = 10e9; // 10 gwei
    uint256 public l1FeeOverhead = 188;
    uint256 public l1FeeScalar = 684000; // 0.684
}