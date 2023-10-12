// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import '../utils/Math.sol';
import '../utils/ErrorConstants.sol';

struct Bytes32Set {
  bytes32[] _values;
  mapping(bytes32 => uint256) indexes;
}

struct AddressSet {
  address[] _values;
  mapping(address => uint256) indexes;
}

struct UintSet {
  uint256[] _values;
  mapping(uint256 => uint256) indexes;
}

using EnumerableSetLib for Bytes32Set global;
using EnumerableSetLib for AddressSet global;
using EnumerableSetLib for UintSet global;

library EnumerableSetLib {
  using EnumerableSetLib for bytes32;
  using EnumerableSetLib for address;
  using EnumerableSetLib for uint256;
  using EnumerableSetLib for bytes32[];

  function _setIndexOf(Bytes32Set storage set, bytes32 value, uint256 index) private {
    assembly {
      mstore(0, value)
      mstore(0x20, add(set.slot, 1))
      sstore(keccak256(0, 64), index)
    }
  }

  function _setLength(Bytes32Set storage set, uint256 newLength) private {
    assembly {
      sstore(set.slot, newLength)
    }
  }

  function _setAt(Bytes32Set storage set, uint256 index, bytes32 value) private {
    assembly {
      mstore(0, set.slot)
      let valueSlot := add(keccak256(0, 32), index)
      sstore(valueSlot, value)
    }
  }

  /* ========================================================================== */
  /*                                 Bytes32 Set                                */
  /* ========================================================================== */

  function indexOf(Bytes32Set storage set, bytes32 value) internal view returns (uint256 index) {
    assembly {
      mstore(0, value)
      mstore(0x20, add(set.slot, 1))
      index := sload(keccak256(0, 64))
    }
  }

  function length(Bytes32Set storage set) internal view returns (uint256 _length) {
    assembly {
      _length := sload(set.slot)
    }
  }

  function unsafeAt(Bytes32Set storage set, uint256 index) internal view returns (bytes32 value) {
    assembly {
      mstore(0, set.slot)
      let valueSlot := add(keccak256(0, 32), index)
      value := sload(valueSlot)
    }
  }

  /**
   * @dev Returns the value stored at position `index` in the set. O(1).
   *
   * Note that there are no guarantees on the ordering of values inside the
   * array, and it may change when more values are added or removed.
   *
   * Requirements:
   *
   * - `index` must be strictly less than {length}.
   */
  function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32 value) {
    assembly {
      if iszero(lt(index, sload(set.slot))) {
        mstore(0, Panic_ErrorSelector)
        mstore(Panic_ErrorCodePointer, Panic_ArrayOutOfBounds)
        revert(Error_SelectorPointer, Panic_ErrorLength)
      }
      mstore(0, set.slot)
      value := sload(add(keccak256(0, 32), index))
    }
  }

  /**
   * @dev Returns true if the value is in the set. O(1).
   */
  function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool result) {
    assembly {
      mstore(0, value)
      mstore(0x20, add(set.slot, 1))
      result := gt(sload(keccak256(0, 64)), 0)
    }
  }

  /**
   * @dev Add a value to a set. O(1).
   *
   * Returns true if the value was added to the set, that is if it was not
   * already present.
   */
  function add(Bytes32Set storage set, bytes32 value) internal returns (bool result) {
    assembly {
      // uint256 index = indexOf(set, value);
      mstore(0, value)
      mstore(0x20, add(set.slot, 1))
      let indexSlot := keccak256(0, 64)
      let index := sload(indexSlot)
      // if (index == 0)
      if iszero(index) {
        // uint256 length = length(set);
        let len := sload(set.slot)
        // _setAt(set, length, value);
        mstore(0, set.slot)
        let valueSlot := add(keccak256(0, 32), len)
        sstore(valueSlot, value)
        // index = length + 1;
        index := add(len, 1)
        // _setIndexOf(set, value, index);
        sstore(indexSlot, index)
        // _setLength(set, index);
        sstore(set.slot, index)
        // return true;
        result := 1
      }
    }
  }

  /**
   * @dev Removes a value from a set. O(1).
   *
   * Returns true if the value was removed from the set, that is if it was
   * present.
   */
  function remove(Bytes32Set storage set, bytes32 value) internal returns (bool result) {
    assembly {
      // Calculate slot for set.indexes[value]
      mstore(0, value)
      mstore(0x20, add(set.slot, 1))
      let valueIndexSlot := keccak256(0, 64)

      // Equivalent to set.indexOf(value);
      let valueIndex := sload(valueIndexSlot)

      // if (index != 0)
      if valueIndex {
        let len := sload(set.slot) // length(set)

        let toDeleteIndex := sub(valueIndex, 1)
        let lastIndex := sub(len, 1)

        // Get slot pointing to first value of the array
        mstore(0, set.slot)
        let valuesDataSlot := keccak256(0, 32)

        // Get slot for last value in array
        let lastValueSlot := add(valuesDataSlot, lastIndex)

        // If removed value is not last value in array
        if gt(lastIndex, toDeleteIndex) {
          // Read last value in the array
          let lastValue := sload(lastValueSlot)

          // Move the last value to the index where the value to delete is
          let toDeleteValueSlot := add(valuesDataSlot, toDeleteIndex)
          sstore(toDeleteValueSlot, lastValue) // _setAt(set, toDeleteIndex, lastValue);

          // Update the index for the moved value
          mstore(0, lastValue)
          let lastValueIndexSlot := keccak256(0, 64)
          sstore(lastValueIndexSlot, valueIndex) // _setIndexOf(set, lastValue, valueIndex);
        }
        sstore(lastValueSlot, 0) // _setAt(set, lastIndex, bytes32(0));
        sstore(valueIndexSlot, 0) // _setIndexOf(set, value, 0);
        sstore(set.slot, lastIndex) // _setLength(set, lastIndex);
        result := 1 // return true
      }
    }
  }

  /**
   * @dev Return the entire set in an array
   *
   * WARNING: This operation will copy the entire storage to memory, which can be quite expensive.
   * This is designed to mostly be used by view accessors that are queried without any gas fees.
   * Developers should keep in mind that this function has an unbounded cost, and using it as part
   * of a state-changing function may render the function uncallable if the set grows to a point
   * where copying to memory consumes too much gas to fit in a block.
   */
  function values(Bytes32Set storage set) internal view returns (bytes32[] memory arr) {
    assembly {
      let len := sload(set.slot)
      arr := mload(0x40)
      mstore(arr, len)
      mstore(0, set.slot)
      let nextValueSlot := keccak256(0, 32)
      let pointer := add(arr, 32)
      let endPointer := add(pointer, shl(5, len))
      mstore(0x40, endPointer)
      for {

      } lt(pointer, endPointer) {

      } {
        mstore(pointer, sload(nextValueSlot))
        pointer := add(pointer, 32)
        nextValueSlot := add(nextValueSlot, 1)
      }
    }
  }

  function slice(
    Bytes32Set storage set,
    uint256 start,
    uint256 end
  ) internal view returns (bytes32[] memory arr) {
    end = min(end, set.length());
    assembly {
      if gt(start, end) {
        mstore(0, Panic_ErrorSelector)
        mstore(Panic_ErrorCodePointer, Panic_Arithmetic)
        revert(Error_SelectorPointer, Panic_ErrorLength)
      }
      let size := sub(end, start)
      arr := mload(0x40)
      mstore(arr, size)
      mstore(0, set.slot)
      let nextValueSlot := add(keccak256(0, 32), start)
      let pointer := add(arr, 32)
      let endPointer := add(pointer, shl(5, size))
      mstore(0x40, endPointer)
      for {

      } lt(pointer, endPointer) {

      } {
        mstore(pointer, sload(nextValueSlot))
        pointer := add(pointer, 32)
        nextValueSlot := add(nextValueSlot, 1)
      }
    }
  }

  /* ========================================================================== */
  /*                                 Address Set                                */
  /* ========================================================================== */

  function indexOf(AddressSet storage set, address value) internal view returns (uint256 index) {
    return set.asBytes32Set().indexOf(value.asBytes32());
  }

  function length(AddressSet storage set) internal view returns (uint256 _length) {
    return set.asBytes32Set().length();
  }

  function unsafeAt(AddressSet storage set, uint256 index) internal view returns (address value) {
    return set.asBytes32Set().unsafeAt(index).asAddress();
  }

  function at(AddressSet storage set, uint256 index) internal view returns (address value) {
    return set.asBytes32Set().at(index).asAddress();
  }

  function contains(AddressSet storage set, address value) internal view returns (bool) {
    return set.asBytes32Set().contains(value.asBytes32());
  }

  function add(AddressSet storage set, address value) internal returns (bool result) {
    return set.asBytes32Set().add(value.asBytes32());
  }

  function remove(AddressSet storage set, address value) internal returns (bool result) {
    return set.asBytes32Set().remove(value.asBytes32());
  }

  function values(AddressSet storage set) internal view returns (address[] memory) {
    return values(set.asBytes32Set()).asAddressArray();
  }

  function slice(
    AddressSet storage set,
    uint256 start,
    uint256 end
  ) internal view returns (address[] memory arr) {
    return slice(set.asBytes32Set(), start, end).asAddressArray();
  }

  /* ========================================================================== */
  /*                                  Uint Set                                  */
  /* ========================================================================== */

  function indexOf(UintSet storage set, uint256 value) internal view returns (uint256 index) {
    return set.asBytes32Set().indexOf(value.asBytes32());
  }

  function length(UintSet storage set) internal view returns (uint256 _length) {
    return set.asBytes32Set().length();
  }

  function unsafeAt(UintSet storage set, uint256 index) internal view returns (uint256 value) {
    return set.asBytes32Set().unsafeAt(index).asUint();
  }

  function at(UintSet storage set, uint256 index) internal view returns (uint256 value) {
    return set.asBytes32Set().at(index).asUint();
  }

  function contains(UintSet storage set, uint256 value) internal view returns (bool) {
    return set.asBytes32Set().contains(value.asBytes32());
  }

  function add(UintSet storage set, uint256 value) internal returns (bool result) {
    return set.asBytes32Set().add(value.asBytes32());
  }

  function remove(UintSet storage set, uint256 value) internal returns (bool result) {
    return set.asBytes32Set().remove(value.asBytes32());
  }

  function values(UintSet storage set) internal view returns (uint256[] memory) {
    return values(set.asBytes32Set()).asUintArray();
  }

  function slice(
    UintSet storage set,
    uint256 start,
    uint256 end
  ) internal view returns (uint256[] memory arr) {
    return slice(set.asBytes32Set(), start, end).asUintArray();
  }

  // === Type Casts ===

  function asBytes32Set(AddressSet storage set) internal pure returns (Bytes32Set storage _set) {
    assembly {
      _set.slot := set.slot
    }
  }

  function asBytes32Set(UintSet storage set) internal pure returns (Bytes32Set storage _set) {
    assembly {
      _set.slot := set.slot
    }
  }

  function asBytes32(address _value) internal pure returns (bytes32 value) {
    assembly {
      value := _value
    }
  }

  function asBytes32(uint256 _value) internal pure returns (bytes32 value) {
    assembly {
      value := _value
    }
  }

  function asAddress(bytes32 _value) internal pure returns (address value) {
    assembly {
      value := _value
    }
  }

  function asUint(bytes32 _value) internal pure returns (uint256 value) {
    assembly {
      value := _value
    }
  }

  function asAddressArray(
    bytes32[] memory bValues
  ) internal pure returns (address[] memory aValues) {
    assembly {
      aValues := bValues
    }
  }

  function asUintArray(bytes32[] memory bValues) internal pure returns (uint256[] memory aValues) {
    assembly {
      aValues := bValues
    }
  }
}
