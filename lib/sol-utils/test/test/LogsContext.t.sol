// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import 'forge-std/Test.sol';
import 'src/test/LogsContext.sol';

contract EventEmitter {
  event Transfer(address indexed sender, address indexed receiver, uint256 amount);

  function transfer(address receiver, uint256 amount) external {
    emit Transfer(msg.sender, receiver, amount);
  }
}

contract LogsContextTest is Test {
  EventEmitter internal emitter = new EventEmitter();
  event Transfer(address indexed sender, address indexed receiver, uint256 amount);

  function test_addWatchedEvent() external {
    LogsContext memory context = getLogsContextExpectingTransfer();
    assertEq(context.watchedEventSignatures.length, 1, 'watchedEvents.length != 1');
    assertEq(
      context.watchedEventSignatures[0],
      Transfer.selector,
      'watchedEvents[0].selector != Transfer.selector'
    );
    assertEq(
      context.watchedEventSignatures.length,
      context.watchedEventSerializers.length,
      'watchedEvents.length != watchedEventSerializers.length'
    );
    uint256 fnIdExpected;
    uint256 fnIdActual;
    function(Log memory) internal pure returns (string memory) fn = serializeTransfer;
    assembly {
      fnIdExpected := fn
    }
    fn = context.watchedEventSerializers[0];
    assembly {
      fnIdActual := fn
    }
    assertEq(fnIdActual, fnIdExpected, 'watchedEvents[0].serializeLog != serializeTransfer');
    assertEq(
      context.watchedEventSignatures[0],
      keccak256('Transfer(address,address,uint256)'),
      "watchedEvents[0].selector != keccak256('Transfer(address,address,uint256)')"
    );
  }

  function getLogsContextExpectingTransfer() internal returns (LogsContext memory) {
    LogsContext memory context;
    context.addWatchedEvent(Transfer.selector, serializeTransfer);
    context.startRecording();
    emit Transfer(address(this), address(1), 1000);
    context.expectRecordedLogs(address(emitter));
    return context;
  }

  function serializeTransfer(Log memory log) internal pure returns (string memory) {}

  function checkTransferLog(
    Log memory log,
    address token,
    address from,
    address to,
    uint256 amount
  ) internal {
    assertEq(log.emitter, token);
    assertEq(log.topics.length, 3);
    assertEq(log.topics[0], Transfer.selector);
    assertEq(log.topics[1], bytes32(uint256(uint160(from))));
    assertEq(log.topics[2], bytes32(uint256(uint160(to))));
    assertEq(log.data, abi.encodePacked(amount));
  }

  function test_expectRecordedLogs() external {
    LogsContext memory context = getLogsContextExpectingTransfer();
    assertEq(
      context.expectedLogHashes.length,
      context.expectedLogs.length,
      'expectedLogHashes.length != expectedLogs.length'
    );
    assertEq(context.expectedLogHashes.length, 1, 'expectedLogHashes.length != 1');
    Log memory log = context.expectedLogs[0];
    assertEq(log.hashLog(), context.expectedLogHashes[0], 'log.hashLog() != expectedLogHashes[0]');
    checkTransferLog(log, address(emitter), address(this), address(1), 1000);
  }

  function checkExpectedEvents(
    bool isRecording,
    Log[] memory expectedLogs,
    bytes32[] memory expectedLogHashes,
    Log[] memory emittedLogs,
    bytes32[] memory emittedLogHashes
  ) external {
    LogsContext memory context;
    context.isRecording = isRecording;
    context.expectedLogs = expectedLogs;
    context.expectedLogHashes = expectedLogHashes;
    context.emittedLogs = emittedLogs;
    context.emittedLogHashes = emittedLogHashes;
    context.addWatchedEvent(Transfer.selector, serializeTransfer);
    context.checkExpectedEvents();
  }

  function test_checkExpectedEvents_ExpectedLogNotFound() external {
    LogsContext memory context = getLogsContextExpectingTransfer();
    vm.expectRevert(LibLogsContext.ExpectedLogNotFound.selector);
    this.checkExpectedEvents(
      context.isRecording,
      context.expectedLogs,
      context.expectedLogHashes,
      context.emittedLogs,
      context.emittedLogHashes
    );
  }

  function test_checkExpectedEvents_LogHashDoesNotMatch() external {
    LogsContext memory context = getLogsContextExpectingTransfer();
    context.startRecording();
    emitter.transfer(address(1), 1001);
    vm.expectRevert(LibLogsContext.LogHashDoesNotMatch.selector);
    this.checkExpectedEvents(
      context.isRecording,
      context.expectedLogs,
      context.expectedLogHashes,
      context.emittedLogs,
      context.emittedLogHashes
    );
  }

  function test_checkExpectedEvents_MoreWatchedEventsThanExpected() external {
    LogsContext memory context = getLogsContextExpectingTransfer();
    context.startRecording();
    emitter.transfer(address(1), 1000);
    emitter.transfer(address(1), 1000);
    vm.expectRevert(LibLogsContext.MoreWatchedEventsThanExpected.selector);
    this.checkExpectedEvents(
      context.isRecording,
      context.expectedLogs,
      context.expectedLogHashes,
      context.emittedLogs,
      context.emittedLogHashes
    );
  }

  function test_checkExpectedEvents() external {
    LogsContext memory context = getLogsContextExpectingTransfer();
    context.startRecording();
    emitter.transfer(address(1), 1000);
    context.checkExpectedEvents();
    assertEq(context.emittedLogHashes.length, 1, 'emittedLogHashes.length != 1');
    assertEq(
      context.emittedLogHashes.length,
      context.emittedLogs.length,
      'emittedLogHashes.length != emittedLogs.length'
    );
    Log memory log = context.emittedLogs[0];
    checkTransferLog(log, address(emitter), address(this), address(1), 1000);
  }
}
