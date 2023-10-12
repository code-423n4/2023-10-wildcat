// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { MemoryPointer, OffsetOrLengthMask, _OneWord } from './MemoryPointer.sol';

type ReturndataPointer is uint256;

using ReturndataPointerLib for ReturndataPointer global;

using ReturndataReaders for ReturndataPointer global;

ReturndataPointer constant ReturndataStart = ReturndataPointer.wrap(0x00);

library ReturndataPointerLib {
  function isNull(ReturndataPointer a) internal pure returns (bool b) {
    assembly {
      b := iszero(a)
    }
  }

  function lt(ReturndataPointer a, ReturndataPointer b) internal pure returns (bool c) {
    assembly {
      c := lt(a, b)
    }
  }

  function gt(ReturndataPointer a, ReturndataPointer b) internal pure returns (bool c) {
    assembly {
      c := gt(a, b)
    }
  }

  function eq(ReturndataPointer a, ReturndataPointer b) internal pure returns (bool c) {
    assembly {
      c := eq(a, b)
    }
  }

  /// @dev Resolves an offset stored at `rdPtr + headOffset` to a returndata
  ///      pointer. `rdPtr` must point to some parent object with a dynamic
  ///      type's head stored at `rdPtr + headOffset`.
  function pptr(
    ReturndataPointer rdPtr,
    uint256 headOffset
  ) internal pure returns (ReturndataPointer rdPtrChild) {
    rdPtrChild = rdPtr.offset(rdPtr.offset(headOffset).readUint256() & OffsetOrLengthMask);
  }

  /// @dev Resolves an offset stored at `rdPtr` to a returndata pointer.
  ///    `rdPtr` must point to some parent object with a dynamic type as its
  ///    first member, e.g. `struct { bytes data; }`
  function pptr(ReturndataPointer rdPtr) internal pure returns (ReturndataPointer rdPtrChild) {
    rdPtrChild = rdPtr.offset(rdPtr.readUint256() & OffsetOrLengthMask);
  }

  /// @dev Returns the returndata pointer one word after `cdPtr`.
  function next(ReturndataPointer rdPtr) internal pure returns (ReturndataPointer rdPtrNext) {
    assembly {
      rdPtrNext := add(rdPtr, _OneWord)
    }
  }

  /// @dev Returns the returndata pointer `_offset` bytes after `cdPtr`.
  function offset(
    ReturndataPointer rdPtr,
    uint256 _offset
  ) internal pure returns (ReturndataPointer rdPtrNext) {
    assembly {
      rdPtrNext := add(rdPtr, _offset)
    }
  }

  /// @dev Copies `size` bytes from returndata starting at `src` to memory at
  /// `dst`.
  function copy(ReturndataPointer src, MemoryPointer dst, uint256 size) internal pure {
    assembly {
      returndatacopy(dst, src, size)
    }
  }
}

