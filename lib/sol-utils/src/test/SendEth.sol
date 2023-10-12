// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

contract SendEth {
  constructor(address target) payable {
    assembly {
      selfdestruct(target)
    }
  }
}

function forceTransferETH(address target, uint256 amount) {
  new SendEth{ value: amount }(target);
}
