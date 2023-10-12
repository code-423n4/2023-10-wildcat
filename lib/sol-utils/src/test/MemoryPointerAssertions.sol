// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import { StdAssertions } from 'forge-std/StdAssertions.sol';
import '../ir-only/MemoryPointer.sol';

contract MemoryPointerAssertions is StdAssertions {
  function assertEq(MemoryPointer a, MemoryPointer b) internal {
    assertEq(MemoryPointer.unwrap(a), MemoryPointer.unwrap(b));
  }

  function assertEq(MemoryPointer a, MemoryPointer b, string memory str) internal {
    assertEq(MemoryPointer.unwrap(a), MemoryPointer.unwrap(b), str);
  }

  uint constant OnlyFullWordMask = 0xffffffe0;

  function toBytes(MemoryPointer ptr, uint256 length) internal returns (bytes memory result) {
    // Derive the size of the bytes array, rounding up to nearest word
    // and adding a word for the length field.
    uint256 size = ((length + 0x1f) & OnlyFullWordMask) + 0x20;
    MemoryPointer out = malloc(size);
    out.write(length);
    ptr.copy(out.next(), length);
    assembly {
      result := out
    }
  }

  function assertBufferEq(MemoryPointer a, MemoryPointer b, uint256 length) internal {
    if (a.hash(length) != b.hash(length)) {
      emit log('Error: a == b not satisfied [bytes]');
      emit log_named_bytes('      Left', toBytes(a, length));
      emit log_named_bytes('     Right', toBytes(b, length));
      fail();
    }
  }

  function assertBufferEq(
    MemoryPointer a,
    MemoryPointer b,
    uint256 length,
    string memory err
  ) internal {
    if (a.hash(length) != b.hash(length)) {
      emit log_named_string('Error', err);
      assertBufferEq(a, b, length);
    }
  }
}
