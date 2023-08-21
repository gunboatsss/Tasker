// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {TaskerFactory} from "../src/TaskerFactory.sol";

contract TaskerFactoryScript is Script {
    address FACTORY_ADDRESS = 0x5B7B8b487D05F77977b7ABEec5F922925B9b2aFa;
    function setUp() public {}

    function run() public {
        vm.broadcast();
        TaskerFactory factory = new TaskerFactory(FACTORY_ADDRESS);
    }
}
