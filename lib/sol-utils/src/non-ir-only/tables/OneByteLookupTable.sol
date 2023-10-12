// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

/*//////////////////////////////////////////////////////////////
                            Constants
//////////////////////////////////////////////////////////////*/

uint256 constant BitsInByte = 0x08;
uint256 constant MaskIncludeFirstByte = (
  0xff00000000000000000000000000000000000000000000000000000000000000
);
uint256 constant MaskIncludeLastByte = 0xff;
uint256 constant MaskExcludeFirstByte = (
  0x00ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
);
uint256 constant WordMinusByte = 0xf8;

/*//////////////////////////////////////////////////////////////
                        Basic type utils
//////////////////////////////////////////////////////////////*/

type OneByteLookupTable is uint256;

OneByteLookupTable constant EmptyOneByteLookupTable = OneByteLookupTable.wrap(0);

function toOneByteLookupTable(uint256 _table) pure returns (OneByteLookupTable table) {
  assembly {
    table := _table
  }
}

/**
 * @dev Shift `value` to the position occupied by `key` in a sequence
 * of 1 byte values.
 */
function positionLT1(uint256 key, uint256 value) pure returns (uint256 positioned) {
  assembly {
    // Calculate number of bits to the right of position `key`
    let bitsFromRight := sub(WordMinusByte, mul(BitsInByte, key))
    // Apply mask to include only last 1 bytes of `value`
    // then shift it to the position for the `key`.
    positioned := shl(bitsFromRight, and(value, MaskIncludeLastByte))
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
  OneByteLookupTable table,
  uint256 key,
  uint256 value
) pure returns (OneByteLookupTable updatedTable) {
  assembly {
    // Calculate number of bits to the right of position `key`
    let bitsFromRight := sub(WordMinusByte, mul(BitsInByte, key))

    // Apply mask to include only last byte of `value`,
    // then shift it to the position for the `key`.
    let positioned := shl(bitsFromRight, and(value, MaskIncludeLastByte))

    // Apply mask to remove the existing value for `key`
    let cleaned := not(shl(bitsFromRight, MaskIncludeLastByte))
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
  OneByteLookupTable table,
  uint256 key,
  uint256 value
) pure returns (OneByteLookupTable updatedTable) {
  assembly {
    // Calculate number of bits to the right of position `key`
    let bitsFromRight := sub(WordMinusByte, mul(BitsInByte, key))

    // Apply mask to include only last byte of `value`,
    // then shift it to the position for the `key`.
    let positioned := shl(bitsFromRight, and(value, MaskIncludeLastByte))

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
function read(OneByteLookupTable table, uint256 key) pure returns (uint256 value) {
  assembly {
    let bitsFromRight := sub(WordMinusByte, mul(BitsInByte, key))
    value := and(shr(bitsFromRight, table), MaskIncludeLastByte)
  }
}

/*//////////////////////////////////////////////////////////////
                 Create table from stack inputs
//////////////////////////////////////////////////////////////*/

function createOneByteLookupTable(uint256 value0) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(positionLT1(0, value0));
}

function createOneByteLookupTable(
  uint256 value0,
  uint256 value1
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(positionLT1(0, value0) | positionLT1(1, value1));
}

function createOneByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) | positionLT1(1, value1) | positionLT1(2, value2)
  );
}

function createOneByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3)
  );
}

function createOneByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4)
  );
}

function createOneByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5)
  );
}

function createOneByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6)
  );
}

function createOneByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6,
  uint256 value7
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7)
  );
}

function createOneByteLookupTable(
  uint256 value0,
  uint256 value1,
  uint256 value2,
  uint256 value3,
  uint256 value4,
  uint256 value5,
  uint256 value6,
  uint256 value7,
  uint256 value8
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8)
  );
}

function createOneByteLookupTable(
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
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9)
  );
}

function createOneByteLookupTable(
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
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10)
  );
}

