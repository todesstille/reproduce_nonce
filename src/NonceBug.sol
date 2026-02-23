// SPDX-License-Identifier: UNLICENSED
pragma solidity ^1.1.2;

contract NonceA {
    function markerA() external pure returns (uint256) {
        return 1;
    }
}

contract NonceB {
    function markerB() external pure returns (uint256) {
        return 2;
    }
}

contract NonceC {
    address public immutable expectedA;
    address public immutable expectedB;

    constructor(address a, address b) {
        require(a.code.length > 0, "A_NOT_DEPLOYED_AT_EXPECTED_ADDRESS");
        require(b.code.length > 0, "B_NOT_DEPLOYED_AT_EXPECTED_ADDRESS");
        expectedA = a;
        expectedB = b;
    }
}
