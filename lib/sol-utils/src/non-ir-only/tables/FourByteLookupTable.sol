// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

/*//////////////////////////////////////////////////////////////
                            Constants
//////////////////////////////////////////////////////////////*/

uint256 constant BitsInFourBytes = 0x20;
uint256 constant MaskIncludeFirstFourBytes = (
  0xffffffff00000000000000000000000000000000000000000000000000000000
);
uint256 constant MaskIncludeLastFourBytes = 0xffffffff;
uint256 constant MaskExcludeFirstFourBytes = (
  0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
);
uint256 constant WordMinusFourBytes = 0xe0;

/*//////////////////////////////////////////////////////////////
                        Basic type utils
//////////////////////////////////////////////////////////////*/

type FourByteLookupTable is uint256;

FourByteLookupTable constant EmptyFourByteLookupTable = FourByteLookupTable.wrap(0);

function toFourByteLookupTable(uint256 _table) pure returns (FourByteLookupTable table) {
  assembly {
    table := _table
  }
}

/**
 * @dev Shift `value` to the position occupied by `key` in a sequence
 * of 4 byte values.
 */
function positionLT4(uint256 key, uint256 value) pure returns (uint256 positioned) {
  assembly {
    // Calculate number of bits to the right of position `key`
    let bitsFromRight := sub(WordMinusFourBytes, mul(BitsInFourBytes, key))
    // Apply mask to include only last 4 bytes of `value`
    // then shift it to the position for the `key`.
    positioned := shl(bitsFromRight, and(value, MaskIncludeLastFourBytes))
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
  FourByteLookupTable table,
  uint256 key,
  uint256 value
) pure returns (FourByteLookupTable updatedTable) {
  assembly {
    // Calculate number of bits to the right of position `key`
    let bitsFromRight := sub(WordMinusFourBytes, mul(BitsInFourBytes, key))

    // Apply mask to include only last 4 bytes of `value`,
    // then shift it to the position for the `key`.
    let positioned := shl(bitsFromRight, and(value, MaskIncludeLastFourBytes))

    // Apply mask to remove the existing value for `key`
    let cleaned := not(shl(bitsFromRight, MaskIncludeLastFourBytes))
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
  FourByteLookupTable table,
  uint256 key,
  uint256 value
) pure returns (FourByteLookupTable updatedTable) {
  assembly {
    // Calculate number of bits to the right of position `key`
    let bitsFromRight := sub(WordMinusFourBytes, mul(BitsInFourBytes, key))

    // Apply mask to include only last 4 bytes of `value`,
    // then shift it to the position for the `key`.
    let positioned := shl(bitsFromRight, and(value, MaskIncludeLastFourBytes))

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
function read(FourByteLookupTable table, uint256 key) pure returns (uint256 value) {
  assembly {
    let bitsFromRight := sub(WordMinusFourBytes, mul(BitsInFourBytes, key))
    value := and(shr(bitsFromRight, table), MaskIncludeLastFourBytes)
  }
}

/*//////////////////////////////////////////////////////////////
                 Create table from stack inputs
//////////////////////////////////////////////////////////////*/

function createFourByteLookupTable(uint256 value0) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(positionLT4(0, value0));
}

function createFourByteLookupTable(
  uint256 value0,
  uint256 value1
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(positionLT4(0, value0) | positionLT4(1, value1));
}

function createFourByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(
    positionLT4(0, value0) | positionLT4(1, value1) | positionLT4(2, value2)
  );
}

function createFourByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(
    positionLT4(0, value0) |
      positionLT4(1, value1) |
      positionLT4(2, value2) |
      positionLT4(3, value3)
  );
}

function createFourByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(
    positionLT4(0, value0) |
      positionLT4(1, value1) |
      positionLT4(2, value2) |
      positionLT4(3, value3) |
      positionLT4(4, value4)
  );
}

function createFourByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(
    positionLT4(0, value0) |
      positionLT4(1, value1) |
      positionLT4(2, value2) |
      positionLT4(3, value3) |
      positionLT4(4, value4) |
      positionLT4(5, value5)
  );
}

function createFourByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(
    positionLT4(0, value0) |
      positionLT4(1, value1) |
      positionLT4(2, value2) |
      positionLT4(3, value3) |
      positionLT4(4, value4) |
      positionLT4(5, value5) |
      positionLT4(6, value6)
  );
}

function createFourByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6,
  uint256 value7
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(
    positionLT4(0, value0) |
      positionLT4(1, value1) |
      positionLT4(2, value2) |
      positionLT4(3, value3) |
      positionLT4(4, value4) |
      positionLT4(5, value5) |
      positionLT4(6, value6) |
      positionLT4(7, value7)
  );
}