library ReturndataReaders {
  /// @dev Reads value at `rdPtr` & applies a mask to return only last 4 bytes
  function readMaskedUint32(ReturndataPointer rdPtr) internal pure returns (uint256 value) {
    value = rdPtr.readUint256() & OffsetOrLengthMask;
  }

  /// @dev Reads the bool at `rdPtr` in returndata.
  function readBool(ReturndataPointer rdPtr) internal pure returns (bool value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the address at `rdPtr` in returndata.
  function readAddress(ReturndataPointer rdPtr) internal pure returns (address value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes1 at `rdPtr` in returndata.
  function readBytes1(ReturndataPointer rdPtr) internal pure returns (bytes1 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes2 at `rdPtr` in returndata.
  function readBytes2(ReturndataPointer rdPtr) internal pure returns (bytes2 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes3 at `rdPtr` in returndata.
  function readBytes3(ReturndataPointer rdPtr) internal pure returns (bytes3 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes4 at `rdPtr` in returndata.
  function readBytes4(ReturndataPointer rdPtr) internal pure returns (bytes4 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes5 at `rdPtr` in returndata.
  function readBytes5(ReturndataPointer rdPtr) internal pure returns (bytes5 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes6 at `rdPtr` in returndata.
  function readBytes6(ReturndataPointer rdPtr) internal pure returns (bytes6 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes7 at `rdPtr` in returndata.
  function readBytes7(ReturndataPointer rdPtr) internal pure returns (bytes7 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes8 at `rdPtr` in returndata.
  function readBytes8(ReturndataPointer rdPtr) internal pure returns (bytes8 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes9 at `rdPtr` in returndata.
  function readBytes9(ReturndataPointer rdPtr) internal pure returns (bytes9 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes10 at `rdPtr` in returndata.
  function readBytes10(ReturndataPointer rdPtr) internal pure returns (bytes10 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes11 at `rdPtr` in returndata.
  function readBytes11(ReturndataPointer rdPtr) internal pure returns (bytes11 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes12 at `rdPtr` in returndata.
  function readBytes12(ReturndataPointer rdPtr) internal pure returns (bytes12 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes13 at `rdPtr` in returndata.
  function readBytes13(ReturndataPointer rdPtr) internal pure returns (bytes13 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes14 at `rdPtr` in returndata.
  function readBytes14(ReturndataPointer rdPtr) internal pure returns (bytes14 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes15 at `rdPtr` in returndata.
  function readBytes15(ReturndataPointer rdPtr) internal pure returns (bytes15 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes16 at `rdPtr` in returndata.
  function readBytes16(ReturndataPointer rdPtr) internal pure returns (bytes16 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes17 at `rdPtr` in returndata.
  function readBytes17(ReturndataPointer rdPtr) internal pure returns (bytes17 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes18 at `rdPtr` in returndata.
  function readBytes18(ReturndataPointer rdPtr) internal pure returns (bytes18 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes19 at `rdPtr` in returndata.
  function readBytes19(ReturndataPointer rdPtr) internal pure returns (bytes19 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes20 at `rdPtr` in returndata.
  function readBytes20(ReturndataPointer rdPtr) internal pure returns (bytes20 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes21 at `rdPtr` in returndata.
  function readBytes21(ReturndataPointer rdPtr) internal pure returns (bytes21 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes22 at `rdPtr` in returndata.
  function readBytes22(ReturndataPointer rdPtr) internal pure returns (bytes22 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes23 at `rdPtr` in returndata.
  function readBytes23(ReturndataPointer rdPtr) internal pure returns (bytes23 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes24 at `rdPtr` in returndata.
  function readBytes24(ReturndataPointer rdPtr) internal pure returns (bytes24 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes25 at `rdPtr` in returndata.
  function readBytes25(ReturndataPointer rdPtr) internal pure returns (bytes25 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes26 at `rdPtr` in returndata.
  function readBytes26(ReturndataPointer rdPtr) internal pure returns (bytes26 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes27 at `rdPtr` in returndata.
  function readBytes27(ReturndataPointer rdPtr) internal pure returns (bytes27 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes28 at `rdPtr` in returndata.
  function readBytes28(ReturndataPointer rdPtr) internal pure returns (bytes28 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes29 at `rdPtr` in returndata.
  function readBytes29(ReturndataPointer rdPtr) internal pure returns (bytes29 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes30 at `rdPtr` in returndata.
  function readBytes30(ReturndataPointer rdPtr) internal pure returns (bytes30 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes31 at `rdPtr` in returndata.
  function readBytes31(ReturndataPointer rdPtr) internal pure returns (bytes31 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the bytes32 at `rdPtr` in returndata.
  function readBytes32(ReturndataPointer rdPtr) internal pure returns (bytes32 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint8 at `rdPtr` in returndata.
  function readUint8(ReturndataPointer rdPtr) internal pure returns (uint8 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint16 at `rdPtr` in returndata.
  function readUint16(ReturndataPointer rdPtr) internal pure returns (uint16 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint24 at `rdPtr` in returndata.
  function readUint24(ReturndataPointer rdPtr) internal pure returns (uint24 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint32 at `rdPtr` in returndata.
  function readUint32(ReturndataPointer rdPtr) internal pure returns (uint32 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint40 at `rdPtr` in returndata.
  function readUint40(ReturndataPointer rdPtr) internal pure returns (uint40 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint48 at `rdPtr` in returndata.
  function readUint48(ReturndataPointer rdPtr) internal pure returns (uint48 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint56 at `rdPtr` in returndata.
  function readUint56(ReturndataPointer rdPtr) internal pure returns (uint56 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint64 at `rdPtr` in returndata.
  function readUint64(ReturndataPointer rdPtr) internal pure returns (uint64 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint72 at `rdPtr` in returndata.
  function readUint72(ReturndataPointer rdPtr) internal pure returns (uint72 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint80 at `rdPtr` in returndata.
  function readUint80(ReturndataPointer rdPtr) internal pure returns (uint80 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint88 at `rdPtr` in returndata.
  function readUint88(ReturndataPointer rdPtr) internal pure returns (uint88 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint96 at `rdPtr` in returndata.
  function readUint96(ReturndataPointer rdPtr) internal pure returns (uint96 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint104 at `rdPtr` in returndata.
  function readUint104(ReturndataPointer rdPtr) internal pure returns (uint104 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint112 at `rdPtr` in returndata.
  function readUint112(ReturndataPointer rdPtr) internal pure returns (uint112 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint120 at `rdPtr` in returndata.
  function readUint120(ReturndataPointer rdPtr) internal pure returns (uint120 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint128 at `rdPtr` in returndata.
  function readUint128(ReturndataPointer rdPtr) internal pure returns (uint128 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint136 at `rdPtr` in returndata.
  function readUint136(ReturndataPointer rdPtr) internal pure returns (uint136 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint144 at `rdPtr` in returndata.
  function readUint144(ReturndataPointer rdPtr) internal pure returns (uint144 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint152 at `rdPtr` in returndata.
  function readUint152(ReturndataPointer rdPtr) internal pure returns (uint152 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint160 at `rdPtr` in returndata.
  function readUint160(ReturndataPointer rdPtr) internal pure returns (uint160 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint168 at `rdPtr` in returndata.
  function readUint168(ReturndataPointer rdPtr) internal pure returns (uint168 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint176 at `rdPtr` in returndata.
  function readUint176(ReturndataPointer rdPtr) internal pure returns (uint176 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint184 at `rdPtr` in returndata.
  function readUint184(ReturndataPointer rdPtr) internal pure returns (uint184 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint192 at `rdPtr` in returndata.
  function readUint192(ReturndataPointer rdPtr) internal pure returns (uint192 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint200 at `rdPtr` in returndata.
  function readUint200(ReturndataPointer rdPtr) internal pure returns (uint200 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint208 at `rdPtr` in returndata.
  function readUint208(ReturndataPointer rdPtr) internal pure returns (uint208 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint216 at `rdPtr` in returndata.
  function readUint216(ReturndataPointer rdPtr) internal pure returns (uint216 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint224 at `rdPtr` in returndata.
  function readUint224(ReturndataPointer rdPtr) internal pure returns (uint224 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint232 at `rdPtr` in returndata.
  function readUint232(ReturndataPointer rdPtr) internal pure returns (uint232 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint240 at `rdPtr` in returndata.
  function readUint240(ReturndataPointer rdPtr) internal pure returns (uint240 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint248 at `rdPtr` in returndata.
  function readUint248(ReturndataPointer rdPtr) internal pure returns (uint248 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the uint256 at `rdPtr` in returndata.
  function readUint256(ReturndataPointer rdPtr) internal pure returns (uint256 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int8 at `rdPtr` in returndata.
  function readInt8(ReturndataPointer rdPtr) internal pure returns (int8 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int16 at `rdPtr` in returndata.
  function readInt16(ReturndataPointer rdPtr) internal pure returns (int16 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int24 at `rdPtr` in returndata.
  function readInt24(ReturndataPointer rdPtr) internal pure returns (int24 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int32 at `rdPtr` in returndata.
  function readInt32(ReturndataPointer rdPtr) internal pure returns (int32 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int40 at `rdPtr` in returndata.
  function readInt40(ReturndataPointer rdPtr) internal pure returns (int40 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int48 at `rdPtr` in returndata.
  function readInt48(ReturndataPointer rdPtr) internal pure returns (int48 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int56 at `rdPtr` in returndata.
  function readInt56(ReturndataPointer rdPtr) internal pure returns (int56 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int64 at `rdPtr` in returndata.
  function readInt64(ReturndataPointer rdPtr) internal pure returns (int64 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int72 at `rdPtr` in returndata.
  function readInt72(ReturndataPointer rdPtr) internal pure returns (int72 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int80 at `rdPtr` in returndata.
  function readInt80(ReturndataPointer rdPtr) internal pure returns (int80 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int88 at `rdPtr` in returndata.
  function readInt88(ReturndataPointer rdPtr) internal pure returns (int88 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int96 at `rdPtr` in returndata.
  function readInt96(ReturndataPointer rdPtr) internal pure returns (int96 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int104 at `rdPtr` in returndata.
  function readInt104(ReturndataPointer rdPtr) internal pure returns (int104 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int112 at `rdPtr` in returndata.
  function readInt112(ReturndataPointer rdPtr) internal pure returns (int112 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int120 at `rdPtr` in returndata.
  function readInt120(ReturndataPointer rdPtr) internal pure returns (int120 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int128 at `rdPtr` in returndata.
  function readInt128(ReturndataPointer rdPtr) internal pure returns (int128 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int136 at `rdPtr` in returndata.
  function readInt136(ReturndataPointer rdPtr) internal pure returns (int136 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int144 at `rdPtr` in returndata.
  function readInt144(ReturndataPointer rdPtr) internal pure returns (int144 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int152 at `rdPtr` in returndata.
  function readInt152(ReturndataPointer rdPtr) internal pure returns (int152 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int160 at `rdPtr` in returndata.
  function readInt160(ReturndataPointer rdPtr) internal pure returns (int160 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int168 at `rdPtr` in returndata.
  function readInt168(ReturndataPointer rdPtr) internal pure returns (int168 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int176 at `rdPtr` in returndata.
  function readInt176(ReturndataPointer rdPtr) internal pure returns (int176 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int184 at `rdPtr` in returndata.
  function readInt184(ReturndataPointer rdPtr) internal pure returns (int184 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int192 at `rdPtr` in returndata.
  function readInt192(ReturndataPointer rdPtr) internal pure returns (int192 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int200 at `rdPtr` in returndata.
  function readInt200(ReturndataPointer rdPtr) internal pure returns (int200 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int208 at `rdPtr` in returndata.
  function readInt208(ReturndataPointer rdPtr) internal pure returns (int208 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int216 at `rdPtr` in returndata.
  function readInt216(ReturndataPointer rdPtr) internal pure returns (int216 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int224 at `rdPtr` in returndata.
  function readInt224(ReturndataPointer rdPtr) internal pure returns (int224 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int232 at `rdPtr` in returndata.
  function readInt232(ReturndataPointer rdPtr) internal pure returns (int232 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int240 at `rdPtr` in returndata.
  function readInt240(ReturndataPointer rdPtr) internal pure returns (int240 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int248 at `rdPtr` in returndata.
  function readInt248(ReturndataPointer rdPtr) internal pure returns (int248 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }

  /// @dev Reads the int256 at `rdPtr` in returndata.
  function readInt256(ReturndataPointer rdPtr) internal pure returns (int256 value) {
    assembly {
      returndatacopy(0, rdPtr, _OneWord)
      value := mload(0)
    }
  }
}
