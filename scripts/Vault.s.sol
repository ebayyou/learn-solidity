// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {MockUSDC} from "../contracts/MockUSDC.sol";
import {Vault} from "../contracts/Vault.sol";

contract VaultScript is Script {

    Vault public vault;

    function setUp() public {

    }

    function run() public {
        vm.startBroadcast();
        
        MockUSDC usdc = new MockUSDC();

        vault = new Vault(addres(usdc));

        console.log("Vault deployed at:", address(vault));
        console.log("USDC address used:", address(usdc));

        vm.stopBroadcast();
    }
}