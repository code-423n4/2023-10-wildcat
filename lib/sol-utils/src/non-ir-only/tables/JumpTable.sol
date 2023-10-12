// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

/*//////////////////////////////////////////////////////////////
                            Constants
//////////////////////////////////////////////////////////////*/

uint256 constant BitsInJumpDest = 0x10;
uint256 constant MaskIncludeFirstJumpDest = (
  0xffff000000000000000000000000000000000000000000000000000000000000
);
uint256 constant MaskIncludeLastJumpDest = 0xffff;
uint256 constant MaskExcludeFirstJumpDest = (
  0x0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
);
uint256 constant BitsAfterJumpDest = 0xf0;

/*//////////////////////////////////////////////////////////////
                        Basic type utils
//////////////////////////////////////////////////////////////*/

type JumpTable is uint256;

JumpTable constant EmptyJumpTable = JumpTable.wrap(0);

function toJumpTable(uint256 _table) pure returns (JumpTable table) {
  assembly {
    table := _table
  }
}

/**
 * @dev Shift `fn` to the position occupied by `key` in a sequence
 * of 2 byte values.
 */
function positionJD(uint256 key, function() internal fn) pure returns (uint256 positioned) {
  assembly {
    // Calculate number of bits to the right of position `key`
    let bitsFromRight := sub(BitsAfterJumpDest, mul(BitsInJumpDest, key))
    // Apply mask to include only last 2 bytes of `fn`
    // then shift it to the position for the `key`.
    positioned := shl(bitsFromRight, and(fn, MaskIncludeLastJumpDest))
  }
}

/*//////////////////////////////////////////////////////////////
                   Write to table on the stack
//////////////////////////////////////////////////////////////*/

/**
 *
 * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
 *
 * Note: Does not check for out-of-bounds `key`
 *
 */
function write(
  JumpTable table,
  uint256 key,
  function() internal fn
) pure returns (JumpTable updatedTable) {
  assembly {
    // Calculate number of bits to the right of position `key`
    let bitsFromRight := sub(BitsAfterJumpDest, mul(BitsInJumpDest, key))

    // Apply mask to include only last 2 bytes of `fn`,
    // then shift it to the position for the `key`.
    let positioned := shl(bitsFromRight, and(fn, MaskIncludeLastJumpDest))

    // Apply mask to remove the existing value for `key`
    let cleaned := not(shl(bitsFromRight, MaskIncludeLastJumpDest))
    // Update table with new value and return the result
    updatedTable := or(and(table, cleaned), positioned)
  }
}

/**
 *
 * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
 *  The result will be the inclusive OR of the old and new values.
 * Note: Does not check for out-of-bounds `key`
 *
 */
function writeUnsafe(
  JumpTable table,
  uint256 key,
  function() internal fn
) pure returns (JumpTable updatedTable) {
  assembly {
    // Calculate number of bits to the right of position `key`
    let bitsFromRight := sub(BitsAfterJumpDest, mul(BitsInJumpDest, key))

    // Apply mask to include only last 2 bytes of `fn`,
    // then shift it to the position for the `key`.
    let positioned := shl(bitsFromRight, and(fn, MaskIncludeLastJumpDest))

    // Update table with new value and return the result
    updatedTable := or(table, positioned)
  }
}

/*//////////////////////////////////////////////////////////////
                  Jump from table on the stack
//////////////////////////////////////////////////////////////*/

/**
 * @dev Jump to the function pointer stored at `key` in `table`
 * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
 * (revert consuming all gas) if the value at `key` is not a valid function pointer.
 */
function goto(JumpTable table, uint256 key) {
  function() internal fn;
  assembly {
    let bitsFromRight := sub(BitsAfterJumpDest, mul(BitsInJumpDest, key))
    fn := and(shr(bitsFromRight, table), MaskIncludeLastJumpDest)
  }
  fn();
}

/**
 * @dev Jump to the function pointer stored at `key` in `table` if one exists
 */
