// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Vm, VmSafe } from 'forge-std/Vm.sol';

address constant VM_ADDRESS = address(uint160(uint256(keccak256('hevm cheat code'))));
Vm constant vm = Vm(VM_ADDRESS);
