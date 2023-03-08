// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../dependencies/prb-math/PRBMathSD59x18.sol";

library HedgeMath {
    using PRBMathSD59x18 for int256;

    /// @notice calculatePerHedgeFee
    /// @dev calculate fee paid to user 2
    /// @param expiry expiry
    /// @param fees fees
    /// @param perDay perDay
    /// @return amount amount per hedge
    function calculatePerHedgeFee(int expiry,int fees,int perDay) public pure returns (int amount) {
        amount = fees.div((expiry*365*perDay));
        return amount;
    }

    /// @notice convertYeartoSeconds
    /// @dev convert year to seconds
    /// @param YEAR year in base 1e18 0.5 years = 5e17
    /// @return SECONDS seconds
    function convertYeartoSeconds(int YEAR) public pure returns (int SECONDS) {
        // 24*60*60*365 = 31536000
        SECONDS = YEAR.mul((31536000));
        return SECONDS;
    }

    /// @notice convertSecondstoYear
    /// @dev convert seconds to year
    /// @param SECONDS seconds
    /// @return YEAR year
    function convertSecondstoYear(uint SECONDS) public pure returns (int) {
        // 24*60*60*365 = 31536000
        int YEAR = int(SECONDS).div((31536000));
        return YEAR;
    }

    /// @notice getTimeStampInterval
    /// @dev get interval in seconds between portfolio rebalancing
    /// @dev this will cut off decimal points for primes above 7 (7,11,13...) => to avoid this use prb math...
    /// @param perDay hedging per day
    /// @return interval interval
    function getTimeStampInterval(uint perDay) public pure returns (uint interval) {
        // 24*60*60 = 86400
        interval = (86400) / perDay;
        return interval;
    }

    // @dev calculate previous delta
    function calculatePreviousDelta(uint tokenB_balance, uint amount) public pure returns (int previousDelta) {
        previousDelta = int(tokenB_balance).div(int(amount));
    }

    /// @notice minimum_Liquidity_Call
    /// @dev returns minimum required liquidity to replicate amount of call option contracts
    /// @param amount amount of contracts
    /// @param delta delta of option
    /// @param price price of token
    /// @return minimum minimum amount 
    function minimum_Liquidity_Call(uint amount, int delta, int price) public pure returns (uint minimum) {
        minimum = uint(int(amount).mul(delta).mul(price));
        return minimum;
    }

    /// @notice minimum_Liquidity_Put
    /// @dev returns minimum required liquidity to replicate amount of put option contracts
    /// @param amount amount of contracts
    /// @param delta delta of option
    /// @return minimum minimum amount 
    function minimum_Liquidity_Put(uint amount, int delta) public pure returns (uint minimum) {
        minimum = uint(int(amount).mul(delta));
        return minimum;
    }

    /// @notice checkSlippage
    /// @dev Check if realized slippage is < maxSlippage
    /// @param amountIn amountIn
    /// @param amountOut amountOut
    /// @param price price
    /// @param maxSlippage maxSlippage
    function checkSlippageAmount(int amountIn, int amountOut, int price, int maxSlippage) public pure returns (bool) {
        int amountOutOptimal = amountIn.mul(price);
        int realizedSlippage = (amountOut.div(amountOutOptimal) - 1e18).abs();

        require(realizedSlippage <= maxSlippage, "Slippage Exceeded Limit");

        return true;
    }

    /// @notice scaleTo
    /// @dev returns scaled value
    /// @param baseFrom decimals from
    /// @param baseTo decimals to 
    /// @return adjusted adjusted amount
    function scaleTo(uint baseFrom, uint baseTo, uint value) public pure returns (uint adjusted) {
        if (baseTo > baseFrom) {
            // scale up
            uint factor = baseTo - baseFrom;
            adjusted = value * 10**factor;
            //adjusted = value.mul(uint(10e18).pow(factor.mul(1e18)));
        } else {
            // scale down
            uint factor = baseFrom - baseTo;
            adjusted = value / 10**factor;
            // adjusted = value.div(uint(10e18).pow(factor.mul(1e18)));
        }
        return adjusted;
    }
}
    