function createOneByteLookupTable(
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
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11)
  );
}

function createOneByteLookupTable(
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
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12)
  );
}

function createOneByteLookupTable(
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
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13)
  );
}

function createOneByteLookupTable(
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
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14)
  );
}

function createOneByteLookupTable(
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
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19,
  uint256 value20
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19) |
      positionLT1(20, value20)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19,
  uint256 value20,
  uint256 value21
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19) |
      positionLT1(20, value20) |
      positionLT1(21, value21)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19,
  uint256 value20,
  uint256 value21,
  uint256 value22
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19) |
      positionLT1(20, value20) |
      positionLT1(21, value21) |
      positionLT1(22, value22)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19,
  uint256 value20,
  uint256 value21,
  uint256 value22,
  uint256 value23
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19) |
      positionLT1(20, value20) |
      positionLT1(21, value21) |
      positionLT1(22, value22) |
      positionLT1(23, value23)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19,
  uint256 value20,
  uint256 value21,
  uint256 value22,
  uint256 value23,
  uint256 value24
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19) |
      positionLT1(20, value20) |
      positionLT1(21, value21) |
      positionLT1(22, value22) |
      positionLT1(23, value23) |
      positionLT1(24, value24)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19,
  uint256 value20,
  uint256 value21,
  uint256 value22,
  uint256 value23,
  uint256 value24,
  uint256 value25
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19) |
      positionLT1(20, value20) |
      positionLT1(21, value21) |
      positionLT1(22, value22) |
      positionLT1(23, value23) |
      positionLT1(24, value24) |
      positionLT1(25, value25)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19,
  uint256 value20,
  uint256 value21,
  uint256 value22,
  uint256 value23,
  uint256 value24,
  uint256 value25,
  uint256 value26
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19) |
      positionLT1(20, value20) |
      positionLT1(21, value21) |
      positionLT1(22, value22) |
      positionLT1(23, value23) |
      positionLT1(24, value24) |
      positionLT1(25, value25) |
      positionLT1(26, value26)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19,
  uint256 value20,
  uint256 value21,
  uint256 value22,
  uint256 value23,
  uint256 value24,
  uint256 value25,
  uint256 value26,
  uint256 value27
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19) |
      positionLT1(20, value20) |
      positionLT1(21, value21) |
      positionLT1(22, value22) |
      positionLT1(23, value23) |
      positionLT1(24, value24) |
      positionLT1(25, value25) |
      positionLT1(26, value26) |
      positionLT1(27, value27)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19,
  uint256 value20,
  uint256 value21,
  uint256 value22,
  uint256 value23,
  uint256 value24,
  uint256 value25,
  uint256 value26,
  uint256 value27,
  uint256 value28
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19) |
      positionLT1(20, value20) |
      positionLT1(21, value21) |
      positionLT1(22, value22) |
      positionLT1(23, value23) |
      positionLT1(24, value24) |
      positionLT1(25, value25) |
      positionLT1(26, value26) |
      positionLT1(27, value27) |
      positionLT1(28, value28)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19,
  uint256 value20,
  uint256 value21,
  uint256 value22,
  uint256 value23,
  uint256 value24,
  uint256 value25,
  uint256 value26,
  uint256 value27,
  uint256 value28,
  uint256 value29
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19) |
      positionLT1(20, value20) |
      positionLT1(21, value21) |
      positionLT1(22, value22) |
      positionLT1(23, value23) |
      positionLT1(24, value24) |
      positionLT1(25, value25) |
      positionLT1(26, value26) |
      positionLT1(27, value27) |
      positionLT1(28, value28) |
      positionLT1(29, value29)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19,
  uint256 value20,
  uint256 value21,
  uint256 value22,
  uint256 value23,
  uint256 value24,
  uint256 value25,
  uint256 value26,
  uint256 value27,
  uint256 value28,
  uint256 value29,
  uint256 value30
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19) |
      positionLT1(20, value20) |
      positionLT1(21, value21) |
      positionLT1(22, value22) |
      positionLT1(23, value23) |
      positionLT1(24, value24) |
      positionLT1(25, value25) |
      positionLT1(26, value26) |
      positionLT1(27, value27) |
      positionLT1(28, value28) |
      positionLT1(29, value29) |
      positionLT1(30, value30)
  );
}

