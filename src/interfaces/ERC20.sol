pragma solidity ^0.8.21;

interface ERC20 {
    function balanceOf(address who) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);
}