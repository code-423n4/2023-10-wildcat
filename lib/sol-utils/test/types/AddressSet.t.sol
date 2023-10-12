// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import 'forge-std/Test.sol';
import './wrappers/AddressSetHarness.sol';

address constant ValueA = 0xdEADBEeF00000000000000000000000000000000;
address constant ValueB = 0x0123456789000000000000000000000000000000;
address constant ValueC = 0x4242424200000000000000000000000000000000;

abstract contract BaseEnumerableSetTest is Test {
  ISet internal _set;
  bytes internal ArrayOutOfBoundsError =
    abi.encodePacked(bytes4(bytes32(Panic_ErrorSelector << 224)), Panic_ArrayOutOfBounds);
  bytes internal ArithmeticError =
    abi.encodePacked(bytes4(bytes32(Panic_ErrorSelector << 224)), Panic_Arithmetic);

  function membersMatch(address[] memory values) internal {
    assertEq(_set.length(), values.length);
    for (uint256 i; i < values.length; i++) {
      assertTrue(_set.contains(values[i]));
      assertEq(_set.at(i), values[i]);
      assertEq(_set.indexOf(values[i]), i + 1);
    }
    assertEq(_set.values(), values);
    assertEq(_set.internalValues(), values);
  }

  function testStartsEmpty() external {
    assertFalse(_set.contains(ValueA));
    membersMatch(new address[](0));
  }

  function testAddOneValue() external {
    assertTrue(_set.add(ValueA));
    address[] memory arr = new address[](1);
    arr[0] = ValueA;
    membersMatch(arr);
  }

  function testAddTwoValues() external {
    assertTrue(_set.add(ValueA));
    assertTrue(_set.add(ValueB));
    address[] memory arr = new address[](2);
    arr[0] = ValueA;
    arr[1] = ValueB;
    membersMatch(arr);
    assertFalse(_set.contains(ValueC));
  }

  function testAddExistingValue() external {
    assertTrue(_set.add(ValueA));
    assertFalse(_set.add(ValueA));
  }

  function testAtRevertsForNonExistentElements() external {
    vm.expectRevert(ArrayOutOfBoundsError);
    _set.at(0);
  }

  function testRemoveOneValue() external {
    assertTrue(_set.add(ValueA));
    assertTrue(_set.remove(ValueA));
    membersMatch(new address[](0));
    assertFalse(_set.contains(ValueA));
  }

  function testRemoveNonExistentValue() external {
    assertFalse(_set.remove(ValueA), 'remove nonexistent not false');
  }

  function testAddAndRemoveMultipleValues() external {
    // []

    assertTrue(_set.add(ValueA));
    assertTrue(_set.add(ValueC));
    // [A, C]

    assertTrue(_set.remove(ValueA));
    assertFalse(_set.remove(ValueB));
    // [C]

    assertTrue(_set.add(ValueB));
    // [C, B]

    assertTrue(_set.add(ValueA));
    // [C, B, A]

    assertTrue(_set.remove(ValueC));
    // [A, B]

    assertFalse(_set.add(ValueA));
    assertFalse(_set.add(ValueB));
    // [A, B]

    assertTrue(_set.add(ValueC));
    // [A, B, C]

    assertTrue(_set.remove(ValueA));
    // [C, B]

    assertTrue(_set.add(ValueA));
    // [C, B, A]

    assertTrue(_set.remove(ValueB));

    // [C, A]

    address[] memory arr = new address[](2);
    arr[0] = ValueC;
    arr[1] = ValueA;
    membersMatch(arr);

    assertFalse(_set.contains(ValueB));
  }

  function testSlice() external {
    _set.add(ValueA);
    _set.add(ValueB);
    _set.add(ValueC);
    vm.expectRevert(ArithmeticError);
    _set.slice(4, 1);
    address[] memory arr = new address[](3);
    arr[0] = ValueA;
    arr[1] = ValueB;
    arr[2] = ValueC;
    assertEq(_set.slice(0, 3), arr);
    assertEq(_set.slice(0, 4), arr);
    assertEq(_set.slice(0, 0), new address[](0));
    assertEq(_set.slice(1, 1), new address[](0));
    assembly {
      mstore(arr, 2)
    }
    assertEq(_set.slice(0, 2), arr);
    arr[0] = ValueB;
    arr[1] = ValueC;
    assertEq(_set.slice(1, 3), arr);
  }
}

contract EnumerableSetTest is BaseEnumerableSetTest {
  function setUp() external {
    _set = ISet(address(new AddressSetHarness()));
  }
}

contract OZEnumerableSetTest is BaseEnumerableSetTest {
  function setUp() external {
    _set = ISet(address(new AddressSetHarnessOZ()));
  }
}

interface ISet {
  function indexOf(address value) external view returns (uint256);

  function length() external view returns (uint256);

  function at(uint256 index) external view returns (address);

  function contains(address value) external view returns (bool);

  function add(address value) external returns (bool);

  function remove(address value) external returns (bool);

  function values() external view returns (address[] memory);

  function internalValues() external view returns (address[] memory);

  function slice(uint256 start, uint256 end) external view returns (address[] memory);
}