function createOneByteLookupTable(
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
  uint256 value15,
  uint256 value16,
  uint256 value17,
  uint256 value18,
  uint256 value19,
  uint256 value20,
  uint256 value21,
  uint256 value22,
  uint256 value23,
  uint256 value24,
  uint256 value25,
  uint256 value26,
  uint256 value27,
  uint256 value28,
  uint256 value29,
  uint256 value30,
  uint256 value31
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, value0) |
      positionLT1(1, value1) |
      positionLT1(2, value2) |
      positionLT1(3, value3) |
      positionLT1(4, value4) |
      positionLT1(5, value5) |
      positionLT1(6, value6) |
      positionLT1(7, value7) |
      positionLT1(8, value8) |
      positionLT1(9, value9) |
      positionLT1(10, value10) |
      positionLT1(11, value11) |
      positionLT1(12, value12) |
      positionLT1(13, value13) |
      positionLT1(14, value14) |
      positionLT1(15, value15) |
      positionLT1(16, value16) |
      positionLT1(17, value17) |
      positionLT1(18, value18) |
      positionLT1(19, value19) |
      positionLT1(20, value20) |
      positionLT1(21, value21) |
      positionLT1(22, value22) |
      positionLT1(23, value23) |
      positionLT1(24, value24) |
      positionLT1(25, value25) |
      positionLT1(26, value26) |
      positionLT1(27, value27) |
      positionLT1(28, value28) |
      positionLT1(29, value29) |
      positionLT1(30, value30) |
      positionLT1(31, value31)
  );
}

/*//////////////////////////////////////////////////////////////
                   Create table from an array
//////////////////////////////////////////////////////////////*/

function createOneByteLookupTable(
  uint256[2] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(positionLT1(0, values[0]) | positionLT1(1, values[1]));
}

function createOneByteLookupTable(
  uint256[3] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) | positionLT1(1, values[1]) | positionLT1(2, values[2])
  );
}

function createOneByteLookupTable(
  uint256[4] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3])
  );
}

function createOneByteLookupTable(
  uint256[5] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4])
  );
}

function createOneByteLookupTable(
  uint256[6] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5])
  );
}

function createOneByteLookupTable(
  uint256[7] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6])
  );
}

function createOneByteLookupTable(
  uint256[8] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7])
  );
}

function createOneByteLookupTable(
  uint256[9] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8])
  );
}

function createOneByteLookupTable(
  uint256[10] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9])
  );
}

function createOneByteLookupTable(
  uint256[11] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10])
  );
}

function createOneByteLookupTable(
  uint256[12] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11])
  );
}

function createOneByteLookupTable(
  uint256[13] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12])
  );
}

function createOneByteLookupTable(
  uint256[14] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13])
  );
}

function createOneByteLookupTable(
  uint256[15] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14])
  );
}

function createOneByteLookupTable(
  uint256[16] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15])
  );
}

function createOneByteLookupTable(
  uint256[17] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16])
  );
}

function createOneByteLookupTable(
  uint256[18] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17])
  );
}

function createOneByteLookupTable(
  uint256[19] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18])
  );
}

function createOneByteLookupTable(
  uint256[20] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19])
  );
}

function createOneByteLookupTable(
  uint256[21] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19]) |
      positionLT1(20, values[20])
  );
}

function createOneByteLookupTable(
  uint256[22] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19]) |
      positionLT1(20, values[20]) |
      positionLT1(21, values[21])
  );
}

function createOneByteLookupTable(
  uint256[23] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19]) |
      positionLT1(20, values[20]) |
      positionLT1(21, values[21]) |
      positionLT1(22, values[22])
  );
}

