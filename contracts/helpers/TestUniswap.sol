pragma solidity ^0.6.10;

contract TestUniswap {
    
    uint public rateMult;
    uint public rateDiv;
    
    constructor(uint _rateMult, uint _rateDiv) public {
        rateMult = _rateMult; // eth price
        rateDiv = _rateDiv; // token price
    }
    
    function WETH() external pure returns (address) {
        return 0xD59378208FB5988D5dB3cf3466fEbbce2a1935c0;
    }
    
    function getAmountsIn(
        uint amountOut, 
        address[] calldata path
        ) 
        external 
        view 
        returns (uint[] memory amounts) {
            
        uint[] memory outAmounts = new uint[](2);
        outAmounts[0] = amountOut * rateDiv / rateMult;
        outAmounts[1] = amountOut;
        
        return outAmounts;
    }

}