function gotoIfExists(JumpTable table, uint256 key) returns (bool exists) {
  function() internal fn;
  assembly {
    let bitsFromRight := sub(BitsAfterJumpDest, mul(BitsInJumpDest, key))
    fn := and(shr(bitsFromRight, table), MaskIncludeLastJumpDest)
    exists := gt(fn, 0)
  }
  if (exists) fn();
}

/*//////////////////////////////////////////////////////////////
                 Create table from stack inputs
//////////////////////////////////////////////////////////////*/

function createJumpTable(function() internal fn0) pure returns (JumpTable table) {
  table = toJumpTable(positionJD(0, fn0));
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1
) pure returns (JumpTable table) {
  table = toJumpTable(positionJD(0, fn0) | positionJD(1, fn1));
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2
) pure returns (JumpTable table) {
  table = toJumpTable(positionJD(0, fn0) | positionJD(1, fn1) | positionJD(2, fn2));
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) | positionJD(1, fn1) | positionJD(2, fn2) | positionJD(3, fn3)
  );
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3,
  function() internal fn4
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) |
      positionJD(1, fn1) |
      positionJD(2, fn2) |
      positionJD(3, fn3) |
      positionJD(4, fn4)
  );
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3,
  function() internal fn4,
  function() internal fn5
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) |
      positionJD(1, fn1) |
      positionJD(2, fn2) |
      positionJD(3, fn3) |
      positionJD(4, fn4) |
      positionJD(5, fn5)
  );
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3,
  function() internal fn4,
  function() internal fn5,
  function() internal fn6
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) |
      positionJD(1, fn1) |
      positionJD(2, fn2) |
      positionJD(3, fn3) |
      positionJD(4, fn4) |
      positionJD(5, fn5) |
      positionJD(6, fn6)
  );
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3,
  function() internal fn4,
  function() internal fn5,
  function() internal fn6,
  function() internal fn7
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) |
      positionJD(1, fn1) |
      positionJD(2, fn2) |
      positionJD(3, fn3) |
      positionJD(4, fn4) |
      positionJD(5, fn5) |
      positionJD(6, fn6) |
      positionJD(7, fn7)
  );
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3,
  function() internal fn4,
  function() internal fn5,
  function() internal fn6,
  function() internal fn7,
  function() internal fn8
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) |
      positionJD(1, fn1) |
      positionJD(2, fn2) |
      positionJD(3, fn3) |
      positionJD(4, fn4) |
      positionJD(5, fn5) |
      positionJD(6, fn6) |
      positionJD(7, fn7) |
      positionJD(8, fn8)
  );
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3,
  function() internal fn4,
  function() internal fn5,
  function() internal fn6,
  function() internal fn7,
  function() internal fn8,
  function() internal fn9
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) |
      positionJD(1, fn1) |
      positionJD(2, fn2) |
      positionJD(3, fn3) |
      positionJD(4, fn4) |
      positionJD(5, fn5) |
      positionJD(6, fn6) |
      positionJD(7, fn7) |
      positionJD(8, fn8) |
      positionJD(9, fn9)
  );
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3,
  function() internal fn4,
  function() internal fn5,
  function() internal fn6,
  function() internal fn7,
  function() internal fn8,
  function() internal fn9,
  function() internal fn10
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) |
      positionJD(1, fn1) |
      positionJD(2, fn2) |
      positionJD(3, fn3) |
      positionJD(4, fn4) |
      positionJD(5, fn5) |
      positionJD(6, fn6) |
      positionJD(7, fn7) |
      positionJD(8, fn8) |
      positionJD(9, fn9) |
      positionJD(10, fn10)
  );
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3,
  function() internal fn4,
  function() internal fn5,
  function() internal fn6,
  function() internal fn7,
  function() internal fn8,
  function() internal fn9,
  function() internal fn10,
  function() internal fn11
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) |
      positionJD(1, fn1) |
      positionJD(2, fn2) |
      positionJD(3, fn3) |
      positionJD(4, fn4) |
      positionJD(5, fn5) |
      positionJD(6, fn6) |
      positionJD(7, fn7) |
      positionJD(8, fn8) |
      positionJD(9, fn9) |
      positionJD(10, fn10) |
      positionJD(11, fn11)
  );
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3,
  function() internal fn4,
  function() internal fn5,
  function() internal fn6,
  function() internal fn7,
  function() internal fn8,
  function() internal fn9,
  function() internal fn10,
  function() internal fn11,
  function() internal fn12
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) |
      positionJD(1, fn1) |
      positionJD(2, fn2) |
      positionJD(3, fn3) |
      positionJD(4, fn4) |
      positionJD(5, fn5) |
      positionJD(6, fn6) |
      positionJD(7, fn7) |
      positionJD(8, fn8) |
      positionJD(9, fn9) |
      positionJD(10, fn10) |
      positionJD(11, fn11) |
      positionJD(12, fn12)
  );
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3,
  function() internal fn4,
  function() internal fn5,
  function() internal fn6,
  function() internal fn7,
  function() internal fn8,
  function() internal fn9,
  function() internal fn10,
  function() internal fn11,
  function() internal fn12,
  function() internal fn13
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) |
      positionJD(1, fn1) |
      positionJD(2, fn2) |
      positionJD(3, fn3) |
      positionJD(4, fn4) |
      positionJD(5, fn5) |
      positionJD(6, fn6) |
      positionJD(7, fn7) |
      positionJD(8, fn8) |
      positionJD(9, fn9) |
      positionJD(10, fn10) |
      positionJD(11, fn11) |
      positionJD(12, fn12) |
      positionJD(13, fn13)
  );
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3,
  function() internal fn4,
  function() internal fn5,
  function() internal fn6,
  function() internal fn7,
  function() internal fn8,
  function() internal fn9,
  function() internal fn10,
  function() internal fn11,
  function() internal fn12,
  function() internal fn13,
  function() internal fn14
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) |
      positionJD(1, fn1) |
      positionJD(2, fn2) |
      positionJD(3, fn3) |
      positionJD(4, fn4) |
      positionJD(5, fn5) |
      positionJD(6, fn6) |
      positionJD(7, fn7) |
      positionJD(8, fn8) |
      positionJD(9, fn9) |
      positionJD(10, fn10) |
      positionJD(11, fn11) |
      positionJD(12, fn12) |
      positionJD(13, fn13) |
      positionJD(14, fn14)
  );
}

