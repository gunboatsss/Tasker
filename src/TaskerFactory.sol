// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

import {AlphaProVaultFactory} from "./interfaces/AlphaProVaultFactory.sol";
import {TaskerOptimism} from "./TaskerOptimism.sol";

contract TaskerFactory {
    AlphaProVaultFactory public immutable factory;

    address[] public taskers;

    mapping(address _vaultAddress => address _taskerAddress) public vaultToTaskers;

    constructor(address _factory) {
        factory = AlphaProVaultFactory(_factory);
    }

    function taskersLength() external view returns (uint256) {
        return taskers.length;
    }

    function createNewTasker(address _vault) external returns (address) {
        if (!factory.isVault(_vault)) {
            revert InvalidVaultAddress();
        }
        if (vaultToTaskers[_vault] != address(0)) {
            revert TaskerAlreadyExisted();
        }
        TaskerOptimism newTasker = new TaskerOptimism{salt: bytes32(bytes20(_vault))}(_vault);
        taskers.push(address(newTasker));
        vaultToTaskers[_vault] = address(newTasker);
        emit NewTasker(address(newTasker), _vault);
        return address(newTasker);
    }

    error InvalidVaultAddress();
    error TaskerAlreadyExisted();

    event NewTasker(address indexed tasker, address indexed vault);
}