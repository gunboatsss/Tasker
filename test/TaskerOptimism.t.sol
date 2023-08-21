// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { Test } from "forge-std/Test.sol";

import { TaskerOptimism } from "../src/TaskerOptimism.sol";

import { AlphaProVaultMock } from "./mocks/AlphaProVaultMock.sol";

contract TaskerOptimismTest is Test {
    TaskerOptimism public tasker;
    AlphaProVaultMock public vault;
    address constant L1_BLOCK = 0x4200000000000000000000000000000000000015;
    function setUp() public {
        deployCodeTo("L1BlockMock.sol", L1_BLOCK);
        vault = new AlphaProVaultMock();
        tasker = new TaskerOptimism(address(vault));
        vm.warp(1692532629);
        vm.fee(200);
    }
    function test_funding() public {
        vm.expectEmit(true, false, false, false, address(tasker));
        emit Funded(1 ether, 1 ether);
        tasker.fund{value: 1 ether}();
    }

    function test_execution() public {
        vm.deal(address(tasker), 1 ether);
        vm.expectEmit(false, false, false, false, address(tasker));
        emit Worked(address(69), 420);
        vm.prank(address(69));
        uint256 before = address(69).balance;
        (bool succ, ) = address(tasker).call("");
        assertTrue(succ);
        assertTrue(address(69).balance > before);
    }

    function test_revert() public {
        vm.deal(address(tasker), 1 ether);
        vm.startPrank(address(69));
        address(tasker).call("");
        vm.expectRevert();
        address(tasker).call("");
    }

    event Funded(uint256 amount, uint256 currentBalance);
    event Worked(address indexed worker, uint256 amount); 
}