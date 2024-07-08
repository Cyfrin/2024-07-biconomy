// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/src/Test.sol";
import "../../../../../contracts/lib/ExecLib.sol";

contract ExecLibTest is Test {
    function setUp() public {}

    function test_encode_decode(address target, uint256 value, bytes memory callData) public {
        bytes memory encoded = ExecLib.encodeSingle(target, value, callData);
        (address _target, uint256 _value, bytes memory _callData) = this.decode(encoded);

        assertTrue(_target == target);
        assertTrue(_value == value);
        assertTrue(keccak256(_callData) == keccak256(callData));
    }

    function decode(bytes calldata encoded) public pure returns (address _target, uint256 _value, bytes calldata _callData) {
        (_target, _value, _callData) = ExecLib.decodeSingle(encoded);
    }
}
