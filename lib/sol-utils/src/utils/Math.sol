// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @dev Return the smaller of `a` and `b`
 */
function min(uint256 a, uint256 b) pure returns (uint256 c) {
  c = ternary(a < b, a, b);
}

/**
 * @dev Return the larger of `a` and `b`.
 */
function max(uint256 a, uint256 b) pure returns (uint256 c) {
  c = ternary(a < b, b, a);
}

/**
 * @dev Saturation subtraction. Subtract `b` from `a` and return the result
 * if it is positive or zero if it underflows.
 */
function satSub(uint256 a, uint256 b) pure returns (uint256 c) {
  assembly {
    // (a > b) * (a - b)
    // If a-b underflows, the product will be zero
    c := mul(gt(a, b), sub(a, b))
  }
}

/**
 * @dev Return `valueIfTrue` if `condition` is true and `valueIfFalse` if it is false.
 *      Equivalent to `condition ? valueIfTrue : valueIfFalse`
 */
function ternary(
  bool condition,
  uint256 valueIfTrue,
  uint256 valueIfFalse
) pure returns (uint256 c) {
  assembly {
    c := add(valueIfFalse, mul(condition, sub(valueIfTrue, valueIfFalse)))
  }
}
