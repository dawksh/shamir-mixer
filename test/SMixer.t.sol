// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SMixer.sol";
import {Secrets} from "../src/IMixer.sol";

contract CounterTest is Test {
    SMixer public mixer;
    error InvalidValueSize();

    uint256 internal seed = 27466729;

    function setUp() public {
        mixer = new SMixer();
    }

    function testDeposit() public {
        mixer.deposit{value: 0.1 ether}(
            keccak256(abi.encodePacked(address(this), seed))
        );
    }

    function testFailDepoist() public {
        mixer.deposit{value: 0.2 ether}(
            keccak256(abi.encodePacked(address(this), seed))
        );
        vm.expectRevert();
    }

    function testWithdraw() public {
        Secrets[2] memory secrets = [
            Secrets(1, 27466755),
            Secrets(4, 27466833)
        ];
        mixer.withdraw(secrets);
    }
}
