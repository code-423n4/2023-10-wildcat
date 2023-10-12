// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import { Test } from 'forge-std/Test.sol';
import 'src/ir-only/ArrayCasts.sol';
import 'src/ir-only/ArrayHelpers.sol';
import 'src/test/MemoryPointerAssertions.sol';

contract ArrayHelpersTest is Test, MemoryPointerAssertions {
  using ArrayCasts for *;
  using ArrayHelpers for MemoryPointer;

  struct Item {
    bytes data;
  }

  function getUint256Array() internal pure returns (MemoryPointer) {
    uint256[] memory arr = new uint256[](3);
    arr[0] = 1;
    arr[1] = 2;
    arr[2] = 3;
    return arr.toPointer();
  }

  function getStructArray() internal pure returns (MemoryPointer ptr) {
    Item[] memory arr = new Item[](3);
    arr[0] = Item(hex'01');
    arr[1] = Item(hex'02');
    arr[2] = Item(hex'03');
    assembly {
      ptr := arr
    }
  }

  // ===================================================================== //
  //        copyArrayElements(MemoryPointer,MemoryPointer,uint256)         //
  // ===================================================================== //

  function test_copyArrayElements() external {
    MemoryPointer arr = getStructArray();
    MemoryPointer freePtr = malloc(0x60);
    freePtr.write(0);
    arr.copyArrayElements(freePtr, 2);
    assertEq(freePtr.offset(0x60), getFreeMemoryPointer(), 'should not allocate memory');
    assertEq(freePtr.readUint256(), 0, 'should not write array length');
    assertBufferEq(freePtr.next(), arr.next(), 0x40, 'Should copy elements 0 and 1');
  }

  // ===================================================================== //
  //                       cloneArray(MemoryPointer)                       //
  // ===================================================================== //

  function test_cloneArray() external {
    MemoryPointer oldArray = getStructArray();
    MemoryPointer freePtr = getFreeMemoryPointer();
    MemoryPointer newArray = oldArray.cloneArray();
    assertEq(
      getFreeMemoryPointer(),
      freePtr.offset(0x80),
      'should allocate memory for length and element heads'
    );
    assertBufferEq(oldArray, newArray, 0x80, 'should copy the array length and element heads');
  }

  // ===================================================================== //
  //                  cloneAndPush(MemoryPointer,uint256)                  //
  // ===================================================================== //

  function test_cloneAndPush() external {
    MemoryPointer oldArray = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    MemoryPointer newArray = oldArray.cloneAndPush(4);
    assertEq(
      getFreeMemoryPointer(),
      freePtr.offset(0xa0),
      'should allocate memory for length and element heads'
    );
    assertEq(newArray.readUint256(), 4, 'should write the new array length');
    assertBufferEq(
      oldArray.next(),
      newArray.next(),
      0x60,
      'should copy the original array length and element heads'
    );
    assertEq(newArray.offset(0x80).readUint256(), 4, 'should write the new element');
  }

  // ===================================================================== //
  //                      map(MemoryPointer,function)                      //
  // ===================================================================== //

  function test_map() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    MemoryPointer mappedArray = array.map(mapCallback);
    assertEq(
      getFreeMemoryPointer(),
      freePtr.offset(0x80),
      'should allocate memory for entire array'
    );
    assertEq(mappedArray.readUint256(), 3, 'should have length 3');
    assertEq(mappedArray.next().readUint256(), 2, 'arr[0] should be 2');
    assertEq(mappedArray.offset(0x40).readUint256(), 4, 'arr[1] should be 4');
    assertEq(mappedArray.offset(0x60).readUint256(), 6, 'arr[2] should be 6');
  }

  function mapCallback(uint256 value) internal pure returns (uint256) {
    return value * 2;
  }

  // ===================================================================== //
  //                   filterMap(MemoryPointer,function)                   //
  // ===================================================================== //

  function test_filterMap() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    MemoryPointer filteredArray = array.filterMap(filterMapCallback);
    assertEq(
      getFreeMemoryPointer(),
      freePtr.offset(0x80),
      'should allocate memory for entire array'
    );
    assertEq(filteredArray.readUint256(), 2, 'should have length 2');
    assertEq(filteredArray.next().readUint256(), 3, 'arr[0] should be 3');
    assertEq(filteredArray.offset(0x40).readUint256(), 4, 'arr[1] should be 4');
  }

  function filterMapCallback(MemoryPointer _element) internal pure returns (MemoryPointer ptr) {
    uint element;
    assembly {
      element := _element
    }
    if (element > 1) {
      ptr = MemoryPointer.wrap(element + 1);
    }
  }

  // ===================================================================== //
  //                    filter(MemoryPointer,function)                     //
  // ===================================================================== //

  function test_filter() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    MemoryPointer filteredArray = array.filter(filterCallback);
    assertEq(
      getFreeMemoryPointer(),
      freePtr.offset(0x80),
      'should allocate memory for entire array'
    );
    assertEq(
      filteredArray.readUint256(),
      2,
      'should have length matching the number of filtered elements'
    );
    assertBufferEq(
      filteredArray.next(),
      array.offset(0x40),
      0x40,
      'should copy the filtered elements'
    );
  }

  function filterCallback(MemoryPointer _element) internal pure returns (bool) {
    uint element;
    assembly {
      element := _element
    }
    return element > 1;
  }

  // ===================================================================== //
  //                 mapWithIndex(MemoryPointer,function)                  //
  // ===================================================================== //

  function test_mapWithIndex() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    MemoryPointer mappedArray = array.mapWithIndex(mapWithIndexCallback);
    assertEq(
      getFreeMemoryPointer(),
      freePtr.offset(0x80),
      'should allocate memory for entire array'
    );
    assertEq(mappedArray.readUint256(), 3, 'should have length 3');
    assertEq(mappedArray.next().readUint256(), 1, 'arr[0] should be 1');
    assertEq(mappedArray.offset(0x40).readUint256(), 3, 'arr[1] should be 3');
    assertEq(mappedArray.offset(0x60).readUint256(), 5, 'arr[2] should be 5');
  }

  function mapWithIndexCallback(uint256 _element, uint256 _index) internal pure returns (uint256) {
    return _element + _index;
  }

  // ===================================================================== //
  //              mapWithArg(MemoryPointer,function,uint256)               //
  // ===================================================================== //

  function test_mapWithArg() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    MemoryPointer mappedArray = array.mapWithArg(mapWithArgCallback, 2);
    assertEq(
      getFreeMemoryPointer(),
      freePtr.offset(0x80),
      'should allocate memory for entire array'
    );
    assertEq(mappedArray.readUint256(), 3, 'should have length 3');
    assertEq(mappedArray.next().readUint256(), 3, 'arr[0] should be 3');
    assertEq(mappedArray.offset(0x40).readUint256(), 4, 'arr[1] should be 4');
    assertEq(mappedArray.offset(0x60).readUint256(), 5, 'arr[2] should be 5');
  }

  function mapWithArgCallback(uint256 _element, uint256 _arg) internal pure returns (uint256) {
    return _element + _arg;
  }

  // ===================================================================== //
  //          mapWithIndexAndArg(MemoryPointer,function,uint256)           //
  // ===================================================================== //

  function test_mapWithIndexAndArg() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    MemoryPointer mappedArray = array.mapWithIndexAndArg(mapWithIndexAndArgCallback, 2);
    assertEq(
      getFreeMemoryPointer(),
      freePtr.offset(0x80),
      'should allocate memory for entire array'
    );
    assertEq(mappedArray.readUint256(), 3, 'should have length 3');
    assertEq(mappedArray.next().readUint256(), 3, 'arr[0] should be 3');
    assertEq(mappedArray.offset(0x40).readUint256(), 5, 'arr[1] should be 5');
    assertEq(mappedArray.offset(0x60).readUint256(), 7, 'arr[2] should be 7');
  }

  function mapWithIndexAndArgCallback(
    uint256 _element,
    uint256 _index,
    uint256 _arg
  ) internal pure returns (uint256) {
    return _element + _index + _arg;
  }

  // ===================================================================== //
  //                reduce(MemoryPointer,function,uint256)                 //
  // ===================================================================== //

  function test_reduce() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    uint256 accumulator = array.reduce(reduceCallback, 0);
    assertEq(getFreeMemoryPointer(), freePtr, 'should not allocate memory');
    assertEq(accumulator, 6, 'should reduce to 6');
  }

  function reduceCallback(uint256 _accumulator, uint256 _element) internal pure returns (uint256) {
    return _accumulator + _element;
  }

  // ===================================================================== //
  //      reduceWithArg(MemoryPointer,function,uint256,MemoryPointer)      //
  // ===================================================================== //

  function test_reduceWithArg() external {
    MemoryPointer cache = malloc(32);
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();

    uint256 accumulator = array.reduceWithArg(reduceWithArgCallback, 0, cache);
    assertEq(getFreeMemoryPointer(), freePtr, 'should not allocate memory');
    assertEq(accumulator, 6, 'should reduce to 6');
    assertEq(cache.readUint256(), 3, 'should write previous accumulator to cache');
  }

  function reduceWithArgCallback(
    uint256 _accumulator,
    uint256 _element,
    MemoryPointer _arg
  ) internal pure returns (uint256) {
    _arg.write(_accumulator);
    return _accumulator + _element;
  }

  // ===================================================================== //
  //                forEach(MemoryPointer,uint256,function)                //
  // ===================================================================== //

  uint256[] internal storageArray;

  function test_forEach() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    array.forEach(asPureFn(forEachCallback));
    assertEq(getFreeMemoryPointer(), freePtr, 'should not allocate memory');
    uint256[] memory storedArray = storageArray;
    assertBufferEq(storedArray.toPointer(), array, 0x80, 'storage array does not match array');
  }

  function forEachCallback(uint256 _element) internal {
    storageArray.push(_element);
  }

  function asPureFn(
    function(uint256) internal _fn
  ) internal pure returns (function(uint256) internal pure fn) {
    assembly {
      fn := _fn
    }
  }

  // ===================================================================== //
  //            forEachWithArg(MemoryPointer,function,uint256)             //
  // ===================================================================== //

  function forEachWithArg() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    array.forEachWithArg(asPureFn(forEachWithArgCallback), 2);
    assertEq(getFreeMemoryPointer(), freePtr, 'should not allocate memory');
    uint256[] memory storedArray = storageArray;
    uint8[3] memory expectedValues = [3, 4, 5];
    MemoryPointer expected;
    assembly {
      expected := expectedValues
    }
    assertEq(storedArray.length, 3, 'storage array should have length 3');
    assertBufferEq(
      storedArray.toPointer().next(),
      expected,
      0x60,
      'storage array does not match expected values'
    );
  }

  function forEachWithArgCallback(uint256 _element, uint256 _arg) internal {
    storageArray.push(_element + _arg);
  }

  function asPureFn(
    function(uint256, uint256) internal _fn
  ) internal pure returns (function(uint256, uint256) internal pure fn) {
    assembly {
      fn := _fn
    }
  }

  // ===================================================================== //
  //                     find(MemoryPointer,function)                      //
  // ===================================================================== //

  function test_find() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    uint256 found = array.find(findPredicate);
    assertEq(getFreeMemoryPointer(), freePtr, 'should not allocate memory');
    assertEq(found, 2, 'did not find 2');
  }

  function findPredicate(uint256 _element) internal pure returns (bool) {
    return _element > 1;
  }

  // ===================================================================== //
  //              findWithArg(MemoryPointer,function,uint256)              //
  // ===================================================================== //

  function test_findWithArg() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    uint256 found = array.findWithArg(findWithArgPredicate, 2);
    assertEq(getFreeMemoryPointer(), freePtr, 'should not allocate memory');
    assertEq(found, 2, 'did not find 2');
  }

  function findWithArgPredicate(uint256 _element, uint256 _min) internal pure returns (bool) {
    return _element >= _min;
  }

  // ===================================================================== //
  //                    indexOf(MemoryPointer,uint256)                     //
  // ===================================================================== //

  function test_indexOf() external {
    MemoryPointer arr = getUint256Array();
    MemoryPointer freeMemoryPointerBefore = getFreeMemoryPointer();
    int256 i1 = arr.indexOf(1);
    MemoryPointer freeMemoryPointerAfter = getFreeMemoryPointer();
    assertEq(freeMemoryPointerBefore, freeMemoryPointerAfter, 'should not allocate memory');
    assertEq(i1, 0, 'indexOf(1)');
    assertEq(arr.indexOf(4), -1, 'indexOf(4)');
    assertEq(arr.indexOf(2), 1, 'indexOf(2)');
  }

  // ===================================================================== //
  //               findIndex(MemoryPointer,uint256,function)               //
  // ===================================================================== //

  function test_findIndex() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    int256 i = array.findIndex(findIndexPredicate);
    assertEq(getFreeMemoryPointer(), freePtr, 'should not allocate memory');
    assertEq(i, 1, 'did not find 2');
  }

  function findIndexPredicate(uint256 _element) internal pure returns (bool) {
    return _element > 1;
  }

  // ===================================================================== //
  //           findIndexWithArg(MemoryPointer,function,uint256)            //
  // ===================================================================== //

  function test_findIndexWithArg() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    int256 i = array.findIndexWithArg(findIndexWithArgPredicate, 2);
    assertEq(getFreeMemoryPointer(), freePtr, 'should not allocate memory');
    assertEq(i, 1, 'did not find 2');
  }

  function findIndexWithArgPredicate(uint256 _element, uint256 _min) internal pure returns (bool) {
    return _element >= _min;
  }

  // ===================================================================== //
  //             findIndexFrom(MemoryPointer,function,uint256)             //
  // ===================================================================== //

  function test_findIndexFrom() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    int256 i = array.findIndexFrom(findIndexFromPredicate, 1);
    assertEq(getFreeMemoryPointer(), freePtr, 'should not allocate memory');
    assertEq(i, 2, 'did not find 3');
  }

  function findIndexFromPredicate(MemoryPointer _element) internal pure returns (bool) {
    uint element = MemoryPointer.unwrap(_element);
    return element == 1 || element == 3;
  }

  // ===================================================================== //
  //  findIndexFromWithArg(MemoryPointer,function,uint256,MemoryPointer)   //
  // ===================================================================== //

  function test_findIndexFromWithArg() external {
    MemoryPointer arg = malloc(32);
    arg.write((uint(1) << 128) | 3);
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();

    int256 i = array.findIndexFromWithArg(findIndexFromWithArgPredicate, 1, arg);
    assertEq(getFreeMemoryPointer(), freePtr, 'should not allocate memory');
    assertEq(i, 2, 'did not find 3');
  }

  function findIndexFromWithArgPredicate(
    MemoryPointer _element,
    MemoryPointer _argPtr
  ) internal pure returns (bool) {
    uint element = MemoryPointer.unwrap(_element);
    uint arg = _argPtr.readUint256();
    uint a = arg >> 128;
    uint b = arg & 0xff;
    return element == a || element == b;
  }

  // ===================================================================== //
  //               countFrom(MemoryPointer,function,uint256)               //
  // ===================================================================== //

  function test_countFrom() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    uint256 count = array.countFrom(countFromPredicate, 0);
    assertEq(getFreeMemoryPointer(), freePtr, 'should not allocate memory');
    assertEq(count, 2, 'should count 2 elements');
    assertEq(array.countFrom(countFromPredicate, 1), 2, 'should count 2 elements');
    assertEq(array.countFrom(countFromPredicate, 2), 1, 'should count 1 element');
  }

  function countFromPredicate(uint256 x) internal pure returns (bool) {
    return x > 1;
  }

  // ===================================================================== //
  //                    includes(MemoryPointer,uint256)                    //
  // ===================================================================== //

  function test_includes() external {
    MemoryPointer array = getUint256Array();
    MemoryPointer freePtr = getFreeMemoryPointer();
    bool includes = array.includes(2);
    assertEq(getFreeMemoryPointer(), freePtr, 'should not allocate memory');
    assertEq(includes, true, 'includes(2)');
    assertEq(array.includes(4), false, 'includes(4)');
  }
}
