// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

import {AlphaProVaultFactory} from "./interfaces/AlphaProVaultFactory.sol";
import {ERC20} from "./interfaces/ERC20.sol";
import {TaskerOptimism} from "./TaskerOptimism.sol";

contract TaskerFactory {
    AlphaProVaultFactory public immutable factory;

    address[] public taskers;

    mapping(address _vaultAddress => address _taskerAddress) public vaultToTaskers;
    mapping(address _who => bool) public isTasker;

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
        address tasker = address(newTasker);
        taskers.push(tasker);
        vaultToTaskers[_vault] = tasker;
        isTasker[tasker] = true;
        emit NewTasker(tasker, _vault);
        return tasker;
    }

    function recoverERC20(address _token) external {
        ERC20 token = ERC20(_token);
        uint256 balanceof = token.balanceOf(address(this));
        (bool succ, bytes memory returndata) = _token.call(abi.encodeCall(ERC20.transfer, (msg.sender, balanceof)));
        require(succ && (returndata.length == 0 || abi.decode(returndata, (bool))) && _token.code.length > 0);
    }

    error InvalidVaultAddress();
    error TaskerAlreadyExisted();

    event NewTasker(address indexed tasker, address indexed vault);
}