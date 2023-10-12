// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.15;

import 'src/uniswap/interfaces/IUniswapV2Pair.sol';

contract MockUniswapV2Pair {
  event Mint(address sender, address to);
  event Swap(address sender, uint amount0Out, uint amount1Out, address to, bytes32 dataHash);

  function mint(address to) external returns (uint256) {
    emit Mint(msg.sender, to);
    return 1000;
  }

  function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external {
    emit Swap(msg.sender, amount0Out, amount1Out, to, keccak256(data));
  }
}
