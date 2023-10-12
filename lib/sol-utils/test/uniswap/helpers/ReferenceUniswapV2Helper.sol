// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import 'src/uniswap/interfaces/IUniswapV2Pair.sol';
import './ReferencePairAddress.sol';
import './UniswapV2ContractsProvider.sol';

contract ReferenceUniswapV2Helper is UniswapV2ContractsProvider {
  function calculateV2AmountOut(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountOut) {
    uint256 amountInWithFee = amountIn * 997;
    uint256 numerator = amountInWithFee * reserveOut;
    uint256 denominator = reserveIn * 1000 + amountInWithFee;
    assembly {
      amountOut := div(numerator, denominator)
    }
  }

  function calculateV2AmountIn(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountIn) {
    uint256 numerator = (reserveIn * amountOut) * (1000);
    uint256 denominator = (reserveOut - amountOut) * (997);
    assembly {
      amountIn := div(numerator, denominator)
    }
    amountIn += 1;
  }

  function getV2AmountIn(
    address pair,
    bool zeroForOne,
    uint256 amountOut
  ) external view returns (uint256 amountIn) {
    address token0 = IUniswapV2Pair(pair).token0();
    address token1 = IUniswapV2Pair(pair).token1();
    (address tokenIn, address tokenOut) = zeroForOne ? (token0, token1) : (token1, token0);
    address[] memory path = new address[](2);
    path[0] = tokenIn;
    path[1] = tokenOut;
    uint256[] memory amounts = uniswapV2Router.getAmountsIn(amountOut, path);
    return amounts[0];
  }

  function getV2AmountOut(
    address pair,
    bool zeroForOne,
    uint256 amountIn
  ) external view returns (uint256 amountOut) {
    address token0 = IUniswapV2Pair(pair).token0();
    address token1 = IUniswapV2Pair(pair).token1();
    (address tokenIn, address tokenOut) = zeroForOne ? (token0, token1) : (token1, token0);
    address[] memory path = new address[](2);
    path[0] = tokenIn;
    path[1] = tokenOut;

    return uniswapV2Router.getAmountsOut(amountIn, path)[1];
  }

  function executeV2Mint(address pair, address recipient) external returns (uint256) {
    return IUniswapV2Pair(pair).mint(recipient);
  }

  function executeV2Swap(address pair, bool zeroForOne, uint256 amountOut) external {
    (uint256 amount0, uint256 amount1) = zeroForOne
      ? (uint256(0), amountOut)
      : (amountOut, uint256(0));
    IUniswapV2Pair(pair).swap(amount0, amount1, address(this), '');
  }

  function getLiquidityAmounts(
    address tokenA,
    address tokenB,
    uint256 amountAMax,
    uint256 amountBMax
  ) external view returns (uint256 amountA, uint256 amountB) {
    (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
    address pair = ReferencePairAddress.calculateUniswapV2Pair(token0, token1);
    uint256 reserveA;
    uint256 reserveB;
    {
      (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(pair).getReserves();
      (reserveA, reserveB) = tokenA < tokenB ? (reserve0, reserve1) : (reserve1, reserve0);
    }
    if (reserveA == 0 && reserveB == 0) {
      (amountA, amountB) = (amountAMax, amountBMax);
    } else {
      uint256 amountBOptimal = (amountAMax * reserveB) / reserveA;
      if (amountBOptimal <= amountBMax) {
        (amountA, amountB) = (amountAMax, amountBOptimal);
      } else {
        uint256 amountAOptimal = (amountBMax * reserveA) / reserveB;
        require(amountAOptimal <= amountAMax);
        (amountA, amountB) = (amountAOptimal, amountBMax);
      }
    }
  }
}
