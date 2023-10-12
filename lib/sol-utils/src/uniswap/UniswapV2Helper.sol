// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import { PairAddress } from './PairAddress.sol';
import './UniswapConstants.sol';
import '../utils/ErrorConstants.sol';

library UniswapV2Helper {
  function calculateV2AmountOut(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut
  ) internal pure returns (uint256 amountOut) {
    assembly {
      // ((xy / y) != x) * y
      function smMul(x, y, errBufferIn) -> z, errBufferOut {
        z := mul(x, y)
        errBufferOut := or(errBufferIn, mul(y, iszero(eq(div(z, y), x))))
      }
      // y > x+y
      function smAdd(x, y, errBufferIn) -> z, errBufferOut {
        z := add(x, y)
        errBufferOut := or(errBufferIn, gt(y, z))
      }
      let errorBuffer, amountInWithFee, numerator, denominatorPart1, denominator

      amountInWithFee, errorBuffer := smMul(amountIn, 997, errorBuffer)
      numerator, errorBuffer := smMul(amountInWithFee, reserveOut, errorBuffer)
      denominatorPart1, errorBuffer := smMul(reserveIn, 1000, errorBuffer)
      denominator, errorBuffer := smAdd(denominatorPart1, amountInWithFee, errorBuffer)
      amountOut := div(numerator, denominator)
      if errorBuffer {
        // Store the Panic error signature.
        mstore(0, Panic_ErrorSelector)
        // Store the arithmetic (0x11) panic code.
        mstore(Panic_ErrorCodePointer, Panic_Arithmetic)
        // revert(abi.encodeWithSignature("Panic(uint256)", 0x11))
        revert(Error_SelectorPointer, Panic_ErrorLength)
      }
    }
  }

  function calculateV2AmountIn(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
  ) internal pure returns (uint256 amountIn) {
    assembly {
      // ((xy / y) != x) * y
      function smMul(x, y, errBufferIn) -> z, errBufferOut {
        z := mul(x, y)
        errBufferOut := or(errBufferIn, mul(y, iszero(eq(div(z, y), x))))
      }
      // y > x+y
      function smAdd(x, y, errBufferIn) -> z, errBufferOut {
        z := add(x, y)
        errBufferOut := or(errBufferIn, gt(y, z))
      }
      // x < y
      function smSub(x, y, errBufferIn) -> z, errBufferOut {
        z := sub(x, y)
        errBufferOut := or(errBufferIn, lt(x, y))
      }
      let errorBuffer, numeratorPart1, numerator, denominatorPart1, denominator

      numeratorPart1, errorBuffer := smMul(reserveIn, amountOut, errorBuffer)
      numerator, errorBuffer := smMul(numeratorPart1, 1000, errorBuffer)

      denominatorPart1, errorBuffer := smSub(reserveOut, amountOut, errorBuffer)
      denominator, errorBuffer := smMul(denominatorPart1, 997, errorBuffer)
      amountIn := add(div(numerator, denominator), 1)
      if errorBuffer {
        // Store the Panic error signature.
        mstore(0, Panic_ErrorSelector)
        // Store the arithmetic (0x11) panic code.
        mstore(Panic_ErrorCodePointer, Panic_Arithmetic)
        // revert(abi.encodeWithSignature("Panic(uint256)", 0x11))
        revert(Error_SelectorPointer, Panic_ErrorLength)
      }
    }
  }

  function getV2Reserves(
    address pair,
    bool zeroForOne
  ) internal view returns (uint256 reserveIn, uint256 reserveOut) {
    assembly {
      mstore(UniswapV2_GetReserves_Selector_Pointer, UniswapV2_GetReserves_Selector)
      let success := staticcall(
        gas(),
        pair,
        UniswapV2_GetReserves_Calldata_Pointer,
        UniswapV2_GetReserves_Calldata_Size,
        UniswapV2_GetReserves_Returndata_Reserves0_Pointer,
        UniswapV2_GetReserves_Returndata_Size
      )
      if iszero(success) {
        returndatacopy(0, 0, returndatasize())
        revert(0, returndatasize())
      }
      let reserveOutPtr := shl(5, zeroForOne) // zeroForOne ? 32 : 0
      reserveOut := mload(reserveOutPtr)
      let reserveInPtr := sub(32, reserveOutPtr)
      reserveIn := mload(reserveInPtr)
    }
  }

  function getV2AmountOut(
    address pair,
    bool zeroForOne,
    uint256 amountIn
  ) internal view returns (uint256) {
    (uint256 reserveIn, uint256 reserveOut) = getV2Reserves(pair, zeroForOne);
    return calculateV2AmountOut(amountIn, reserveIn, reserveOut);
  }

  function getV2AmountIn(
    address pair,
    bool zeroForOne,
    uint256 amountOut
  ) internal view returns (uint256) {
    (uint256 reserveIn, uint256 reserveOut) = getV2Reserves(pair, zeroForOne);
    return calculateV2AmountIn(amountOut, reserveIn, reserveOut);
  }

  function executeV2Burn(
    address pair,
    address recipient,
    bool zeroForOne
  ) internal returns (uint amountIn, uint amountOut) {
    assembly {
      mstore(UniswapV2_Burn_Selector_Pointer, UniswapV2_Burn_Selector)
      mstore(UniswapV2_Burn_Recipient_Pointer, recipient)

      let callStatus := call(
        gas(),
        pair,
        0,
        UniswapV2_Burn_Calldata_Pointer,
        UniswapV2_Burn_Calldata_Size,
        UniswapV2_Burn_Returndata_Pointer,
        UniswapV2_Burn_Returndata_Size
      )
      // If call succeeded, check it returned at least 63 bytes.
      if iszero(and(gt(returndatasize(), 0x3f), callStatus)) {
        returndatacopy(0, 0, returndatasize())
        revert(0, returndatasize())
      }
      let amountOutPtr := shl(5, zeroForOne) // zeroForOne ? 32 : 0
      amountIn := mload(amountOutPtr)
      let reserveInPtr := sub(32, amountOutPtr)
      amountOut := mload(reserveInPtr)
    }
  }

  function executeV2Swap(address pair, bool zeroForOne, uint256 amountOut) internal {
    assembly {
      let freeMemoryPointer := mload(0x40)
      let amountOutOffset := shl(5, zeroForOne)
      let nullAmountOffset := sub(0x20, amountOutOffset)
      mstore(add(freeMemoryPointer, UniswapV2_Swap_Selector_Offset), UniswapV2_Swap_Selector)
      mstore(
        add(add(freeMemoryPointer, UniswapV2_Swap_Amount0Out_Offset), amountOutOffset),
        amountOut
      )
      mstore(add(add(freeMemoryPointer, UniswapV2_Swap_Amount0Out_Offset), nullAmountOffset), 0)
      mstore(add(freeMemoryPointer, UniswapV2_Swap_Recipient_Offset), address())
      mstore(
        add(freeMemoryPointer, UniswapV2_Swap_Data_Head_Offset),
        UniswapV2_Swap_Data_Head_Offset
      )
      mstore(add(freeMemoryPointer, UniswapV2_Swap_Data_Length_Offset), 0)
      let success := call(
        gas(),
        pair,
        0,
        add(freeMemoryPointer, UniswapV2_Swap_Calldata_Offset),
        UniswapV2_Swap_Calldata_Size,
        0,
        0
      )
      if iszero(success) {
        returndatacopy(0, 0, returndatasize())
        revert(0, returndatasize())
      }
    }
  }

  function executeV2SwapAmountIn(
    address pair,
    bool zeroForOne,
    uint256 amountIn
  ) internal returns (uint256 amountOut) {
    amountOut = getV2AmountOut(pair, zeroForOne, amountIn);
    executeV2Swap(pair, zeroForOne, amountOut);
  }

  function executeV2Mint(address pair, address recipient) internal returns (uint256 liquidity) {
    assembly {
      mstore(UniswapV2_Mint_Selector_Pointer, UniswapV2_Mint_Selector)
      mstore(UniswapV2_Mint_Recipient_Pointer, recipient)

      let callStatus := call(
        gas(),
        pair,
        0,
        UniswapV2_Mint_Calldata_Pointer,
        UniswapV2_Mint_Calldata_Size,
        UniswapV2_Mint_Returndata_Pointer,
        UniswapV2_Mint_Returndata_Size
      )
      // If call succeeded, check it returned at least 31 bytes.
      if iszero(and(gt(returndatasize(), 0x1f), callStatus)) {
        returndatacopy(0, 0, returndatasize())
        revert(0, returndatasize())
      }
      liquidity := mload(UniswapV2_Mint_Returndata_Pointer)
    }
  }

  function executeV2Sync(address pair) internal {
    assembly {
      mstore(UniswapV2_Sync_Selector_Pointer, UniswapV2_Sync_Selector)

      let callStatus := call(
        gas(),
        pair,
        0,
        UniswapV2_Sync_Calldata_Pointer,
        UniswapV2_Sync_Calldata_Size,
        0,
        0
      )
      // If call failed, revert.
      if iszero(callStatus) {
        returndatacopy(0, 0, returndatasize())
        revert(0, returndatasize())
      }
    }
  }
}
