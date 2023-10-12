// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

/*//////////////////////////////////////////////////////////////
                            Constants
//////////////////////////////////////////////////////////////*/

uint256 constant BitsInTwoBytes = 0x10;
uint256 constant MaskIncludeFirstTwoBytes = (
  0xffff000000000000000000000000000000000000000000000000000000000000
);
uint256 constant MaskIncludeLastTwoBytes = 0xffff;
uint256 constant MaskExcludeFirstTwoBytes = (
  0x0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
);
uint256 constant WordMinusTwoBytes = 0xf0;

/*//////////////////////////////////////////////////////////////
                        Basic type utils
//////////////////////////////////////////////////////////////*/

type TwoByteLookupTable is uint256;

TwoByteLookupTable constant EmptyTwoByteLookupTable = TwoByteLookupTable.wrap(0);

function toTwoByteLookupTable(uint256 _table) pure returns (TwoByteLookupTable table) {
  assembly {
    table := _table
  }
}

/**
 * @dev Shift `value` to the position occupied by `key` in a sequence
 * of 2 byte values.
 */
function positionLT2(uint256 key, uint256 value) pure returns (uint256 positioned) {
  assembly {
    // Calculate number of bits to the right of position `key`
    let bitsFromRight := sub(WordMinusTwoBytes, mul(BitsInTwoBytes, key))
    // Apply mask to include only last 2 bytes of `value`
    // then shift it to the position for the `key`.
    positioned := shl(bitsFromRight, and(value, MaskIncludeLastTwoBytes))
  }
}

/*//////////////////////////////////////////////////////////////
                   Write to table on the stack
//////////////////////////////////////////////////////////////*/

/**
 *
 * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
 *
 * Note: Does not check for out-of-bounds `key`
 *
 */
function write(
  TwoByteLookupTable table,
  uint256 key,
  uint256 value
) pure returns (TwoByteLookupTable updatedTable) {
  assembly {
    // Calculate number of bits to the right of position `key`
    let bitsFromRight := sub(WordMinusTwoBytes, mul(BitsInTwoBytes, key))

    // Apply mask to include only last 2 bytes of `value`,
    // then shift it to the position for the `key`.
    let positioned := shl(bitsFromRight, and(value, MaskIncludeLastTwoBytes))

    // Apply mask to remove the existing value for `key`
    let cleaned := not(shl(bitsFromRight, MaskIncludeLastTwoBytes))
    // Update table with new value and return the result
    updatedTable := or(and(table, cleaned), positioned)
  }
}

/**
 *
 * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
 *  The result will be the inclusive OR of the old and new values.
 * Note: Does not check for out-of-bounds `key`
 *
 */
function writeUnsafe(
  TwoByteLookupTable table,
  uint256 key,
  uint256 value
) pure returns (TwoByteLookupTable updatedTable) {
  assembly {
    // Calculate number of bits to the right of position `key`
    let bitsFromRight := sub(WordMinusTwoBytes, mul(BitsInTwoBytes, key))

    // Apply mask to include only last 2 bytes of `value`,
    // then shift it to the position for the `key`.
    let positioned := shl(bitsFromRight, and(value, MaskIncludeLastTwoBytes))

    // Update table with new value and return the result
    updatedTable := or(table, positioned)
  }
}

/*//////////////////////////////////////////////////////////////
                  Read from table on the stack
//////////////////////////////////////////////////////////////*/

/**
 * @dev Performs lookup on a table with 1 segments.
 * Note: Does not check for out-of-bounds `key`
 */
function read(TwoByteLookupTable table, uint256 key) pure returns (uint256 value) {
  assembly {
    let bitsFromRight := sub(WordMinusTwoBytes, mul(BitsInTwoBytes, key))
    value := and(shr(bitsFromRight, table), MaskIncludeLastTwoBytes)
  }
}

/*//////////////////////////////////////////////////////////////
                 Create table from stack inputs
//////////////////////////////////////////////////////////////*/

