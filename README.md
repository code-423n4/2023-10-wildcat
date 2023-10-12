
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
- Submit findings [using the C4 form](https://code4rena.com/contests/2023-10-wildcat/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts October 16, 2023 20:00 UTC 
- Ends October 26, 2023 20:00 UTC 

## Automated Findings / Publicly Known Issues

Automated findings output for the audit can be found [here](https://github.com/code-423n4/2023-10-wildcat/blob/main/bot-report.md) within 24 hours of audit opening.

*Note for C4 wardens: Anything included in the automated findings output is considered a publicly known issue and is ineligible for awards.*

# Overview

### The Ideological Pitch

The Wildcat Protocol is an as-yet-unreleased protocol launching on Ethereum mainnet that addresses what we see as blockers in the sphere of on-chain fixed-rate private credit.

If you're interested in the _how_ and _why_ at a high-level, the following may be of interest to you:
- [Whitepaper](https://github.com/wildcat-finance/wildcat-whitepaper/blob/main/whitepaper_v0.2.pdf)
- [Manifesto](https://medium.com/@wildcatprotocol/the-wildcat-manifesto-db23d4b9484d)

Wildcat inverts the typical on-chain credit model whereby borrowers appeal to an existing pool of lenders willing to loan their assets. Instead, a Wildcat borrower is required
to create a market for a particular asset, offer a particular rate, and specify the desired lender addresses explicitly - in this iteration of the protocol at least - before
credit in that asset can be obtained. This means that we are expecting there to be an existing relationship between counterparties,

There are _no underwriters_ and _no insurance funds_ for Wildcat markets. The protocol itself is entirely hands-off when it comes to any given market.

[TODO: Complete]

### A More Technical Briefing

Borrowers deploy markets through _controllers_ - quasi-factories that dictate logic, define the set of permissible lenders and constrain minimum and maximum values of market parameters.
Multiple markets can be deployed through a single controller, with the implication that a single list of lenders can be used to gate access to multiple markets simultaneously. 

[TODO: Complete]

## Links

- **Previous Audits:** [Security review of market logic](https://hackmd.io/@geistermeister/r15gj_y1p) by [alpeh_v](https://x.com/alpeh_v)
- **Documentation:**: [Gitbook](https://wildcat-protocol.gitbook.io) 
- **Website:**: N/A [Still building things out!]
- **Twitter:**: [@WildcatFi](https://x.com/WildcatFi)  

# In Scope

[ ⭐️ SPONSORS: add scoping and technical details here ]

- [ ] In the table format shown below, provide the name of each contract and:
  - [ ] source lines of code (excluding blank lines and comments) in each *For line of code counts, we recommend running prettier with a 100-character line length, and using [cloc](https://github.com/AlDanial/cloc).* 
  - [ ] external contracts called in each
  - [ ] libraries used in each

*Files and contracts in scope for this audit in the table below:*

| Contract | SLOC | Purpose | Libraries Used |  
| ----------- | ----------- | ----------- | ----------- |
| [src/WildcatVaultController.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/market/WildcatMarketBase.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/WildcatVaultControllerFactory.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/market/WildcatMarketWithdrawals.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/WildcatArchController.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/libraries/FeeMath.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/market/WildcatMarket.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/market/WildcatMarketConfig.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/libraries/VaultState.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/WildcatSanctionsSentinel.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/libraries/LibStoredInitCode.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/libraries/FIFOQueue.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/market/WildcatMarketToken.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/libraries/Withdrawal.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/WildcatSanctionsEscrow.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/libraries/BoolUtils.sol](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [src/libraries/Chainalysis.sol ](https://link-when-code-is-ported) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |

## Out Of Scope

*Files and contracts that are out of scope for this audit:*

| Contract | Purpose |
| ----------- | ----------- |
| [contracts/folder/sample.sol](https://github.com/code-423n4/repo-name/blob/contracts/folder/sample.sol) | Blah |

# Additional Context

- [ ] Describe any novel or unique curve logic or mathematical models implemented in the contracts
- [ ] Please list specific ERC20 that your protocol is anticipated to interact with. Could be "any" (literally anything, fee on transfer tokens, ERC777 tokens and so forth) or a list of tokens you envision using on launch.
- [ ] Please list specific ERC721 that your protocol is anticipated to interact with.
- [ ] Which blockchains will this code be deployed to, and are considered in scope for this audit?
- [ ] Please list all trusted roles (e.g. operators, slashers, pausers, etc.), the privileges they hold, and any conditions under which privilege escalation is expected/allowable
- [ ] In the event of a DOS, could you outline a minimum duration after which you would consider a finding to be valid? This question is asked in the context of most systems' capacity to handle DoS attacks gracefully for a certain period.
- [ ] Is any part of your implementation intended to conform to any EIP's? If yes, please list the contracts in this format: 
  - `Contract1`: Should comply with `ERC/EIPX`
  - `Contract2`: Should comply with `ERC/EIPY`

---

## Attack Ideas (Where To Look For Bugs)

### Access Controls and Permissions

- Consider ways in which borrower addresses, controller factories or vaults can be added to the archcontroller either without the specific approval of its owner or as a result of contract deployment.
- Consider ways in which lenders can be authorised on a controller without the specific permission of the borrower that deployed it.
- Consider ways in which where the access roles for market interactions can be maliciously altered to either block or elevant parties outside of the defined flow.
- Consider ways in which removing access (borrowers from the archcontroller, lenders from controllers) can lead to the inability to interact correctly with markets.

### Vault Parameters

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
- The supply of the market token and assets owed by the borrower should always match 1:1.
- The assets of a market should never be able to be withdrawn by anyone that is not a lender or borrower.
- Asset deposits not made via `deposit` should not impact internal accounting (the tokens are lost).
  
- Borrowers can only be registered with the archcontroller by the archcontroller owner.
- Controller factories can only be registered with the archcontroller by the archcontroller owner.
- Controllers and markets can only be deployed by borrowers currently registered with the archcontroller.

---

## Scoping Details

```
- How many contracts are in scope?: 17   
- Total SLoC for these contracts?: 1879  
- How many external imports are there?: 2  
- How many separate interfaces and struct definitions are there for the contracts within scope?: 7 interfaces, 7 structs 
- Does most of your code generally use composition or inheritance?: Inheritance   
- How many external calls?: 1   
- What is the overall line coverage percentage provided by your tests?: 90
- Is this an upgrade of an existing system?: False
- Check all that apply (e.g. timelock, NFT, AMM, ERC20, rollups, etc.): Timelock function, ERC-20 Token 
- Is there a need to understand a separate part of the codebase / get context in order to audit this part of the protocol?: False   
- Please describe required context:   
- Does it use an oracle?: No  
- Describe any novel or unique curve logic or mathematical models your code uses: N/A 
- Is this either a fork of or an alternate implementation of another project?: N/A   
- Does it use a side-chain?: N/A
- Describe any specific areas you would like addressed: see above.
```

# Tests

*Provide every step required to build the project from a fresh git clone, as well as steps to run the tests with a gas report.* 

*Note: Many wardens run Slither as a first pass for testing.  Please document any known errors with no workaround.* 
