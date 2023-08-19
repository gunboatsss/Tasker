// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

interface L1Block {
    function basefee() external returns (uint256);

    function l1FeeOverhead() external returns (uint256);
    
    function l1FeeScalar() external returns (uint256);
}