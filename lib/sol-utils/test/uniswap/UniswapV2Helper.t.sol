// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import 'forge-std/Test.sol';
import './helpers/UniswapV2HelperWrapper.sol';
import './helpers/ReferenceUniswapV2Helper.sol';
import './helpers/MockUniswapV2Pair.sol';
import './helpers/BasePairTest.sol';

contract UniswapV2HelperTest is Test, BasePairTest {
  using SafeTransferLib for address;

  UniswapV2HelperWrapper helper;
  ReferenceUniswapV2Helper referenceHelper;

  function setUp() public {
    helper = new UniswapV2HelperWrapper();
    referenceHelper = new ReferenceUniswapV2Helper();
    pair = address(new MockUniswapV2Pair());
  }

  function mulOverflows(uint256 a, uint256 b) internal pure returns (bool overflow, uint256 c) {
    unchecked {
      if (a == 0 || b == 0) return (false, 0);
      c = a * b;
      overflow = c / a != b;
    }
  }

  function addOverflows(uint256 a, uint256 b) internal pure returns (bool overflow, uint256 c) {
    unchecked {
      c = a + b;
      overflow = a > c;
    }
  }

  function subOverflows(uint256 a, uint256 b) internal pure returns (bool overflow, uint256 c) {
    unchecked {
      overflow = b > a;
      c = a - b;
    }
  }

  function calculateAmountOut(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut
  ) internal pure returns (uint256 amountOut, bool overflows) {
    (bool overflows1, uint256 amountInWithFee) = mulOverflows(amountIn, 997);
    (bool overflows2, uint256 numerator) = mulOverflows(amountInWithFee, reserveOut);
    (bool overflows3, uint256 denominator1) = mulOverflows(reserveIn, 1000);
    (bool overflows4, uint256 denominator) = addOverflows(denominator1, amountInWithFee);
    assembly {
      amountOut := div(numerator, denominator)
    }
    overflows = (overflows1 || overflows2 || overflows3 || overflows4);
  }

  function calculateAmountIn(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
  ) internal pure returns (uint256 amountIn, bool overflows) {
    (bool overflows1, uint256 numerator1) = mulOverflows(reserveIn, amountOut);
    (bool overflows2, uint256 numerator) = mulOverflows(numerator1, 1000);
    (bool overflows3, uint256 denominator1) = subOverflows(reserveOut, amountOut);
    (bool overflows4, uint256 denominator) = mulOverflows(denominator1, 997);
    assembly {
      amountIn := add(div(numerator, denominator), 1)
    }
    overflows = (overflows1 || overflows2 || overflows3 || overflows4);
  }

  function test_calculateAmountOut1(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut
  ) external {
    (uint256 amountOut, bool overflows) = calculateAmountOut(amountIn, reserveIn, reserveOut);
    if (overflows) {
      vm.expectRevert(stdError.arithmeticError);
      helper.calculateV2AmountOut(amountIn, reserveIn, reserveOut);
    } else {
      assertEq(
        helper.calculateV2AmountOut(amountIn, reserveIn, reserveOut),
        amountOut,
        'Calculator 1 is off'
      );
    }
  }

  function test_calculateAmountOut2(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut
  ) external {
    (uint256 amountOut, bool overflows) = calculateAmountOut(amountIn, reserveIn, reserveOut);
    if (overflows) {
      vm.expectRevert(stdError.arithmeticError);
      referenceHelper.calculateV2AmountOut(amountIn, reserveIn, reserveOut);
    } else {
      assertEq(
        referenceHelper.calculateV2AmountOut(amountIn, reserveIn, reserveOut),
        amountOut,
        'Calculator 2 is off'
      );
    }
  }

  function checkOverflowsV2AmountIn(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
  ) internal pure returns (bool overflow0, bool overflow1, bool overflow2, bool overflow3) {
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
      let
        // errorBuffer,
        numeratorPart1,
        numerator,
        denominatorPart1,
        denominator


      numeratorPart1, overflow0 := smMul(reserveIn, amountOut, 0)
      numerator, overflow1 := smMul(numeratorPart1, 1000, 0)

      denominatorPart1, overflow2 := smSub(reserveOut, amountOut, 0)
      denominator, overflow3 := smMul(denominatorPart1, 997, 0)
    }
  }

  function test_calculateAmountIn1(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
  ) external {
    (uint256 amountIn, bool overflows) = calculateAmountIn(amountOut, reserveIn, reserveOut);
    if (overflows) {
      vm.expectRevert(stdError.arithmeticError);
      helper.calculateV2AmountIn(amountOut, reserveIn, reserveOut);
    } else {
      assertEq(
        helper.calculateV2AmountIn(amountOut, reserveIn, reserveOut),
        amountIn,
        'Calculator 1 is off'
      );
    }
  }

  function test_calculateAmountIn2(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
  ) external {
    (uint256 amountIn, bool overflows) = calculateAmountIn(amountOut, reserveIn, reserveOut);
    if (overflows) {
      vm.expectRevert(stdError.arithmeticError);
      referenceHelper.calculateV2AmountIn(amountOut, reserveIn, reserveOut);
    } else {
      assertEq(
        referenceHelper.calculateV2AmountIn(amountOut, reserveIn, reserveOut),
        amountIn,
        'Calculator 2 is off'
      );
    }
  }

  event Mint(address sender, address to);
  event Swap(address sender, uint amount0Out, uint amount1Out, address to, bytes32 dataHash);

  function test_executeV2Mint_1(address recipient) external {
    vm.expectEmit(true, false, false, true);
    emit Mint(address(helper), recipient);
    helper.executeV2Mint(pair, recipient);
  }

  function test_executeV2Mint_2(address recipient) external {
    vm.expectEmit(true, false, false, true, pair);
    emit Mint(address(referenceHelper), recipient);
    referenceHelper.executeV2Mint(pair, recipient);
  }

  function test_executeV2Swap_1(bool zeroForOne, uint256 amount) external {
    vm.expectEmit(true, false, false, true, pair);
    (uint256 amount0, uint256 amount1) = zeroForOne ? (uint256(0), amount) : (amount, uint256(0));
    emit Swap(address(helper), amount0, amount1, address(helper), keccak256(''));
    helper.executeV2Swap(pair, zeroForOne, amount);
  }

  function testGetAmountIn(
    bool pairZeroForOne,
    bool swapZeroForOne,
    uint256 amountOut
  ) external pairTest(pairZeroForOne) {
    address tokenOut = pairZeroForOne == swapZeroForOne ? pairedToken : token;
    amountOut = bound(amountOut, 1, tokenOut.balanceOf(pair) - 1);
    uint256 amountIn = helper.getV2AmountIn(pair, swapZeroForOne, amountOut);
    assertEq(referenceHelper.getV2AmountIn(pair, swapZeroForOne, amountOut), amountIn);
  }

  function testGetAmountOut(
    bool pairZeroForOne,
    bool swapZeroForOne,
    uint256 amountIn
  ) external pairTest(pairZeroForOne) {
    amountIn = bound(amountIn, 1, type(uint128).max);
    uint256 amountOut = helper.getV2AmountOut(pair, swapZeroForOne, amountIn);
    assertEq(referenceHelper.getV2AmountOut(pair, swapZeroForOne, amountIn), amountOut);
  }

  function testExecuteV2Swap(
    bool pairZeroForOne,
    bool swapZeroForOne,
    uint256 amountOut
  ) external pairTest(pairZeroForOne) {
    (address tokenIn, address tokenOut) = pairZeroForOne == swapZeroForOne
      ? (token, pairedToken)
      : (pairedToken, token);

    amountOut = bound(amountOut, 1, tokenOut.balanceOf(pair) - 1e18);

    uint256 amountIn = referenceHelper.getV2AmountIn(pair, swapZeroForOne, amountOut);

    address from = address(0xabab);
    MockERC20(tokenIn).mint(from, amountIn);

    vm.startPrank(from);
    tokenIn.safeTransfer(pair, amountIn);

    helper.executeV2Swap(pair, swapZeroForOne, amountOut);
    assertEq(tokenIn.balanceOf(from), 0, 'sender balance tokenIn');
    assertEq(tokenIn.balanceOf(address(helper)), 0, 'helper balance tokenIn');
    assertEq(tokenOut.balanceOf(address(helper)), amountOut, 'helper balance tokenOut');
  }

  function testFailExecuteV2SwapOverflow(
    bool pairZeroForOne,
    bool swapZeroForOne,
    uint256 amountOut
  ) external pairTest(pairZeroForOne) {
    (address tokenIn, address tokenOut) = pairZeroForOne == swapZeroForOne
      ? (token, pairedToken)
      : (pairedToken, token);

    uint256 amountIn = (type(uint112).max + 1) - tokenIn.balanceOf(pair);
    uint256 amountOut = helper.getV2AmountIn(pair, swapZeroForOne, amountIn);

    address from = address(0xabab);
    MockERC20(tokenIn).mint(from, amountIn);

    vm.startPrank(from);
    tokenIn.safeTransfer(pair, amountIn);

    vm.expectRevert('UniswapV2: OVERFLOW');
    helper.executeV2Swap(pair, swapZeroForOne, amountOut);
  }
}
