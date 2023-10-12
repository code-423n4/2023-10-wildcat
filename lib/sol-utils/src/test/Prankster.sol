// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import { vm } from './ForgeConstants.sol';

/**
 * @dev Helper for forge's vm.prank - creates a stack of
 *      pranked addresses where pranks can be nested and
 *      stopping one prank reverts to the previous prank.
 */
contract Prankster {
  address[] internal _prankStack;

  function currentPrank() internal view returns (address) {
    uint256 pranks = _prankStack.length;
    if (pranks == 0) return address(0);
    return _prankStack[pranks - 1];
  }

  modifier asAccount(address prank) {
    startPrank(prank);
    _;
    stopPrank();
  }

  function currentCaller() internal view returns (address) {
    uint256 pranks = _prankStack.length;
    if (pranks == 0) return address(this);
    return _prankStack[pranks - 1];
  }

  function startPrank(address prank) internal {
    uint256 pranks = _prankStack.length;
    if (pranks > 0) vm.stopPrank();
    vm.startPrank(prank);
    _prankStack.push(prank);
  }

  function stopPrank() internal returns (address pranked) {
    uint256 pranks = _prankStack.length;
    if (pranks == 0) return address(0);
    pranked = _prankStack[--pranks];
    _prankStack.pop();
    vm.stopPrank();
    if (pranks > 0) {
      address previousPrank = _prankStack[pranks - 1];
      vm.startPrank(previousPrank);
    }
  }
}
