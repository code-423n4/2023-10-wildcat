// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

uint256 constant OneWordShift = 0x5;
uint256 constant FreeMemoryPointerSlot = 0x40;
uint256 constant CostPerWord = 0x3;
uint256 constant MemoryExpansionCoefficientShift = 0x9;

function calculateMemoryExpansionCost(uint256 numWords) pure returns (uint256 cost) {
  assembly {
    let msizeWords := shr(OneWordShift, mload(FreeMemoryPointerSlot))
    cost := add(
      mul(CostPerWord, numWords),
      add(
        mul(sub(numWords, msizeWords), CostPerWord),
        shr(
          MemoryExpansionCoefficientShift,
          sub(mul(numWords, numWords), mul(msizeWords, msizeWords))
        )
      )
    )
  }
}