function createOneByteLookupTable(
  uint256[24] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19]) |
      positionLT1(20, values[20]) |
      positionLT1(21, values[21]) |
      positionLT1(22, values[22]) |
      positionLT1(23, values[23])
  );
}

function createOneByteLookupTable(
  uint256[25] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19]) |
      positionLT1(20, values[20]) |
      positionLT1(21, values[21]) |
      positionLT1(22, values[22]) |
      positionLT1(23, values[23]) |
      positionLT1(24, values[24])
  );
}

function createOneByteLookupTable(
  uint256[26] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19]) |
      positionLT1(20, values[20]) |
      positionLT1(21, values[21]) |
      positionLT1(22, values[22]) |
      positionLT1(23, values[23]) |
      positionLT1(24, values[24]) |
      positionLT1(25, values[25])
  );
}

function createOneByteLookupTable(
  uint256[27] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19]) |
      positionLT1(20, values[20]) |
      positionLT1(21, values[21]) |
      positionLT1(22, values[22]) |
      positionLT1(23, values[23]) |
      positionLT1(24, values[24]) |
      positionLT1(25, values[25]) |
      positionLT1(26, values[26])
  );
}

function createOneByteLookupTable(
  uint256[28] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19]) |
      positionLT1(20, values[20]) |
      positionLT1(21, values[21]) |
      positionLT1(22, values[22]) |
      positionLT1(23, values[23]) |
      positionLT1(24, values[24]) |
      positionLT1(25, values[25]) |
      positionLT1(26, values[26]) |
      positionLT1(27, values[27])
  );
}

function createOneByteLookupTable(
  uint256[29] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19]) |
      positionLT1(20, values[20]) |
      positionLT1(21, values[21]) |
      positionLT1(22, values[22]) |
      positionLT1(23, values[23]) |
      positionLT1(24, values[24]) |
      positionLT1(25, values[25]) |
      positionLT1(26, values[26]) |
      positionLT1(27, values[27]) |
      positionLT1(28, values[28])
  );
}

function createOneByteLookupTable(
  uint256[30] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19]) |
      positionLT1(20, values[20]) |
      positionLT1(21, values[21]) |
      positionLT1(22, values[22]) |
      positionLT1(23, values[23]) |
      positionLT1(24, values[24]) |
      positionLT1(25, values[25]) |
      positionLT1(26, values[26]) |
      positionLT1(27, values[27]) |
      positionLT1(28, values[28]) |
      positionLT1(29, values[29])
  );
}

function createOneByteLookupTable(
  uint256[31] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19]) |
      positionLT1(20, values[20]) |
      positionLT1(21, values[21]) |
      positionLT1(22, values[22]) |
      positionLT1(23, values[23]) |
      positionLT1(24, values[24]) |
      positionLT1(25, values[25]) |
      positionLT1(26, values[26]) |
      positionLT1(27, values[27]) |
      positionLT1(28, values[28]) |
      positionLT1(29, values[29]) |
      positionLT1(30, values[30])
  );
}

function createOneByteLookupTable(
  uint256[32] memory values
) pure returns (OneByteLookupTable table) {
  table = toOneByteLookupTable(
    positionLT1(0, values[0]) |
      positionLT1(1, values[1]) |
      positionLT1(2, values[2]) |
      positionLT1(3, values[3]) |
      positionLT1(4, values[4]) |
      positionLT1(5, values[5]) |
      positionLT1(6, values[6]) |
      positionLT1(7, values[7]) |
      positionLT1(8, values[8]) |
      positionLT1(9, values[9]) |
      positionLT1(10, values[10]) |
      positionLT1(11, values[11]) |
      positionLT1(12, values[12]) |
      positionLT1(13, values[13]) |
      positionLT1(14, values[14]) |
      positionLT1(15, values[15]) |
      positionLT1(16, values[16]) |
      positionLT1(17, values[17]) |
      positionLT1(18, values[18]) |
      positionLT1(19, values[19]) |
      positionLT1(20, values[20]) |
      positionLT1(21, values[21]) |
      positionLT1(22, values[22]) |
      positionLT1(23, values[23]) |
      positionLT1(24, values[24]) |
      positionLT1(25, values[25]) |
      positionLT1(26, values[26]) |
      positionLT1(27, values[27]) |
      positionLT1(28, values[28]) |
      positionLT1(29, values[29]) |
      positionLT1(30, values[30]) |
      positionLT1(31, values[31])
  );
}

