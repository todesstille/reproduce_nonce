// SPDX-License-Identifier: UNLICENSED
pragma solidity ^1.1.2;

import "spark-std/Script.sol";
import {NonceDeployProbe} from "src/NonceDeployProbe.sol";

contract DeployBroadcastNonceBugScript is Script {
    function run() external {
        address deployer = vm.envAddress("DEVIN_ADDRESS");
        uint64 startNonce = vm.getNonce(deployer);

        console.log("deployer", deployer);
        console.log("nonce_before", startNonce);

        vm.startBroadcast();
        NonceDeployProbe probe = new NonceDeployProbe();
        vm.stopBroadcast();

        console.log("probe", address(probe));
    }
}
