// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SMixer.sol";

contract CounterTest is Test {
    SMixer public mixer;

    function setUp() public {
        mixer = new SMixer();
    }
}
