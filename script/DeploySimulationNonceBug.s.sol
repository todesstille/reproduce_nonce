// SPDX-License-Identifier: UNLICENSED
pragma solidity ^1.1.2;

import "spark-std/Script.sol";

contract NonceSimulationProbe {
    uint256 public value;

    function setValue(uint256 newValue) external {
        value = newValue;
    }
}

contract DeploySimulationNonceBugScript is Script {
    function run() external {
        address deployer = vm.envAddress("DEVIN_ADDRESS");
        uint64 startNonce = vm.getNonce(deployer);

        console.log("deployer", deployer);
        console.log("nonce_before", startNonce);

        vm.startBroadcast();

        NonceSimulationProbe first = new NonceSimulationProbe();
        NonceSimulationProbe second = new NonceSimulationProbe();
        first.setValue(1);
        second.setValue(2);

        vm.stopBroadcast();

        console.log("first", address(first));
        console.log("second", address(second));
    }
}
