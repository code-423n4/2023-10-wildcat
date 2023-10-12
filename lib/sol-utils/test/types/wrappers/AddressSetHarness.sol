// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import 'src/types/EnumerableSet.sol';
import 'openzeppelin/contracts/utils/structs/EnumerableSet.sol';

contract AddressSetHarness {
  AddressSet internal _set;

  function indexOf(address value) external view returns (uint256 index) {
    return _set.indexOf(value);
  }

  function length() external view returns (uint256 _length) {
    return _set.length();
  }

  function at(uint256 index) external view returns (address value) {
    return _set.at(index);
  }

  function contains(address value) external view returns (bool) {
    return _set.contains(value);
  }

  function add(address value) external returns (bool result) {
    return _set.add(value);
  }

  function remove(address value) external returns (bool) {
    return _set.remove(value);
  }

  function values() external view returns (address[] memory arr) {
    return _set.values();
  }

  function internalValues() external view returns (address[] memory arr) {
    return _set._values;
  }

  function slice(uint256 start, uint256 end) external view returns (address[] memory arr) {
    return _set.slice(start, end);
  }
}

contract AddressSetHarnessOZ {
  using EnumerableSet for EnumerableSet.AddressSet;

  EnumerableSet.AddressSet private _set;

  function indexOf(address value) public view returns (uint256) {
    return _set._inner._indexes[bytes32(uint256(uint160(value)))];
  }

  function length() public view returns (uint256) {
    return _set.length();
  }

  function at(uint256 index) public view returns (address) {
    return _set.at(index);
  }

  function contains(address value) public view returns (bool) {
    return _set.contains(value);
  }

  function add(address value) public returns (bool) {
    return _set.add(value);
  }

  function remove(address value) public returns (bool) {
    return _set.remove(value);
  }

  function values() public view returns (address[] memory) {
    return _set.values();
  }

  function internalValues() external view returns (address[] memory arr) {
    bytes32[] memory _arr = _set._inner._values;
    assembly {
      arr := _arr
    }
  }

  function slice(uint256 start, uint256 end) external view returns (address[] memory arr) {
    uint256 len = _set.length();
    end = min(end, len);
    uint256 size = end - start;
    arr = new address[](size);
    for (uint256 i = 0; i < size; ) {
      arr[i] = _set.at(start + i);
      unchecked {
        i++;
      }
    }
  }
}
