// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import './PointerLibraries.sol';

library ArrayHelpers {
  function elementPointer(MemoryPointer arr, uint256 index) internal pure returns (MemoryPointer) {
    unchecked {
      return arr.offset((index + 1) << 5);
    }
  }

  function element(MemoryPointer arr, uint256 index) internal pure returns (uint256) {
    unchecked {
      return arr.offset((index + 1) << 5).readUint256();
    }
  }

  function setElement(MemoryPointer arr, uint256 index, uint256 value) internal pure {
    unchecked {
      arr.offset((index + 1) << 5).write(value);
    }
  }

  function copyArrayElements(MemoryPointer src, MemoryPointer dst, uint256 length) internal pure {
    unchecked {
      MemoryPointer srcPosition = src.next();
      MemoryPointer srcEnd = srcPosition.offset(length << 5);
      MemoryPointer dstPosition = dst.next();

      while (srcPosition.lt(srcEnd)) {
        dstPosition.write(srcPosition.readUint256());
        dstPosition = dstPosition.next();
        srcPosition = srcPosition.next();
      }
    }
  }

  function cloneArray(MemoryPointer src) internal pure returns (MemoryPointer dst) {
    unchecked {
      uint256 length = src.readUint256();
      dst = malloc((length + 1) << 5);
      dst.write(length);
      copyArrayElements(src, dst, length);
    }
  }

  function cloneAndPush(
    MemoryPointer src,
    uint256 newElement
  ) internal pure returns (MemoryPointer dst) {
    unchecked {
      uint256 length = src.readUint256();
      dst = malloc((length + 2) << 5);
      dst.write(length + 1);

      MemoryPointer srcPosition = src.next();
      MemoryPointer srcEnd = srcPosition.offset(length << 5);
      MemoryPointer dstPosition = dst.next();

      while (srcPosition.lt(srcEnd)) {
        dstPosition.write(srcPosition.readUint256());
        dstPosition = dstPosition.next();
        srcPosition = srcPosition.next();
      }
      dstPosition.write(newElement);
    }
  }

  // =====================================================================//
  //            map with (element) => (newElement) callback               //
  // =====================================================================//

  /**
   * @dev map calls a defined callback function on each element of an array
   *      and returns an array that contains the results
   *
   * @param array   the array to map
   * @param fn      a function that accepts each element in the array and
   *                returns a new value to put in its place in the new array
   *
   * @return newArray the new array created with the results from calling
   *         fn with each element
   */
  function map(
    MemoryPointer array,
    /* function (uint256 value) returns (uint256 newValue) */
    function(uint256) internal pure returns (uint256) fn
  ) internal pure returns (MemoryPointer newArray) {
    unchecked {
      uint256 length = array.readUint256();

      newArray = getFreeMemoryPointer();
      newArray.write(length);

      MemoryPointer srcPosition = array.next();
      MemoryPointer dstPosition = newArray.next();
      MemoryPointer dstEnd = dstPosition.offset(length << 5);
      setFreeMemoryPointer(dstEnd);

      while (dstPosition.lt(dstEnd)) {
        dstPosition.write(fn(srcPosition.readUint256()));
        dstPosition = dstPosition.next();
        srcPosition = srcPosition.next();
      }
    }
  }

  /**
   * @dev mapWithIndex calls a defined callback function with each element of
   *      an array and its index and returns an array that contains the results
   *
   * @param array   the array to map
   * @param fn      a function that accepts each element in the array and
   *                its index and returns a new value to put in its place
   *                in the new array
   *
   * @return newArray the new array created with the results from calling
   *         fn with each element
   */
  function mapWithIndex(
    MemoryPointer array,
    /* function (uint256 value, uint256 index) returns (uint256 newValue) */
    function(uint256, uint256) internal pure returns (uint256) fn
  ) internal pure returns (MemoryPointer newArray) {
    unchecked {
      uint256 length = array.readUint256();

      newArray = malloc((length + 1) << 5);
      newArray.write(length);

      MemoryPointer srcPosition = array.next();
      MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
      MemoryPointer dstPosition = newArray.next();

      uint256 index;
      while (srcPosition.lt(srcEnd)) {
        dstPosition.write(fn(srcPosition.readUint256(), index++));
        srcPosition = srcPosition.next();
        dstPosition = dstPosition.next();
      }
    }
  }

  /**
   * @dev mapWithArg calls a defined callback function with each element of an
   *      array and a provided arg and returns an array that contains the results
   *
   * @param array   the array to map
   * @param fn      a function that accepts each element in the array and
   *                the `arg` value provided in the call and returns
   *                a new value to put in its place in the new array
   * @param arg     an arbitrary value provided in each call to fn
   *
   * @return newArray the new array created with the results from calling
   *         fn with each element
   */
  function mapWithArg(
    MemoryPointer array,
    /* function (uint256 value, uint256 arg) returns (uint256 newValue) */
    function(uint256, uint256) internal pure returns (uint256) fn,
    uint256 arg
  ) internal pure returns (MemoryPointer newArray) {
    unchecked {
      uint256 length = array.readUint256();

      newArray = malloc((length + 1) << 5);
      newArray.write(length);

      MemoryPointer srcPosition = array.next();
      MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
      MemoryPointer dstPosition = newArray.next();

      while (srcPosition.lt(srcEnd)) {
        dstPosition.write(fn(srcPosition.readUint256(), arg));
        srcPosition = srcPosition.next();
        dstPosition = dstPosition.next();
      }
    }
  }

  function mapWithIndexAndArg(
    MemoryPointer array,
    /* function (uint256 value, uint256 index, uint256 arg) returns (uint256 newValue) */
    function(uint256, uint256, uint256) internal pure returns (uint256) fn,
    uint256 arg
  ) internal pure returns (MemoryPointer newArray) {
    unchecked {
      uint256 length = array.readUint256();

      newArray = malloc((length + 1) << 5);
      newArray.write(length);

      MemoryPointer srcPosition = array.next();
      MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
      MemoryPointer dstPosition = newArray.next();

      uint256 index;
      while (srcPosition.lt(srcEnd)) {
        dstPosition.write(fn(srcPosition.readUint256(), index++, arg));
        srcPosition = srcPosition.next();
        dstPosition = dstPosition.next();
      }
    }
  }

  // =====================================================================//
  //         filterMap with (element) => (newElement) predicate           //
  // =====================================================================//

  /**
   * @dev filterMap calls a defined callback function on each element of an array
   *      and returns an array that contains only the non-zero results
   *
   * @notice  this method should not be used for arrays with value base types,
   *          as it does not shift the head/tail of the array to the appropriate
   *          position for such an array
   *
   * @param array   the array to map
   * @param fn      a function that accepts each element in the array and
   *                returns a new value to put in its place in the new array
   *                or a zero value to indicate that the element should not
   *                be included in the new array
   *
   * @return newArray the new array created with the results from calling
   *                  fn with each element
   */
  function filterMap(
    MemoryPointer array,
    /* function (uint256 value) returns (uint256 newValue) */
    function(MemoryPointer) internal pure returns (MemoryPointer) fn
  ) internal pure returns (MemoryPointer newArray) {
    unchecked {
      uint256 length = array.readUint256();

      newArray = malloc((length + 1) << 5);

      MemoryPointer srcPosition = array.next();
      MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
      MemoryPointer dstPosition = newArray.next();

      length = 0;

      while (srcPosition.lt(srcEnd)) {
        MemoryPointer result = fn(srcPosition.readMemoryPointer());
        if (!result.isNull()) {
          dstPosition.write(result);
          dstPosition = dstPosition.next();
          length += 1;
        }
        srcPosition = srcPosition.next();
      }
      newArray.write(length);
    }
  }

  // ====================================================================//
  //             filter with (element) => (bool) predicate               //
  // ====================================================================//

  /**
   * @dev filter calls a defined callback function on each element of an array
   *      and returns an array that contains only the elements which the callback
   *      returned true for
   *
   * @notice  this method should not be used for arrays with value base types,
   *          as it does not shift the head/tail of the array to the appropriate
   *          position for such an array
   *
   * @param array   the array to map
   * @param fn      a function that accepts each element in the array and
   *                returns a boolean that indicates whether the element
   *                should be included in the new array
   *
   * @return newArray the new array created with the elements which the callback
   *                  returned true for
   */
  function filter(
    MemoryPointer array,
    /* function (uint256 value) returns (bool) */
    function(MemoryPointer) internal pure returns (bool) fn
  ) internal pure returns (MemoryPointer newArray) {
    unchecked {
      uint256 length = array.readUint256();

      newArray = malloc((length + 1) << 5);

      MemoryPointer srcPosition = array.next();
      MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
      MemoryPointer dstPosition = newArray.next();

      length = 0;

      while (srcPosition.lt(srcEnd)) {
        MemoryPointer _element = srcPosition.readMemoryPointer();
        if (fn(_element)) {
          dstPosition.write(_element);
          dstPosition = dstPosition.next();
          length += 1;
        }
        srcPosition = srcPosition.next();
      }
      newArray.write(length);
    }
  }

  function reduce(
    MemoryPointer array,
    /* function (uint256 currentResult, uint256 element) returns (uint256 newResult) */
    function(uint256, uint256) internal pure returns (uint256) fn,
    uint256 initialValue
  ) internal pure returns (uint256 result) {
    unchecked {
      uint256 length = array.readUint256();

      MemoryPointer srcPosition = array.next();
      MemoryPointer srcEnd = srcPosition.offset(length * 0x20);

      result = initialValue;
      while (srcPosition.lt(srcEnd)) {
        result = fn(result, srcPosition.readUint256());
        srcPosition = srcPosition.next();
      }
    }
  }

  function reduceWithArg(
    MemoryPointer array,
    /* function (uint256 currentResult, uint256 element, uint256 arg) */
    /* returns (uint256 newResult) */
    function(uint256, uint256, MemoryPointer) internal returns (uint256) fn,
    uint256 initialValue,
    MemoryPointer arg
  ) internal returns (uint256 result) {
    unchecked {
      uint256 length = array.readUint256();

      MemoryPointer srcPosition = array.next();
      MemoryPointer srcEnd = srcPosition.offset(length * 0x20);

      result = initialValue;
      while (srcPosition.lt(srcEnd)) {
        result = fn(result, srcPosition.readUint256(), arg);
        srcPosition = srcPosition.next();
      }
    }
  }

  function forEach(
    MemoryPointer array,
    /* function (uint256 element) */
    function(uint256) internal pure fn
  ) internal pure {
    unchecked {
      uint256 length = array.readUint256();

      MemoryPointer srcPosition = array.next();
      MemoryPointer srcEnd = srcPosition.offset(length * 0x20);

      while (srcPosition.lt(srcEnd)) {
        fn(srcPosition.readUint256());
        srcPosition = srcPosition.next();
      }
    }
  }

  function forEachWithArg(
    MemoryPointer array,
    /* function (uint256 element, uint256 arg) */
    function(uint256, uint256) internal pure fn,
    uint256 arg
  ) internal pure {
    unchecked {
      uint256 length = array.readUint256();

      MemoryPointer srcPosition = array.next();
      MemoryPointer srcEnd = srcPosition.offset(length * 0x20);

      while (srcPosition.lt(srcEnd)) {
        fn(srcPosition.readUint256(), arg);
        srcPosition = srcPosition.next();
      }
    }
  }

  // =====================================================================//
  //            find with function(uint256 element) predicate             //
  // =====================================================================//

  /**
   * @dev calls `predicate` once for each element of the array, in ascending order, until it
   *      finds one where predicate returns true. If such an element is found, find immediately
   *      returns that element value. Otherwise, find returns 0.
   *
   * @custom:author docs shamelessly stolen from TypeScript documentation
   *
   * @param array     array to search
   * @param predicate function that checks whether each element meets the search filter.
   *
   * @return          the value of the first element in the array where predicate is true
   *                  and 0 otherwise.
   */
  function find(
    MemoryPointer array,
    function(uint256) internal pure returns (bool) predicate
  ) internal pure returns (uint256) {
    unchecked {
      uint256 length = array.readUint256();
      MemoryPointer srcPosition = array.next();
      MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
      while (srcPosition.lt(srcEnd)) {
        uint256 value = srcPosition.readUint256();
        if (predicate(value)) return value;
        srcPosition = srcPosition.next();
      }
      return 0;
    }
  }

  // =====================================================================//
  //     find with function(uint256 element, uint256 arg) predicate       //
  // =====================================================================//

  /**
   * @dev calls `predicate` once for each element of the array, in ascending order, until it
   *      finds one where predicate returns true. If such an element is found, find immediately
   *      returns that element value. Otherwise, find returns 0.
   *
   * @custom:author docs shamelessly stolen from TypeScript documentation
   *
   * @param array   array to search
   * @param arg     second input to `predicate`
   * @param predicate function that checks whether each element meets the search filter.
   *
   * @return          the value of the first element in the array where predicate is true
   *                  and 0 otherwise.
   */
  function findWithArg(
    MemoryPointer array,
    function(uint256, uint256) internal pure returns (bool) predicate,
    uint256 arg
  ) internal pure returns (uint256) {
    unchecked {
      uint256 length = array.readUint256();
      MemoryPointer srcPosition = array.next();
      MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
      while (srcPosition.lt(srcEnd)) {
        uint256 value = srcPosition.readUint256();
        if (predicate(value, arg)) return value;
        srcPosition = srcPosition.next();
      }
      return 0;
    }
  }

  // =====================================================================//
  //                               indexOf                                //
  // =====================================================================//

  /**
   * @dev Returns the index of the first occurrence of a value in an array,
   *      or -1 if it is not present.
   *
   * @param array         array to search
   * @param searchElement the value to locate in the array.
   */
  function indexOf(
    MemoryPointer array,
    uint256 searchElement
  ) internal pure returns (int256 index) {
    unchecked {
      int256 length = array.readInt256();
      MemoryPointer src = array;
      int256 reachedEnd;
      while (
        ((reachedEnd = toInt(index == length)) |
          toInt((src = src.next()).readUint256() == searchElement)) == 0
      ) {
        index += 1;
      }
      return (reachedEnd * -1) | index;
    }
  }

  function toInt(bool a) internal pure returns (int256 b) {
    assembly {
      b := a
    }
  }

  // =====================================================================//
  //                                findIndex                             //
  // =====================================================================//

  function findIndex(
    MemoryPointer array,
    function(uint256) internal pure returns (bool) predicate
  ) internal pure returns (int256 index) {
    unchecked {
      int256 length = array.readInt256();
      MemoryPointer src = array;
      while (index < length) {
        if (predicate((src = src.next()).readUint256())) {
          return index;
        }
        index += 1;
      }
      return -1;
    }
  }

  // =====================================================================//
  //                     findIndex with one argument                      //
  // =====================================================================//

  function findIndexWithArg(
    MemoryPointer array,
    function(uint256, uint256) internal pure returns (bool) predicate,
    uint256 arg
  ) internal pure returns (int256 index) {
    unchecked {
      int256 length = array.readInt256();
      MemoryPointer src = array;
      while (index < length) {
        if (predicate((src = src.next()).readUint256(), arg)) {
          return index;
        }
        index += 1;
      }
      return -1;
    }
  }

  // =====================================================================//
  //                     findIndex from start index                       //
  // =====================================================================//

  function findIndexFrom(
    MemoryPointer array,
    function(MemoryPointer) internal pure returns (bool) predicate,
    uint256 fromIndex
  ) internal pure returns (int256 index) {
    unchecked {
      index = int256(fromIndex);
      int256 length = array.readInt256();
      MemoryPointer src = array.offset(fromIndex * 0x20);
      while (index < length) {
        if (predicate((src = src.next()).readMemoryPointer())) {
          return index;
        }
        index += 1;
      }
      return -1;
    }
  }

  function findIndexFromWithArg(
    MemoryPointer array,
    function(MemoryPointer, MemoryPointer) internal pure returns (bool) predicate,
    uint256 fromIndex,
    MemoryPointer arg
  ) internal pure returns (int256 index) {
    unchecked {
      index = int256(fromIndex);
      int256 length = array.readInt256();
      MemoryPointer src = array.offset(fromIndex * 0x20);
      while (index < length) {
        if (predicate((src = src.next()).readMemoryPointer(), arg)) {
          return index;
        }
        index += 1;
      }
      return -1;
    }
  }

  function countFrom(
    MemoryPointer array,
    function(uint256) internal pure returns (bool) predicate,
    uint256 fromIndex
  ) internal pure returns (uint256 count) {
    unchecked {
      uint256 index = fromIndex;
      uint256 length = array.readUint256();
      MemoryPointer src = array.offset(fromIndex * 0x20);
      while (index < length) {
        if (predicate((src = src.next()).readUint256())) {
          count += 1;
        }
        index += 1;
      }
    }
  }

  // =====================================================================//
  //                      includes with one argument                      //
  // =====================================================================//

  function includes(MemoryPointer array, uint256 value) internal pure returns (bool) {
    return indexOf(array, value) != -1;
  }
}
