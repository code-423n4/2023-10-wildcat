// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import 'src/types/EnumerableSet.sol';
import 'openzeppelin/contracts/utils/structs/EnumerableSet.sol';

contract Bytes32SetHarness {
  Bytes32Set internal _set;

  function indexOf(bytes32 value) external view returns (uint256 index) {
    return _set.indexOf(value);
  }

  function length() external view returns (uint256 _length) {
    return _set.length();
  }

  function at(uint256 index) external view returns (bytes32 value) {
    return _set.at(index);
  }

  function contains(bytes32 value) external view returns (bool) {
    return _set.contains(value);
  }

  function add(bytes32 value) external returns (bool result) {
    return _set.add(value);
  }

  function remove(bytes32 value) external returns (bool) {
    return _set.remove(value);
  }

  function values() external view returns (bytes32[] memory arr) {
    return _set.values();
  }

  function slice(uint256 start, uint256 end) external view returns (bytes32[] memory arr) {
    return _set.slice(start, end);
  }
}

contract Bytes32SetHarnessOZ {
  using EnumerableSet for EnumerableSet.Bytes32Set;

  EnumerableSet.Bytes32Set private _set;

  function indexOf(bytes32 value) public view returns (uint256) {
    return _set._inner._indexes[value];
  }

  function length() public view returns (uint256) {
    return _set.length();
  }

  function at(uint256 index) public view returns (bytes32) {
    return _set.at(index);
  }

  function contains(bytes32 value) public view returns (bool) {
    return _set.contains(value);
  }

  function add(bytes32 value) public returns (bool) {
    return _set.add(value);
  }

  function remove(bytes32 value) public returns (bool) {
    return _set.remove(value);
  }

  function values() public view returns (bytes32[] memory) {
    return _set.values();
  }

  function slice(uint256 start, uint256 end) external view returns (bytes32[] memory arr) {
    uint256 len = _set.length();
    end = min(end, len);
    uint256 size = end - start;
    arr = new bytes32[](size);
    for (uint256 i = 0; i < size; ) {
      arr[i] = _set.at(start + i);
      unchecked {
        i++;
      }
    }
  }
}
