// SPDX-License-Identifier: UNLICENSED
pragma solidity ^1.1.2;

import "spark-std/Script.sol";
import {NonceA, NonceB, NonceC} from "src/NonceBug.sol";

contract DeployNonceBugScript is Script {
    function run() external {
        address deployer = vm.envAddress("DEVIN_ADDRESS");
        uint64 startNonce = vm.getNonce(deployer);

        address expectedA = vm.computeCreateAddress(deployer, startNonce);
        address expectedB = vm.computeCreateAddress(deployer, startNonce + 1);

        vm.startBroadcast();

        NonceA a = new NonceA();
        NonceB b = new NonceB();
        NonceC c = new NonceC(expectedA, expectedB);

        console.log("deployer", deployer);
        console.log("startNonce", startNonce);
        console.log("expectedA", expectedA);
        console.log("expectedB", expectedB);
        console.log("actualA", address(a));
        console.log("actualB", address(b));
        console.log("c", address(c));

        vm.stopBroadcast();
    }
}
