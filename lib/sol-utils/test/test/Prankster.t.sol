// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import { Test } from 'forge-std/Test.sol';
import { Prankster } from 'src/test/Prankster.sol';

contract PranksterTest is Prankster, Test {
  CallerGetter internal callerGetter = new CallerGetter();

  function testPrankStack(uint256 numPranks) external {
    numPranks = bound(numPranks, 0, 10);
    for (uint256 i = 1; i <= numPranks; i++) {
      address prank = address(uint160(i));
      startPrank(prank);
      assertEq(_prankStack.length, i);
      assertEq(_prankStack[i - 1], prank);
      assertEq(callerGetter.getCaller(), prank);
    }

    for (uint256 i = numPranks; i > 0; i--) {
      address prank = address(uint160(i));
      assertEq(callerGetter.getCaller(), prank);
      stopPrank();
      prank = i == 1 ? address(this) : address(uint160(i - 1));
      assertEq(callerGetter.getCaller(), prank);
      assertEq(callerGetter.getCaller(), currentCaller());
      assertEq(_prankStack.length, i - 1);
    }

    assertEq(_prankStack.length, 0);
    assertEq(callerGetter.getCaller(), address(this));
  }

  /* 	function testAsAccount(address prank) external asAccount(prank) {
		assertEq(callerGetter.getCaller(), prank);
	}

	function recursiveTestAsAccount(uint256 i) internal {
		if (i > 0) {}
	} */

  function testAsAccount(address prank) external asAccount(prank) {
    assertEq(callerGetter.getCaller(), prank);
  }
}

contract CallerGetter {
  function getCaller() external view returns (address) {
    return msg.sender;
  }
}