function createJumpTable(
  function() internal fn0,
  function() internal fn1,
  function() internal fn2,
  function() internal fn3,
  function() internal fn4,
  function() internal fn5,
  function() internal fn6,
  function() internal fn7,
  function() internal fn8,
  function() internal fn9,
  function() internal fn10,
  function() internal fn11,
  function() internal fn12,
  function() internal fn13,
  function() internal fn14,
  function() internal fn15
) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fn0) |
      positionJD(1, fn1) |
      positionJD(2, fn2) |
      positionJD(3, fn3) |
      positionJD(4, fn4) |
      positionJD(5, fn5) |
      positionJD(6, fn6) |
      positionJD(7, fn7) |
      positionJD(8, fn8) |
      positionJD(9, fn9) |
      positionJD(10, fn10) |
      positionJD(11, fn11) |
      positionJD(12, fn12) |
      positionJD(13, fn13) |
      positionJD(14, fn14) |
      positionJD(15, fn15)
  );
}

/*//////////////////////////////////////////////////////////////
                   Create table from an array
//////////////////////////////////////////////////////////////*/

function createJumpTable(function() internal[2] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(positionJD(0, fns[0]) | positionJD(1, fns[1]));
}

function createJumpTable(function() internal[3] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(positionJD(0, fns[0]) | positionJD(1, fns[1]) | positionJD(2, fns[2]));
}

function createJumpTable(function() internal[4] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) | positionJD(1, fns[1]) | positionJD(2, fns[2]) | positionJD(3, fns[3])
  );
}

