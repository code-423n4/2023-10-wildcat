
# The Wildcat Protocol

Greetings, everyone! It's time to take our money!

[![The Wildcat Protocol](https://github.com/code-423n4/2023-10-wildcat/blob/main/images/wildcat_logo_strapline.png?raw=true)](https://github.com/code-423n4/2023-10-wildcat)

---

# Audit Prize Pool Details

| Category | Amount |
| ----------- | ----------- |
| **Total Pool** | **$60,500 USDC** |
| HM Awards | $41,250 USDC |
| Analysis Awards | $2,500 USDC |
| QA Awards | $1,250 USDC |
| Bot Race Awards | $3,750 USDC |
| Gas Awards | $1,250 USDC |
| Judge Awards | $6,000 USDC |
| Lookout Awards | $4,000 USDC |
| Scout Awards | $500 USDC |


- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2023-10-the-wildcat/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts October 16, 2023 20:00 UTC 
- Ends October 26, 2023 20:00 UTC 

---

## Automated Findings / Publicly Known Issues

Automated findings output for the audit can be found [here](https://github.com/code-423n4/2023-10-wildcat/blob/main/bot-report.md) within 24 hours of audit opening.

*Note for C4 wardens: Anything included in the automated findings output is considered a publicly known issue and is ineligible for awards.*

---

# Overview

### The Pitch

The Wildcat Protocol is an as-yet-unreleased protocol launching on Ethereum mainnet that addresses what we see as blockers in the sphere of on-chain fixed-rate private credit.

If you're interested in the _how_ and _why_ at a high-level, the following may be of interest to you:
- [Whitepaper](https://github.com/wildcat-finance/wildcat-whitepaper/blob/main/whitepaper_v0.2.pdf)
- [Manifesto](https://medium.com/@wildcatprotocol/the-wildcat-manifesto-db23d4b9484d)

Wildcat's primary offering is _markets_. You could also call them _vaults_ (and sometimes we're inconsistent and call them both). They're credit escrow mechanisms where nearly
every single parameter that you'd be interested in modifying can be modified at launch. Subsequent to launch, base APR and capacities can be adjusted by the borrower at will, with
some caveats on reducing the former that effectively constitutes a ragequit option for lenders if they disagree with the change.

Wildcat inverts the typical on-chain credit model whereby borrowers appeal to an existing pool of lenders willing to loan their assets. Instead, a Wildcat borrower is required
to create a market for a particular asset, offer a particular rate, and specify the desired lender addresses explicitly - in this iteration of the protocol at least - before
credit in that asset can be obtained. This means that we are expecting there to be an existing relationship between counterparties.

We handle collateralisation a bit strangely. The borrower is not required to put any collateral down themselves when deploying a market, but rather there is a percentage of
the supply, the reserve ratio, that _must_ remain within the market. The borrower cannot utilise these assets, but they still accrue interest. This is intended as a liquid buffer for
lenders to place withdrawal requests against, and the failure of the borrower to maintain this ratio (by repaying assets to the market when the ratio is breached) ultimately results
in an additional penalty interest rate being applied. If you're wondering, 'wait, does that mean that lenders are collateralising their own loans?', the answer is _yes, they absolutely are_.

Of course, it doesn't matter what penalty rate is in place if your borrower counterparty has simply vanished off the face of the Earth, or decided that they wanted to perform a
tribute act to Alameda Research. It is important then to emphasise that there are _no underwriters_ and _no insurance funds_ for Wildcat markets. The protocol itself is entirely
hands-off when it comes to any given market. It has no ability to freeze borrower collateral (since it's technically the lenders in the first place), and it can't pause activity.
More generally, and as an ideological choice, the protocol utilises no proxies. If you lose keys, or burn market tokens, or if anything else goes wrong - the protocol cannot help you.

The protocol does monitor for addresses that are flagged by the Chainalysis oracle as being placed on a sanctions list and bar them from interacting with markets if this happens:
simply because strict liability on interfacing with these addresses means that they'd otherwise poison everyone else. That's the extent of the guardrails.

Given the above, it should be emphasised: this is not a protocol aimed at retail users. Heck, it's barely aimed at power users. The counterparty default risk is real, the smart
contract risk is real. Wildcat is a tool for sophisticated entities who wish to bring credit agreements on-chain in a manner that does not involve surrendering any control to third
parties in matters such as underwriting, risk analysis or credit scoring. If you want that freedom, Wildcat _might_ be for you.

If counterparties are utilising the protocol UI, we require a borrower to sign a master loan agreement setting out various covenants, representations and definitions of default,
with jurisdiction for any conflict that arises being placed within the UK courts. Lenders can countersign this agreement or decline: perhaps there is another agreement in place
between the two parties already. We provide this document/mechanism as an offering to any lenders who want clarity on what process to follow in the event of a failure on behalf of
the borrower to repay what is owed.

### A More Technical Briefing

The Wildcat protocol itself coalesces around a single contract - the archcontroller. This contract determines which factories can be used, which markets have already been deployed
and which addresses are permitted to deploy contracts from said factories.

Borrowers deploy markets through _controllers_ - contracts that dictate logic, define the set of permissible lenders and constrain minimum and maximum values of market parameters
(the freedom we offer is not completely unbounded - you can't have a market with a years-long withdrawal cycle, for example). Multiple markets can be deployed through a single controller,
with the implication that a single list of lenders can be used to grant access to multiple markets simultaneously.

Lenders that are authorised on a given controller (i.e. granted a role) can deposit assets to any markets that have been launched through it. In exchange for their deposits, they receive a _market token_ which has been parameterised by the borrower: you might receive Code4rena Dai Stablecoin - ticker C4DAI - for depositing DAI into a market run by Code4rena. Or C4 Wrapped Ether (CODE423N4WETH).

These market tokens are _rebasing_ so as to always be redeemable at parity for the underlying asset of a market (provided it has sufficient reserves) - as time goes on, interest inflates the supply of market tokens
to be consistent with the overall debt that is owed by the borrower. The interest rate compounds every time a non-static call is made to the market contract and the scale factor is updated.

The interest rate paid by the borrower can comprise of up to three distinct figures:

  - The base APR (accruing to the lender, expressed in bips when a market is deployed),
  - The protocol APR (accruing to the Wildcat protocol itself, expressed as a percentage of the base APR), and
  - The penalty APR (accruing to the lender, expressed in bips when a market is deployed).

A borrower deploying a market with a base APR of 10%, a protocol APR of 30% and a penalty APR of 20% will pay a true APR of 13% (10% + (10% * 30%)) under normal circumstances, and 33% when the market has been delinquent for long enough for the penalty APR to activate.

The penalty APR activates when the market has been delinquent (below its reserve ratio) for a rolling period of time in excess of the _grace period_ - a value (in seconds) defined by the borrower on market deployment. Each market has an internal value called the _grace tracker_, which counts up from zero while a market is delinquent, and counts down to zero when it is not. When the grace tracker value exceeds the grace period, the penalty APR applies for as long as it takes for the former to drop back below the latter. This means that a borrower does _not_ have  the amount of time indicated by the grace period to deposit assets back into the market each time it goes delinquent.

Borrowers can withdraw underlying assets from the market only so far as the reserve ratio is maintained.

Withdrawals are initiated by any address that holds the `WithdrawOnly` or `DepositAndWithdraw` roles (and a non-zero amount of the appropriate market token) placing a withdrawal request. If there are any assets in reserve, market tokens will be burned 1:1 to move them into a 'claimable withdrawals pool', at which point the assets transferred will cease accruing interest. At the conclusion of a withdrawal cycle (a market parameter set at deployment), assets in the claimable withdrawals pool can be claimed by the lender, subject to pro-rata dispersal if the amount requested for withdrawal by all lenders exceeds the amount in the pool.

Withdrawal request amounts that could not be honoured in a given cycle because of insufficient reserves are batched together, marked as 'expired' and enter a FIFO withdrawal queue. Non-zero withdrawal queues impact the reserve ratio of a market: any assets subsequently deposited by the borrower will be immediately routed into the claimable withdrawals pool until there are sufficient assets to fully honour all expired withdrawals. Any amounts in the claimable withdrawals pool that lender/s did not burn market tokens for will need to have them burned before claiming from here. We track any discrepancies between how much was burned and how much should be claimable internally.

Lenders that have their addresses flagged by Chainalysis as being sanctioned are blocked from interacting with any markets that they are a part of by giving them a role of `Blocked`. A `nukeFromOrbit` function exists that directs their market balances into a purpose-deployed escrow contract. Lenders can retrieve their assets from these escrow contracts in the event that they are ever removed from the oracle, (i.e. their address returns `false` when `isSanctioned(borrower, account)` is queried), or if the borrower for the relevant market manually overrides their sanctioned status.

This is getting long and rambling, so instead we'll direct you to the [Gitbook](https://wildcat-protocol.gitbook.io) which is even more so, but at least lays out the expected behaviour in prose.

Sorry for subjecting you to all of this. You can go look at the code now.

---

## Links

- **Previous Audits:** [Security review of market logic](https://hackmd.io/@geistermeister/r15gj_y1p) by [alpeh_v](https://x.com/alpeh_v)
- **Documentation:** [Gitbook](https://wildcat-protocol.gitbook.io) 
- **Website:**: N/A [Still building things out!]
- **Twitter:**: [@WildcatFi](https://x.com/WildcatFi)  

---

# In Scope

*Files and contracts in scope for this audit in the table below:*

| Contract | SLOC | Purpose | Libraries Used |  
| ----------- | ----------- | ----------- | ----------- |
| [src/WildcatVaultController.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/WildcatVaultController.sol) | 363 |  Deploys markets and manages their configurable parameters (APR, reserve ratio) and maintains set of approved lenders. | [`@openzeppelin/EnumerableSet`](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol), [`@solady/Ownable`](https://github.com/Vectorized/solady/blob/main/src/auth/Ownable.sol), [`@solady/SafeTransferLib`](https://github.com/Vectorized/solady/blob/main/src/utils/SafeTransferLib.sol) |
| [src/market/WildcatMarketBase.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/market/WildcatMarketBase.sol) | 311 | Base contract for Wildcat markets. |  |
| [src/WildcatVaultControllerFactory.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/WildcatVaultControllerFactory.sol) | 247 | Deploys controllers and manages protocol fee information. | [`@openzeppelin/EnumerableSet`](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol) |
| [src/WildcatArchController.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/WildcatArchController.sol) | 176 | Registry for borrowers, controller factories, controllers and markets. | [`@openzeppelin/EnumerableSet`](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol) |
| [src/market/WildcatMarketWithdrawals.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/market/WildcatMarketWithdrawals.sol) | 136 | Withdrawal functionality for Wildcat markets. | [`@solady/SafeTransferLib`](https://github.com/Vectorized/solady/blob/main/src/utils/SafeTransferLib.sol) |
| [src/libraries/MathUtils.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/libraries/MathUtils.sol) | 110 | Generic math functions used in the codebase. |  |
| [src/libraries/SafeCastLib.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/libraries/SafeCastLib.sol) | 106 | `uint` cast functions. |  |
| [src/libraries/FeeMath.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/libraries/FeeMath.sol) | 97 | Contains functions for calculating interest, protocol fees and delinquency fees. |  |
| [src/market/WildcatMarketConfig.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/market/WildcatMarketConfig.sol) | 95 |  Methods for role management and configuration by controller. | |
| [src/libraries/StringQuery.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/libraries/StringQuery.sol) | 93 | Helper functions for querying strings from methods that can return either `string` or `bytes32`. | [`@solady/LibBit`](https://github.com/Vectorized/solady/blob/main/src/utils/LibBit.sol) |
| [src/market/WildcatMarket.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/market/WildcatMarket.sol) | 91 | Main contract for Wildcat markets that inherits all base contracts. | [`@solady/SafeTransferLib`](https://github.com/Vectorized/solady/blob/main/src/utils/SafeTransferLib.sol) |
| [src/libraries/VaultState.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/libraries/VaultState.sol) | 83 | Defines the market state struct and helper functions for reading from it and calculating basic values like required reserves and scaling/normalizing balances.  |  |
| [src/WildcatSanctionsSentinel.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/WildcatSanctionsSentinel.sol) | 75 | Contract that interfaces with Chainalysis, allows borrowers to override lenders' sanction statuses and deploys escrows. |  |
| [src/libraries/LibStoredInitCode.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/libraries/LibStoredInitCode.sol) | 68 | Library for deploying contracts using code storage for init code to prevent oversized contracts. |  |
| [src/libraries/FIFOQueue.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/libraries/FIFOQueue.sol) | 62 | First-in-first-out queue used for unpaid withdrawal batches. |  |
| [src/market/WildcatMarketToken.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/market/WildcatMarketToken.sol) | 54 | ERC20 functionality for Wildcat markets. |  |
| [src/libraries/Errors.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/libraries/Errors.sol) | 41 | Helper functions and constants for errors and Solidity panic codes. |  |
| [src/libraries/Withdrawal.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/libraries/Withdrawal.sol) | 37 | Defines withdrawal state struct. |  |
| [src/ReentrancyGuard.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/ReentrancyGuard.sol) | 33 | Reentrancy guard from Seaport. |  |
| [src/WildcatSanctionsEscrow.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/WildcatSanctionsEscrow.sol) | 31 | Escrow contract that holds assets for a particular account until it is removed from the Chainalysis sanctions list or until the borrower overrides the account's sanction status. | |
| [src/libraries/BoolUtils.sol](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/libraries/BoolUtils.sol) | 18 | Helpers for booleans.  |  |
| [src/libraries/Chainalysis.sol ](https://github.com/code-423n4/2023-10-wildcat/blob/main/src/libraries/Chainalysis.sol) | 5 | Constant for Chainalysis SanctionsList. |  |

## Out Of Scope

*Files and contracts that are out of scope for this audit:*

- `src/interfaces/*`

---

# Additional Context

- We anticipate that any ERC-20 can be used as an underlying asset for a market. However we make the following assumptions:

  - There are no fees on transfer.
  - The `totalSupply` is nowhere near 2^128.
  - Arbitrary mints and burns are not possible.
  - `name`, `symbol` and `decimals` all return valid results.
 
- This code will be deployed to Ethereum mainnet at launch, and it is the only blockchain considered to be in scope for this audit.

- We do not anticipate interacting with any ERC-721s.

- We do not consider a DOS of the Ethereum network to be sufficient to warrant a finding valid, even in such scenarios as a DOS preventing a borrower from depositing assets for long enough to exceed the grace period and activate the penalty APR of a market.

- No implementations are intended to conform with any EIPs.

- Rounding errors:
  - Conversion between scaled and normalized balances inherently incurs some rounding error; we consider rounding errors limited to "dust" (miniscule amounts left unaccounted for) out of scope unless they lead to additional unexpected behavior (e.g. if a rounding error can prevent withdrawal batches from being closed).

- Trusted roles:

  - Archcontroller Owner: can add or remove controller factories to/from the archcontroller, dictating who can deploy controllers and markets. Markets that have already been deployed cannot be shut down, and removing a borrower from the archcontroller simply prevents them from deploying anything further.
  - Borrower: can add or remove lenders to/from controllers, permitting them to deposit into markets or restricting their ability to deposit further if they have already deposited before. Lenders cannot be prevented from withdrawing unless they have been flagged by the sentinel.

---

## Attack Ideas (Where To Look For Bugs)

### Access Controls and Permissions

- Consider ways in which borrower addresses, controller factories or markets can be added to the archcontroller either without the specific approval of its owner or as a result of contract deployment.
- Consider ways in which lenders can be authorised on a controller without the specific permission of the borrower that deployed it.
- Consider ways in which where the access roles for market interactions can be maliciously altered to either block or elevant parties outside of the defined flow.
- Consider ways in which removing access (borrowers from the archcontroller, lenders from controllers) can lead to the inability to interact correctly with markets.

### Market Parameters

- Consider ways in which market interest rates can be manipulated to produce results that are outside of controller-specific limits
- Consider ways in which the reserve ratio of a market can be manipulated so as to lead to the borrower borrowing more than they should be permitted.

### Penalty APR

- Consider ways in which the borrower can manipulate reserves or base APRs in a way to avoid the penalty rate activating if delinquent for longer then the grace period.

### Deposits and Withdrawals

- Consider ways in which deposits might cause trouble with internal market accounting.
- Consider ways in which lenders making withdrawal requests might have them (be they either pending or expired) altered.
- Consider ways in which market tokens can be burned but incorrect amounts of assets are claimable (this is _very_ nuanced and circumstance specific).
- Consider ways in which the order of expired batches can be manipulated to impact the withdrawal queue's FIFO nature.
- Consider ways in which a party other than the borrower of a market can borrow assets.
- Consider ways in which an address without the `WithdrawOnly` or `DepositAndWithdraw` role can burn market tokens or otherwise make withdrawal requests.

### Sentinel and Escrow Contracts

- Consider ways (beyond a hostile Chainalysis oracle) in which lender addresses could be excised from a market via `nukeFromOrbit`.
- Consider ways in which parties to an escrow contract might be locked out of it, or the escrow contract might otherwise be bricked.

---

## Main Invariants

*Properties that should NEVER be broken under any circumstance:*

- Market parameters should never be able to exit the bounds defined by the controller which deployed it.
- The supply of the market token and assets owed by the borrower should always match.
- The assets of a market should never be able to be withdrawn by anyone that is not the borrower or a lender with either the `WithdrawOnly` or `DepositAndWithdraw` role.
  - Exceptions: balances being transferred to a blocked account's escrow contract and collection of protocol fees.
- Asset deposits not made via `deposit` should not impact internal accounting (they only increase `totalAssets` and are effectively treated as a payment by the borrower).
- Addresses without the role `WithdrawOnly` or `DepositAndWithdraw` should never be able to adjust market token supply.
- Borrowers can only be registered with the archcontroller by the archcontroller owner.
- Controller factories can only be registered with the archcontroller by the archcontroller owner.
- Controllers and markets can only be deployed by borrowers currently registered with the archcontroller.
- Withdrawal execution can only transfer assets that have been counted as paid assets in the corresponding batch, i.e. lenders with withdrawal requests can not withdraw more than their pro-rata share of the batch's paid assets.
- Once claimable withdrawals have been set aside for a withdrawal batch (counted toward `normalizedUnclaimedWithdrawals` and `batch.normalizedAmountPaid`), they can only be used for that purpose (i.e. the market will always maintain at least that amount in underlying assets until lenders with a request from that batch have withdrawn the assets).
- In any non-static function which touches a market's state:
  - Prior to executing the function's logic, if time has elapsed since the last update, interest, protocol fees and delinquency fees should be accrued to the market state and pending/expired withdrawal batches should be processed.
  - At the end of the function, the updated state is written to storage and the market's delinquency status is updated.
- Assets are only paid to newer withdrawal batches if the market has sufficient assets to close older batches.
  - Exception: If protocol fees are collected between a previous batch's expiry and it being closed (fully paid), it is possible for a newer batch to reserve assets and make the older batch unpayable (see Known Issues below).
  
---

## Known Issues

The invariant above stating that earlier batches in the withdrawal queue must be honoured/executed before later ones can be violated if:
- Batch 1 is marked as unpaid and processed.
- Batch 2 is created.
- The market now has sufficient assets for both.
- Batch 2 expires and is processed / assets are reserved (because batch 1 is currently covered).
- Protocol fees are collected (only `normalizedUnclaimedWithdrawals` is subtracted from withdrawable fees).
- Now batch 1 is not fully covered.

We are aware of this issue, and will not consider it a finding.

---

## Scoping Details

```
- How many contracts are in scope?: 22
- Total SLoC for these contracts?: 2,332  
- How many external imports are there?: 4 [Solady {Ownable, LibBit, SafeTransferLib}, OpenZeppelin {EnumerableSet}]
- How many separate interfaces and struct definitions are there for the contracts within scope?: 9 interfaces, 8 structs 
- Does most of your code generally use composition or inheritance?: Inheritance   
- How many external calls?: 1 [Chainalysis]
- What is the overall line coverage percentage provided by your tests?: >90%
- Is this an upgrade of an existing system?: False
- Check all that apply (e.g. timelock, NFT, AMM, ERC20, rollups, etc.): Timelock function, ERC-20 Token 
- Is there a need to understand a separate part of the codebase / get context in order to audit this part of the protocol?: False   
- Please describe required context: N/A
- Does it use an oracle?: Yes [Chainalysis]  
- Describe any novel or unique curve logic or mathematical models your code uses: N/A 
- Is this either a fork of or an alternate implementation of another project?: N/A   
- Does it use a side-chain?: N/A
- Describe any specific areas you would like addressed: see above.
```

---

# Tests

`git clone https://github.com/code-423n4/2023-10-wildcat && cd 2023-10-wildcat && forge install` from a standing start.

`forge test --gas-report` for tests.

`yarn coverage` for coverage.
