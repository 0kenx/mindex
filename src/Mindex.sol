// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import {Test, console} from "forge-std/Test.sol";
contract Mindex {
    mapping(address => uint128[2]) public wallets;
    uint128[2] public reserves;

    constructor() {
        // give the pool some initial liquidity to start with
        reserves[0] = 100;
        reserves[1] = 100;
    }

    function mint(uint128 amount0, uint128 amount1) public {
        uint128[2] storage wallet = wallets[msg.sender];
        wallet[0] += amount0;
        wallet[1] += amount1;
    }

    // Add unbalanced liquidity
    function add_liquidity(uint128 amount0, uint128 amount1, uint128 min_lp) public {
        uint128[2] storage wallet = wallets[msg.sender];
        require(wallet[0] >= amount0 && wallet[1] >= amount1, "Insufficient funds");
        wallet[0] -= amount0;
        wallet[1] -= amount1;
        require((reserves[0] + amount0) * (reserves[1] + amount1) - amount0 * amount1 
            > min_lp * min_lp, "Slippage too high");
        reserves[0] += amount0;
        reserves[1] += amount1;
    }

    // Swaps exact amount in for amount out.
    // dir: true -> swap token0 for token1, vice versa.
    // Swap curve is x*y = C
    function swap(bool dir, uint128 amount_in, uint128 amount_out_min) public {
        uint128[2] storage wallet = wallets[msg.sender];
        uint out;
        if (dir) {
            require(wallet[0] >= amount_in, "Insufficient funds");
            wallet[0] -= amount_in;
            out = amount_in * reserves[1] / (reserves[0] + amount_in);
            require(out >= amount_out_min, "Slippage too high");
            require(reserves[1] > out, "Impossible error");
            reserves[0] += amount_in;
            reserves[1] -= uint128(out);
            wallet[1] += uint128(out);
        } else {
            require(wallet[1] >= amount_in, "Insufficient funds");
            wallet[1] -= amount_in;
            out = amount_in * reserves[0] / (reserves[1] + amount_in);
            require(out >= amount_out_min, "Slippage too high");
            require(reserves[0] > out, "Impossible error");
            reserves[1] += amount_in;
            reserves[0] -= uint128(out);
            wallet[0] += uint128(out);
        }
    }
}
