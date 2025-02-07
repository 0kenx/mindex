// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Mindex} from "../src/Mindex.sol";

contract MindexTest is Test {
    Mindex public dex;

    function setUp() public {
        dex = new Mindex();
    }

    function test_AddLiquidity() public {
        dex.mint(10000000, 10000000);
        dex.add_liquidity(100000, 10000, 1);
        assertEq(dex.reserves(0), 100100);
        assertEq(dex.reserves(1), 10100);
    }

    function test_Swap() public {
        dex.mint(10000000000, 1000000000);
        dex.add_liquidity(1000000, 100000, 1);
        uint256 reserve0_old = dex.reserves(0);
        uint256 reserve1_old = dex.reserves(1);
        console.log(reserve0_old, reserve1_old);
        dex.swap(true, 100, 1);
        uint256 reserve0_new = dex.reserves(0);
        uint256 reserve1_new = dex.reserves(1);
        console.log(reserve0_new, reserve1_new);
        assertApproxEqAbs(reserve0_old * reserve1_old, reserve0_new * reserve1_new, 10000);
    }
}