function createTwoByteLookupTable(uint256 value0) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(positionLT2(0, value0));
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(positionLT2(0, value0) | positionLT2(1, value1));
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) | positionLT2(1, value1) | positionLT2(2, value2)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3) |
      positionLT2(4, value4)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3) |
      positionLT2(4, value4) |
      positionLT2(5, value5)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3) |
      positionLT2(4, value4) |
      positionLT2(5, value5) |
      positionLT2(6, value6)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6,
  uint256 value7
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3) |
      positionLT2(4, value4) |
      positionLT2(5, value5) |
      positionLT2(6, value6) |
      positionLT2(7, value7)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6,
  uint256 value7,
  uint256 value8
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3) |
      positionLT2(4, value4) |
      positionLT2(5, value5) |
      positionLT2(6, value6) |
      positionLT2(7, value7) |
      positionLT2(8, value8)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6,
  uint256 value7,
  uint256 value8,
  uint256 value9
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3) |
      positionLT2(4, value4) |
      positionLT2(5, value5) |
      positionLT2(6, value6) |
      positionLT2(7, value7) |
      positionLT2(8, value8) |
      positionLT2(9, value9)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6,
  uint256 value7,
  uint256 value8,
  uint256 value9,
  uint256 value10
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3) |
      positionLT2(4, value4) |
      positionLT2(5, value5) |
      positionLT2(6, value6) |
      positionLT2(7, value7) |
      positionLT2(8, value8) |
      positionLT2(9, value9) |
      positionLT2(10, value10)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6,
  uint256 value7,
  uint256 value8,
  uint256 value9,
  uint256 value10,
  uint256 value11
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3) |
      positionLT2(4, value4) |
      positionLT2(5, value5) |
      positionLT2(6, value6) |
      positionLT2(7, value7) |
      positionLT2(8, value8) |
      positionLT2(9, value9) |
      positionLT2(10, value10) |
      positionLT2(11, value11)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6,
  uint256 value7,
  uint256 value8,
  uint256 value9,
  uint256 value10,
  uint256 value11,
  uint256 value12
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3) |
      positionLT2(4, value4) |
      positionLT2(5, value5) |
      positionLT2(6, value6) |
      positionLT2(7, value7) |
      positionLT2(8, value8) |
      positionLT2(9, value9) |
      positionLT2(10, value10) |
      positionLT2(11, value11) |
      positionLT2(12, value12)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6,
  uint256 value7,
  uint256 value8,
  uint256 value9,
  uint256 value10,
  uint256 value11,
  uint256 value12,
  uint256 value13
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3) |
      positionLT2(4, value4) |
      positionLT2(5, value5) |
      positionLT2(6, value6) |
      positionLT2(7, value7) |
      positionLT2(8, value8) |
      positionLT2(9, value9) |
      positionLT2(10, value10) |
      positionLT2(11, value11) |
      positionLT2(12, value12) |
      positionLT2(13, value13)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6,
  uint256 value7,
  uint256 value8,
  uint256 value9,
  uint256 value10,
  uint256 value11,
  uint256 value12,
  uint256 value13,
  uint256 value14
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3) |
      positionLT2(4, value4) |
      positionLT2(5, value5) |
      positionLT2(6, value6) |
      positionLT2(7, value7) |
      positionLT2(8, value8) |
      positionLT2(9, value9) |
      positionLT2(10, value10) |
      positionLT2(11, value11) |
      positionLT2(12, value12) |
      positionLT2(13, value13) |
      positionLT2(14, value14)
  );
}

function createTwoByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6,
  uint256 value7,
  uint256 value8,
  uint256 value9,
  uint256 value10,
  uint256 value11,
  uint256 value12,
  uint256 value13,
  uint256 value14,
  uint256 value15
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, value0) |
      positionLT2(1, value1) |
      positionLT2(2, value2) |
      positionLT2(3, value3) |
      positionLT2(4, value4) |
      positionLT2(5, value5) |
      positionLT2(6, value6) |
      positionLT2(7, value7) |
      positionLT2(8, value8) |
      positionLT2(9, value9) |
      positionLT2(10, value10) |
      positionLT2(11, value11) |
      positionLT2(12, value12) |
      positionLT2(13, value13) |
      positionLT2(14, value14) |
      positionLT2(15, value15)
  );
}

/*//////////////////////////////////////////////////////////////
                   Create table from an array
//////////////////////////////////////////////////////////////*/

function createTwoByteLookupTable(
  uint256[2] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(positionLT2(0, values[0]) | positionLT2(1, values[1]));
}

function createTwoByteLookupTable(
  uint256[3] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) | positionLT2(1, values[1]) | positionLT2(2, values[2])
  );
}

function createTwoByteLookupTable(
  uint256[4] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3])
  );
}

function createTwoByteLookupTable(
  uint256[5] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3]) |
      positionLT2(4, values[4])
  );
}

function createTwoByteLookupTable(
  uint256[6] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3]) |
      positionLT2(4, values[4]) |
      positionLT2(5, values[5])
  );
}

function createTwoByteLookupTable(
  uint256[7] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3]) |
      positionLT2(4, values[4]) |
      positionLT2(5, values[5]) |
      positionLT2(6, values[6])
  );
}

function createTwoByteLookupTable(
  uint256[8] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3]) |
      positionLT2(4, values[4]) |
      positionLT2(5, values[5]) |
      positionLT2(6, values[6]) |
      positionLT2(7, values[7])
  );
}

function createTwoByteLookupTable(
  uint256[9] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3]) |
      positionLT2(4, values[4]) |
      positionLT2(5, values[5]) |
      positionLT2(6, values[6]) |
      positionLT2(7, values[7]) |
      positionLT2(8, values[8])
  );
}

function createTwoByteLookupTable(
  uint256[10] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3]) |
      positionLT2(4, values[4]) |
      positionLT2(5, values[5]) |
      positionLT2(6, values[6]) |
      positionLT2(7, values[7]) |
      positionLT2(8, values[8]) |
      positionLT2(9, values[9])
  );
}