/**
 * @dev These functions are separated into a library so that they can work with
 * the "using for" syntax, which does not support overloaded function names or
 * arrays of custom user types at a global level.
 */
library MultiPartOneByteLookupTable {
  /**
   * @dev Performs lookup on a table with 2 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    OneByteLookupTable[2] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusByte, mload(add(table, key)))
    }
  }

  /**
   * @dev Performs lookup on a table with 3 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    OneByteLookupTable[3] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusByte, mload(add(table, key)))
    }
  }

  /**
   * @dev Performs lookup on a table with 4 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    OneByteLookupTable[4] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusByte, mload(add(table, key)))
    }
  }

  /**
   * @dev Performs lookup on a table with 5 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    OneByteLookupTable[5] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusByte, mload(add(table, key)))
    }
  }

  /**
   * @dev Performs lookup on a table with 6 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    OneByteLookupTable[6] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusByte, mload(add(table, key)))
    }
  }

  /**
   * @dev Performs lookup on a table with 7 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    OneByteLookupTable[7] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusByte, mload(add(table, key)))
    }
  }

  /**
   * @dev Performs lookup on a table with 8 segments.
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    OneByteLookupTable[8] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      value := shr(WordMinusByte, mload(add(table, key)))
    }
  }

  /**
   * @dev Performs lookup on a dynamically sized table
   * Note: It is highly recommended that stack inputs or a fixed-size array be used
   * instead, as a dynamic array is significantly more expensive to load into memory
   * Note: Does not check for out-of-bounds `key`
   */
  function read(
    OneByteLookupTable[] memory table,
    uint256 key
  ) internal pure returns (uint256 value) {
    assembly {
      let ptr := add(table, 0x20)
      value := shr(WordMinusByte, mload(add(ptr, key)))
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
  function write(OneByteLookupTable[2] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstByte)
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
    OneByteLookupTable[2] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
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
  function write(OneByteLookupTable[3] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstByte)
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
    OneByteLookupTable[3] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
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
  function write(OneByteLookupTable[4] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstByte)
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
    OneByteLookupTable[4] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
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
  function write(OneByteLookupTable[5] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstByte)
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
    OneByteLookupTable[5] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
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
  function write(OneByteLookupTable[6] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstByte)
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
    OneByteLookupTable[6] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
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
  function write(OneByteLookupTable[7] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstByte)
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
    OneByteLookupTable[7] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
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
  function write(OneByteLookupTable[8] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstByte)
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
    OneByteLookupTable[8] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, key)
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
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
  function write(OneByteLookupTable[] memory table, uint256 key, uint256 value) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, add(key, 0x20))
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
      // Apply mask to remove the existing value for `key`
      let cleaned := and(mload(ptr), MaskExcludeFirstByte)
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
    OneByteLookupTable[] memory table,
    uint256 key,
    uint256 value
  ) internal pure {
    assembly {
      // Calculate pointer to position of `key` in memory
      let ptr := add(table, add(key, 0x20))
      // Shift `value` so that it occupies the first 1 bytes
      let positioned := shl(WordMinusByte, value)
      // Update value for `key` without overwriting any existing value.
      mstore(ptr, or(mload(ptr), positioned))
    }
  }
}

using { read, write, writeUnsafe } for OneByteLookupTable global;
