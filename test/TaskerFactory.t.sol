// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test} from "forge-std/test.sol";

import {AlphaProVaultFactoryMock} from "./mocks/AlphaProVaultFactoryMock.sol";
import {TaskerFactory} from "../src/TaskerFactory.sol";

contract TaskerFactoryTest is Test {
    AlphaProVaultFactoryMock vaultFactory;
    TaskerFactory taskerFactory;
    address exampleVault;
    function setUp() public {
        vaultFactory = new AlphaProVaultFactoryMock();
        taskerFactory = new TaskerFactory(address(vaultFactory));
        exampleVault = vaultFactory.createVault();
    }
    function test_createNewTasker() public {
        address tasker = taskerFactory.createNewTasker(exampleVault);
        assertTrue(tasker != address(0));
        assertTrue(taskerFactory.vaultToTaskers(exampleVault) == tasker);
        assertTrue(taskerFactory.taskersLength() == 1);
    }
    function test_noDuplicate() public {
        taskerFactory.createNewTasker(exampleVault);
        vm.expectRevert();
        taskerFactory.createNewTasker(exampleVault);
    }
    function test_noInvalidVault() public {
        vm.expectRevert();
        taskerFactory.createNewTasker(address(5555555));
    }
}