function createJumpTable(function() internal[5] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) |
      positionJD(1, fns[1]) |
      positionJD(2, fns[2]) |
      positionJD(3, fns[3]) |
      positionJD(4, fns[4])
  );
}

function createJumpTable(function() internal[6] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) |
      positionJD(1, fns[1]) |
      positionJD(2, fns[2]) |
      positionJD(3, fns[3]) |
      positionJD(4, fns[4]) |
      positionJD(5, fns[5])
  );
}

function createJumpTable(function() internal[7] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) |
      positionJD(1, fns[1]) |
      positionJD(2, fns[2]) |
      positionJD(3, fns[3]) |
      positionJD(4, fns[4]) |
      positionJD(5, fns[5]) |
      positionJD(6, fns[6])
  );
}

function createJumpTable(function() internal[8] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) |
      positionJD(1, fns[1]) |
      positionJD(2, fns[2]) |
      positionJD(3, fns[3]) |
      positionJD(4, fns[4]) |
      positionJD(5, fns[5]) |
      positionJD(6, fns[6]) |
      positionJD(7, fns[7])
  );
}

function createJumpTable(function() internal[9] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) |
      positionJD(1, fns[1]) |
      positionJD(2, fns[2]) |
      positionJD(3, fns[3]) |
      positionJD(4, fns[4]) |
      positionJD(5, fns[5]) |
      positionJD(6, fns[6]) |
      positionJD(7, fns[7]) |
      positionJD(8, fns[8])
  );
}

function createJumpTable(function() internal[10] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) |
      positionJD(1, fns[1]) |
      positionJD(2, fns[2]) |
      positionJD(3, fns[3]) |
      positionJD(4, fns[4]) |
      positionJD(5, fns[5]) |
      positionJD(6, fns[6]) |
      positionJD(7, fns[7]) |
      positionJD(8, fns[8]) |
      positionJD(9, fns[9])
  );
}

function createJumpTable(function() internal[11] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) |
      positionJD(1, fns[1]) |
      positionJD(2, fns[2]) |
      positionJD(3, fns[3]) |
      positionJD(4, fns[4]) |
      positionJD(5, fns[5]) |
      positionJD(6, fns[6]) |
      positionJD(7, fns[7]) |
      positionJD(8, fns[8]) |
      positionJD(9, fns[9]) |
      positionJD(10, fns[10])
  );
}

function createJumpTable(function() internal[12] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) |
      positionJD(1, fns[1]) |
      positionJD(2, fns[2]) |
      positionJD(3, fns[3]) |
      positionJD(4, fns[4]) |
      positionJD(5, fns[5]) |
      positionJD(6, fns[6]) |
      positionJD(7, fns[7]) |
      positionJD(8, fns[8]) |
      positionJD(9, fns[9]) |
      positionJD(10, fns[10]) |
      positionJD(11, fns[11])
  );
}

function createJumpTable(function() internal[13] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) |
      positionJD(1, fns[1]) |
      positionJD(2, fns[2]) |
      positionJD(3, fns[3]) |
      positionJD(4, fns[4]) |
      positionJD(5, fns[5]) |
      positionJD(6, fns[6]) |
      positionJD(7, fns[7]) |
      positionJD(8, fns[8]) |
      positionJD(9, fns[9]) |
      positionJD(10, fns[10]) |
      positionJD(11, fns[11]) |
      positionJD(12, fns[12])
  );
}

function createJumpTable(function() internal[14] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) |
      positionJD(1, fns[1]) |
      positionJD(2, fns[2]) |
      positionJD(3, fns[3]) |
      positionJD(4, fns[4]) |
      positionJD(5, fns[5]) |
      positionJD(6, fns[6]) |
      positionJD(7, fns[7]) |
      positionJD(8, fns[8]) |
      positionJD(9, fns[9]) |
      positionJD(10, fns[10]) |
      positionJD(11, fns[11]) |
      positionJD(12, fns[12]) |
      positionJD(13, fns[13])
  );
}

