// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {Mindex} from "../src/Mindex.sol";

contract MindexScript is Script {
    Mindex public dex;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        dex = new Mindex();

        vm.stopBroadcast();
    }
}
