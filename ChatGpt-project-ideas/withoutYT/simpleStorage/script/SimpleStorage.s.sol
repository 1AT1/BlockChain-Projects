// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/SimpleStorage.sol";

contract SimpleStorageDeployment is Script {
    SimpleStorage public simplestorage;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        simplestorage = new SimpleStorage();

        vm.stopBroadcast();

         // Log the addresses for verification
        console.log("SimpleStorage contract deployed at:", address(simplestorage));
    }
}