function createJumpTable(function() internal[15] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) |
      positionJD(1, fns[1]) |
      positionJD(2, fns[2]) |
      positionJD(3, fns[3]) |
      positionJD(4, fns[4]) |
      positionJD(5, fns[5]) |
      positionJD(6, fns[6]) |
      positionJD(7, fns[7]) |
      positionJD(8, fns[8]) |
      positionJD(9, fns[9]) |
      positionJD(10, fns[10]) |
      positionJD(11, fns[11]) |
      positionJD(12, fns[12]) |
      positionJD(13, fns[13]) |
      positionJD(14, fns[14])
  );
}

function createJumpTable(function() internal[16] memory fns) pure returns (JumpTable table) {
  table = toJumpTable(
    positionJD(0, fns[0]) |
      positionJD(1, fns[1]) |
      positionJD(2, fns[2]) |
      positionJD(3, fns[3]) |
      positionJD(4, fns[4]) |
      positionJD(5, fns[5]) |
      positionJD(6, fns[6]) |
      positionJD(7, fns[7]) |
      positionJD(8, fns[8]) |
      positionJD(9, fns[9]) |
      positionJD(10, fns[10]) |
      positionJD(11, fns[11]) |
      positionJD(12, fns[12]) |
      positionJD(13, fns[13]) |
      positionJD(14, fns[14]) |
      positionJD(15, fns[15])
  );
}

/**
 * @dev These functions are separated into a library so that they can work with
 * the "using for" syntax, which does not support overloaded function names or
 * arrays of custom user types at a global level.
 */
library MultiPartJumpTable {
  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[2] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[2] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[3] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[3] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[4] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[4] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[5] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[5] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[6] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[6] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[7] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[7] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[8] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[8] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[9] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[9] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[10] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[10] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[11] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[11] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[12] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[12] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[13] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[13] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[14] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[14] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[15] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[15] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[16] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   */
  function gotoIfExists(JumpTable[16] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      fn := shr(BitsAfterJumpDest, mload(add(table, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table`
   * Note: It is highly recommended that stack inputs or a fixed-size array be used
   * instead, as a dynamic array is significantly more expensive to load into memory.
   * Note: Does not check for out-of-bounds `key` and will result in an exceptional halt
   * (revert consuming all gas) if the value at `key` is not a valid function pointer.
   */
  function goto(JumpTable[] memory table, uint256 key) internal {
    function() internal fn;
    assembly {
      let ptr := add(table, 0x20)
      fn := shr(BitsAfterJumpDest, mload(add(ptr, mul(key, 0x02))))
    }
    fn();
  }

  /**
   * @dev Jump to the function pointer stored at `key` in `table` if one exists
   * Note: It is highly recommended that stack inputs or a fixed-size array be used
   * instead, as a dynamic array is significantly more expensive to load into memory.
   */
  function gotoIfExists(JumpTable[] memory table, uint256 key) internal returns (bool exists) {
    function() internal fn;
    assembly {
      let ptr := add(table, 0x20)
      fn := shr(BitsAfterJumpDest, mload(add(ptr, mul(key, 0x02))))
      exists := gt(fn, 0)
    }
    if (exists) fn();
  }

  /*//////////////////////////////////////////////////////////////
	                    Update a table in memory
	//////////////////////////////////////////////////////////////*/

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[2] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[2] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[3] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[3] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[4] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[4] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[5] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[5] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[6] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[6] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[7] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[7] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[8] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[8] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[9] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[9] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[10] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[10] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[11] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[11] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[12] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[12] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[13] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[13] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[14] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[14] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[15] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[15] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[16] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[16] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(JumpTable[] memory table, uint256 key, function() internal fn) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, add(mul(key, 0x02), 0x20))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstJumpDest)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `fn` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    JumpTable[] memory table,
    uint256 key,
    function() internal fn
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, add(mul(key, 0x02), 0x20))
      // Shift `fn` so that it occupies the first 2 bytes
      let positioned := shl(BitsAfterJumpDest, fn)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }
}

using { goto, gotoIfExists, write, writeUnsafe } for JumpTable global;
