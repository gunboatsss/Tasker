// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

import { L1Block } from "./interfaces/L1Block.sol";
import { AlphaProVault } from "./interfaces/AlphaProVault.sol";
import { ERC20 } from "./interfaces/ERC20.sol";

contract TaskerOptimism {
    // this is length of transaction with zero calldata
    uint256 constant CALLDATA_LENGTH = 120;
    // 1e6 for L1 scalar
    uint256 constant DECIMALS = 1e6;

    L1Block private constant l1block = L1Block(0x4200000000000000000000000000000000000015);
    AlphaProVault public immutable vault;
    constructor(address _vault) {
        vault = AlphaProVault(_vault);
    }
    function fund() payable external {
        emit Funded(msg.value, address(this).balance);
    }
    fallback() external {
        uint256 gasBefore = gasleft();
        vault.rebalance();
        uint256 gasAfter = gasleft();
        uint256 l2fee = (21000 + gasBefore - gasAfter) * block.basefee;
        uint256 calldataLength = CALLDATA_LENGTH + l1block.l1FeeOverhead();
        uint256 l1fee = (calldataLength * l1block.l1FeeScalar()) / DECIMALS;
        uint256 totalPayment = (l1fee + l2fee) * 11000 / 10000;
        emit Worked(msg.sender, totalPayment);
        (bool succ, ) = payable(msg.sender).call{value: totalPayment}("");
        require(succ);
    }

    function recoverERC20(address _token) external {
        ERC20 token = ERC20(_token);
        uint256 balanceof = token.balanceOf(address(this));
        (bool succ, bytes memory returndata) = _token.call(abi.encodeCall(ERC20.transfer, (msg.sender, balanceof)));
        require(succ && (returndata.length == 0 || abi.decode(returndata, (bool))) && _token.code.length > 0);
    }

    event Funded(uint256 amount, uint256 currentBalance);

    event Worked(address indexed worker, uint256 amount);
}