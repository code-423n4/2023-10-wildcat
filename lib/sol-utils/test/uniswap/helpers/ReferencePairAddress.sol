// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.15;

address constant UniswapV2_Factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f; // 0xff + factory address
address constant Sushiswap_Factory = 0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac; // 0xff + factory address
address constant UniswapV3_Factory = 0x1F98431c8aD98523631AE4a59f267346ea31F984; // 0xff + factory address

/// @title Provides functions for deriving a pool address from the factory, tokens, and the fee
library ReferencePairAddress {
  /// @notice Deterministically computes the pool address given the factory and PoolKey
  function calculateUniswapV3Pair(
    address token0,
    address token1,
    uint24 fee
  ) internal pure returns (address pool) {
    require(token0 < token1);
    pool = address(
      uint160(
        uint256(
          keccak256(
            abi.encodePacked(
              hex'ff',
              UniswapV3_Factory,
              keccak256(abi.encode(token0, token1, fee)),
              hex'e34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54'
            )
          )
        )
      )
    );
  }

  /// @dev Calculate keccak256(token0 . token1)
  function calculateV2PairSalt(
    address token0,
    address token1
  ) internal pure returns (bytes32 pairSalt) {
    pairSalt = keccak256(abi.encodePacked(token0, token1));
  }

  /// @dev Calculate keccak256(token0 . token1)
  function calculateV3PairSalt(
    address token0,
    address token1,
    uint24 fee
  ) internal pure returns (bytes32 pairSalt) {
    pairSalt = keccak256(abi.encode(token0, token1, fee));
  }

  function calculateUniswapV2Pair(
    address token0,
    address token1
  ) internal pure returns (address pair) {
    pair = address(
      uint160(
        uint256(
          keccak256(
            abi.encodePacked(
              hex'ff',
              UniswapV2_Factory,
              keccak256(abi.encodePacked(token0, token1)),
              hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
            )
          )
        )
      )
    );
  }

  function calculateSushiswapPair(
    address token0,
    address token1
  ) internal pure returns (address pair) {
    pair = address(
      uint160(
        uint256(
          keccak256(
            abi.encodePacked(
              hex'ff',
              Sushiswap_Factory,
              keccak256(abi.encodePacked(token0, token1)),
              hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
            )
          )
        )
      )
    );
  }
}
