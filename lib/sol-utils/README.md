## `ir-only`

The `ir-only` subdirectory contains libraries which are designed for use with solc's ir pipeline and will not be gas efficient without `viaIR` and optimization enabled. This is largely due to the use of internal functions which are expected to be inlined by the compiler.

## `non-ir-only`

The `non-ir-only` subdirectory contains libraries which are designed for use without solc's ir pipeline and will not be gas efficient when `viaIR` is enabled. This is mostly relevant for jump tables, as the ir pipeline causes internal functions to be represented as sequential identifiers (with switch statements for function calls) rather than jumpdests.

## `uniswap`

The `uniswap` subdirectory contains libraries for interacting with and making calculations for Uniswap, primarily V2.

## `test`

The `test` subdirectory contains libraries that help with contract testing.