function createTwoByteLookupTable(
  uint256[11] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3]) |
      positionLT2(4, values[4]) |
      positionLT2(5, values[5]) |
      positionLT2(6, values[6]) |
      positionLT2(7, values[7]) |
      positionLT2(8, values[8]) |
      positionLT2(9, values[9]) |
      positionLT2(10, values[10])
  );
}

function createTwoByteLookupTable(
  uint256[12] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3]) |
      positionLT2(4, values[4]) |
      positionLT2(5, values[5]) |
      positionLT2(6, values[6]) |
      positionLT2(7, values[7]) |
      positionLT2(8, values[8]) |
      positionLT2(9, values[9]) |
      positionLT2(10, values[10]) |
      positionLT2(11, values[11])
  );
}

function createTwoByteLookupTable(
  uint256[13] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3]) |
      positionLT2(4, values[4]) |
      positionLT2(5, values[5]) |
      positionLT2(6, values[6]) |
      positionLT2(7, values[7]) |
      positionLT2(8, values[8]) |
      positionLT2(9, values[9]) |
      positionLT2(10, values[10]) |
      positionLT2(11, values[11]) |
      positionLT2(12, values[12])
  );
}

function createTwoByteLookupTable(
  uint256[14] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3]) |
      positionLT2(4, values[4]) |
      positionLT2(5, values[5]) |
      positionLT2(6, values[6]) |
      positionLT2(7, values[7]) |
      positionLT2(8, values[8]) |
      positionLT2(9, values[9]) |
      positionLT2(10, values[10]) |
      positionLT2(11, values[11]) |
      positionLT2(12, values[12]) |
      positionLT2(13, values[13])
  );
}

function createTwoByteLookupTable(
  uint256[15] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3]) |
      positionLT2(4, values[4]) |
      positionLT2(5, values[5]) |
      positionLT2(6, values[6]) |
      positionLT2(7, values[7]) |
      positionLT2(8, values[8]) |
      positionLT2(9, values[9]) |
      positionLT2(10, values[10]) |
      positionLT2(11, values[11]) |
      positionLT2(12, values[12]) |
      positionLT2(13, values[13]) |
      positionLT2(14, values[14])
  );
}

function createTwoByteLookupTable(
  uint256[16] memory values
) pure returns (TwoByteLookupTable table) {
  table = toTwoByteLookupTable(
    positionLT2(0, values[0]) |
      positionLT2(1, values[1]) |
      positionLT2(2, values[2]) |
      positionLT2(3, values[3]) |
      positionLT2(4, values[4]) |
      positionLT2(5, values[5]) |
      positionLT2(6, values[6]) |
      positionLT2(7, values[7]) |
      positionLT2(8, values[8]) |
      positionLT2(9, values[9]) |
      positionLT2(10, values[10]) |
      positionLT2(11, values[11]) |
      positionLT2(12, values[12]) |
      positionLT2(13, values[13]) |
      positionLT2(14, values[14]) |
      positionLT2(15, values[15])
  );
}

/**
 * @dev These functions are separated into a library so that they can work with
 * the "using for" syntax, which does not support overloaded function names or
 * arrays of custom user types at a global level.
 */
library MultiPartTwoByteLookupTable {
  /**
   * @dev Performs lookup on a table with 2 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[2] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 3 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[3] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 4 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[4] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 5 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[5] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 6 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[6] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 7 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[7] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 8 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[8] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 9 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[9] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 10 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[10] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 11 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[11] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 12 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[12] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 13 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[13] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 14 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[14] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 15 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[15] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a table with 16 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[16] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusTwoBytes, mload(add(table, mul(key, 0x02))))
    }
  }

  /**
   * @dev Performs lookup on a dynamically sized table
   * Note: It is highly recommended that stack inputs or a fixed-size array be used
   * instead, as a dynamic array is significantly more expensive to load into memory
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    TwoByteLookupTable[] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      let ptr := add(table, 0x20)
      value := shr(WordMinusTwoBytes, mload(add(ptr, mul(key, 0x02))))
    }
  }

  /*//////////////////////////////////////////////////////////////
	                    Update a table in memory
	//////////////////////////////////////////////////////////////*/

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[2] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[2] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[3] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[3] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[4] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[4] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[5] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[5] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[6] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[6] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[7] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[7] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[8] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[8] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[9] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[9] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[10] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[10] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[11] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[11] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[12] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[12] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[13] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[13] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[14] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[14] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[15] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[15] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[16] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[16] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x02))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, overwriting any existing value there.
   *
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function write(TwoByteLookupTable[] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, add(mul(key, 0x02), 0x20))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstTwoBytes)
      // Update memory with new value
      mstore(ptr, or(cleaned, positioned))
    }
  }

  /**
   *
   * @dev Write `value` to position `key` in `table`, without overwriting any existing value there.
   *  The result will be the inclusive OR of the old and new values.
   * Note: Does not check for out-of-bounds `key`
   *
   */
  function writeUnsafe(
    TwoByteLookupTable[] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, add(mul(key, 0x02), 0x20))
      // Shift `value` so that it occupies the first 2 bytes
      let positioned := shl(WordMinusTwoBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }
}

using { read, write, writeUnsafe } for TwoByteLookupTable global;
