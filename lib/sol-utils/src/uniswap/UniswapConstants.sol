// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// =====================================================================//
//        IUniswapV2Pair.swap(uint256, uint256, address, bytes)         //
// =====================================================================//

// ==================================================================
// | Start | End | Size | Description                               |
// ==================================================================
// |     0 |  64 |   64 | Scratch space for hashing and returndata  |
// |    64 |  96 |   32 | Allocated memory size                     |
// |    96 | 100 |    4 | Allocated memory size                     |
// |   100 | 132 |   32 | Function selector for IUniswapV2Pair.swap |
// |   132 | 164 |   32 | `amount0Out`                              |
// |   164 | 196 |   32 | `amount1Out`                              |
// |   196 | 228 |   32 | `recipient`                               |
// |   228 | 260 |   32 | offset to `data.length`                   |
// |   260 | 292 |   32 | `data.length`                             |
// ==================================================================

// =====================================================================//
//                 swap(uint256,uint256,address,bytes)                  //
// =====================================================================//

uint256 constant UniswapV2_Swap_Selector = 0x022c0d9f;

uint256 constant UniswapV2_Swap_Calldata_Offset = 0x1c;
uint256 constant UniswapV2_Swap_Calldata_Size = 0xa4;

uint256 constant UniswapV2_Swap_Selector_Offset = 0x00;
uint256 constant UniswapV2_Swap_Amount0Out_Offset = 0x20;
uint256 constant UniswapV2_Swap_Amount1Out_Offset = 0x40;
uint256 constant UniswapV2_Swap_Recipient_Offset = 0x60;
uint256 constant UniswapV2_Swap_Data_Head_Offset = 0x80;
uint256 constant UniswapV2_Swap_Data_Length_Offset = 0x0104;

// =====================================================================//
//                              sync()                                  //
// =====================================================================//

uint256 constant UniswapV2_Sync_Selector = 0xfff6cae9;
uint256 constant UniswapV2_Sync_Calldata_Pointer = 0x1c;
uint256 constant UniswapV2_Sync_Calldata_Size = 0x04;
uint256 constant UniswapV2_Sync_Selector_Pointer = 0x00;

// =====================================================================//
//                            mint(address)                             //
// =====================================================================//

uint256 constant UniswapV2_Mint_Selector = 0x6a627842;

uint256 constant UniswapV2_Mint_Calldata_Pointer = 0x1c;
uint256 constant UniswapV2_Mint_Calldata_Size = 0x24;

uint256 constant UniswapV2_Mint_Returndata_Pointer = 0x00;
uint256 constant UniswapV2_Mint_Returndata_Size = 0x20;

uint256 constant UniswapV2_Mint_Selector_Pointer = 0x00;
uint256 constant UniswapV2_Mint_Recipient_Pointer = 0x20;

// =====================================================================//
//                            burn(address)                             //
// =====================================================================//

uint256 constant UniswapV2_Burn_Selector = 0x6a627842;

uint256 constant UniswapV2_Burn_Calldata_Pointer = 0x1c;
uint256 constant UniswapV2_Burn_Calldata_Size = 0x24;

uint256 constant UniswapV2_Burn_Returndata_Pointer = 0x00;
uint256 constant UniswapV2_Burn_Returndata_Size = 0x40;

uint256 constant UniswapV2_Burn_Amount0_Pointer = 0x00;
uint256 constant UniswapV2_Burn_Amount1_Pointer = 0x20;

uint256 constant UniswapV2_Burn_Selector_Pointer = 0x00;
uint256 constant UniswapV2_Burn_Recipient_Pointer = 0x20;

// =====================================================================//
//                    getReserves()                                     //
// =====================================================================//

uint256 constant UniswapV2_GetReserves_Selector = 0x0902f1ac;

uint256 constant UniswapV2_GetReserves_Calldata_Pointer = 0x1c;
uint256 constant UniswapV2_GetReserves_Calldata_Size = 0x04;

uint256 constant UniswapV2_GetReserves_Selector_Pointer = 0;
uint256 constant UniswapV2_GetReserves_Returndata_Reserves0_Pointer = 0x00;
uint256 constant UniswapV2_GetReserves_Returndata_Reserves1_Pointer = 0x20;
uint256 constant UniswapV2_GetReserves_Returndata_Size = 0x40;

uint256 constant UniswapV2_Create2Prefix = (
  0x0000000000000000000000ff5c69bee701ef814a2b6a3edd4b1652cb9cc5aa6f
); // 0xff + factory address
uint256 constant UniswapV2_InitCodeHash = (
  0x96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f
);

uint256 constant Sushiswap_Create2Prefix = (
  0x0000000000000000000000ffc0aee478e3658e2610c5f7a4a2e1777ce9e4f2ac
); // 0xff + factory address
uint256 constant Sushiswap_InitCodeHash = (
  0xe18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303
);

uint256 constant UniswapV3_Create2Prefix = (
  0x0000000000000000000000ff1f98431c8ad98523631ae4a59f267346ea31f984
); // 0xff + factory address
uint256 constant UniswapV3_InitCodeHash = (
  0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54
);

uint256 constant BaseSwap_Create2Prefix = (
  0x0000000000000000000000fffda619b6d20975be80a10332cd39b9a4b0faa8bb
); // 0xff + factory address
uint256 constant BaseSwap_InitCodeHash = (
  0xb618a2730fae167f5f8ac7bd659dd8436d571872655bcb6fd11f2158c8a64a3b
);

uint256 constant QuickSwap_Create2Prefix = (
  0x0000000000000000000000ff5757371414417b8c6caad45baef941abc7d3ab32
); // 0xff + factory address
uint256 constant QuickSwap_InitCodeHash = UniswapV2_InitCodeHash;

uint256 constant Create2_Prefix_Offset = 0x00;
uint256 constant Create2_Salt_Offset = 0x20;
uint256 constant Create2_InitCodeHash_Offset = 0x40;
uint256 constant Create2_Offset = 0x0b;
uint256 constant Create2_Size = 0x55;

// Memory position to write token1 when calculating pair hash
uint256 constant V2_pairSalt_Token1_WriteOffset = 0x14;
uint256 constant V2_pairSalt_Token0_WriteOffset = 0x00;
uint256 constant V2_pairSalt_Offset = 0x0c;
uint256 constant V2_pairSalt_Size = 0x28;

uint256 constant V3_pairSalt_Token0_WriteOffset = 0x00;
// Memory position to write token1 when calculating pair hash
uint256 constant V3_pairSalt_Token1_WriteOffset = 0x20;
// Memory position to write fee when calculating pair hash
uint256 constant V3_pairSalt_Fee_WriteOffset = 0x40;
uint256 constant V3_pairSalt_Offset = 0x00;
uint256 constant V3_pairSalt_Size = 0x60;
