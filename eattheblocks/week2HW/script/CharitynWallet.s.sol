// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Script, console} from "forge-std/Script.sol";
import {Charity} from "../src/Charity.sol";
import {Wallet} from "../src/Wallet.sol";

contract ChairtynWalletScript is Script {
    Charity public charity;
    Wallet public wallet;

    function run() public {
        vm.createSelectFork(vm.rpcUrl("sepolia"));
        uint privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        charity = new Charity(msg.sender, 100 days);
        wallet = new Wallet(msg.sender, address(charity), 50);
        vm.stopBroadcast();

        // Log the addresses for verification
        console.log("Charity deployed at:", address(charity));
        console.log("Wallet deployed at:", address(wallet));
    }
}