/*//////////////////////////////////////////////////////////////
                   Create table from an array
//////////////////////////////////////////////////////////////*/

function createFourByteLookupTable(
  uint256[2] memory values
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(positionLT4(0, values[0]) | positionLT4(1, values[1]));
}

function createFourByteLookupTable(
  uint256[3] memory values
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(
    positionLT4(0, values[0]) | positionLT4(1, values[1]) | positionLT4(2, values[2])
  );
}

function createFourByteLookupTable(
  uint256[4] memory values
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(
    positionLT4(0, values[0]) |
      positionLT4(1, values[1]) |
      positionLT4(2, values[2]) |
      positionLT4(3, values[3])
  );
}

function createFourByteLookupTable(
  uint256[5] memory values
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(
    positionLT4(0, values[0]) |
      positionLT4(1, values[1]) |
      positionLT4(2, values[2]) |
      positionLT4(3, values[3]) |
      positionLT4(4, values[4])
  );
}

function createFourByteLookupTable(
  uint256[6] memory values
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(
    positionLT4(0, values[0]) |
      positionLT4(1, values[1]) |
      positionLT4(2, values[2]) |
      positionLT4(3, values[3]) |
      positionLT4(4, values[4]) |
      positionLT4(5, values[5])
  );
}

function createFourByteLookupTable(
  uint256[7] memory values
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(
    positionLT4(0, values[0]) |
      positionLT4(1, values[1]) |
      positionLT4(2, values[2]) |
      positionLT4(3, values[3]) |
      positionLT4(4, values[4]) |
      positionLT4(5, values[5]) |
      positionLT4(6, values[6])
  );
}

function createFourByteLookupTable(
  uint256[8] memory values
) pure returns (FourByteLookupTable table) {
  table = toFourByteLookupTable(
    positionLT4(0, values[0]) |
      positionLT4(1, values[1]) |
      positionLT4(2, values[2]) |
      positionLT4(3, values[3]) |
      positionLT4(4, values[4]) |
      positionLT4(5, values[5]) |
      positionLT4(6, values[6]) |
      positionLT4(7, values[7])
  );
}

/**
 * @dev These functions are separated into a library so that they can work with
 * the "using for" syntax, which does not support overloaded function names or
 * arrays of custom user types at a global level.
 */
library MultiPartFourByteLookupTable {
  /**
   * @dev Performs lookup on a table with 2 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[2] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 3 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[3] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 4 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[4] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 5 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[5] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 6 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[6] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 7 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[7] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 8 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[8] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 9 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[9] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 10 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[10] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 11 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[11] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 12 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[12] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 13 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[13] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 14 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[14] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 15 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[15] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 16 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[16] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 17 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[17] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 18 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[18] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 19 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[19] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 20 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[20] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 21 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[21] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 22 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[22] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 23 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[23] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 24 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[24] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 25 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[25] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 26 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[26] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 27 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[27] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 28 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[28] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 29 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[29] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 30 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[30] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 31 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[31] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a table with 32 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[32] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusFourBytes, mload(add(table, mul(key, 0x04))))
    }
  }

  /**
   * @dev Performs lookup on a dynamically sized table
   * Note: It is highly recommended that stack inputs or a fixed-size array be used
   * instead, as a dynamic array is significantly more expensive to load into memory
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    FourByteLookupTable[] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      let ptr := add(table, 0x20)
      value := shr(WordMinusFourBytes, mload(add(ptr, mul(key, 0x04))))
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
  function write(FourByteLookupTable[2] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[2] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[3] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[3] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[4] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[4] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[5] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[5] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[6] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[6] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[7] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[7] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[8] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[8] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[9] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[9] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[10] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[10] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[11] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[11] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[12] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[12] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[13] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[13] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[14] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[14] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[15] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[15] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[16] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[16] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[17] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[17] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[18] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[18] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[19] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[19] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[20] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[20] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[21] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[21] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[22] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[22] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[23] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[23] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[24] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[24] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[25] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[25] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[26] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[26] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[27] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[27] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[28] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[28] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[29] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[29] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[30] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[30] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[31] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[31] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[32] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[32] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, mul(key, 0x04))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
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
  function write(FourByteLookupTable[] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, add(mul(key, 0x04), 0x20))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstFourBytes)
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
    FourByteLookupTable[] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, add(mul(key, 0x04), 0x20))
      // Shift `value` so that it occupies the first 4 bytes
      let positioned := shl(WordMinusFourBytes, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }
}

using { read, write, writeUnsafe } for FourByteLookupTable global;
