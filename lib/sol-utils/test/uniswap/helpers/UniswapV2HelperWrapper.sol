// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import 'src/uniswap/UniswapV2Helper.sol';
import './ReferenceUniswapV2Helper.sol';

contract UniswapV2HelperWrapper {
  function calculateV2AmountOut(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountOut) {
    return UniswapV2Helper.calculateV2AmountOut(amountIn, reserveIn, reserveOut);
  }

  function calculateV2AmountIn(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountIn) {
    return UniswapV2Helper.calculateV2AmountIn(amountOut, reserveIn, reserveOut);
  }

  function getV2AmountIn(
    address pair,
    bool zeroForOne,
    uint256 amountOut
  ) external view returns (uint256 amountIn) {
    return UniswapV2Helper.getV2AmountIn(pair, zeroForOne, amountOut);
  }

  function getV2AmountOut(
    address pair,
    bool zeroForOne,
    uint256 amountIn
  ) external view returns (uint256 amountOut) {
    return UniswapV2Helper.getV2AmountOut(pair, zeroForOne, amountIn);
  }

  function executeV2Mint(address pair, address to) external {
    UniswapV2Helper.executeV2Mint(pair, to);
  }

  function executeV2Swap(address pair, bool zeroForOne, uint256 amountOut) external {
    UniswapV2Helper.executeV2Swap(pair, zeroForOne, amountOut);
  }

  function executeV2SwapAmountIn(
    address pair,
    bool zeroForOne,
    uint256 amountIn
  ) external returns (uint256 amountOut) {
    return UniswapV2Helper.executeV2SwapAmountIn(pair, zeroForOne, amountIn);
  }
}
