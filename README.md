
# The Wildcat Protocol

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

Laurence will cover this section.

TODO: Point out that the lending model is inverted here: it's borrower driven (sourcing their own lenders).

[ ⭐️ SPONSORS: add info here ]

## Links

- **Previous audits:** [Security review of market logic](https://hackmd.io/@geistermeister/r15gj_y1p) by [alpeh_v](https://x.com/alpeh_v)
- **Documentation:**: [Gitbook](https://wildcat-protocol.gitbook.io) 
- **Website:**: N/A [Still building things out!]
- **Twitter:**: [@WildcatFi](https://x.com/WildcatFi)  

# Scope

[ ⭐️ SPONSORS: add scoping and technical details here ]

- [ ] In the table format shown below, provide the name of each contract and:
  - [ ] source lines of code (excluding blank lines and comments) in each *For line of code counts, we recommend running prettier with a 100-character line length, and using [cloc](https://github.com/AlDanial/cloc).* 
  - [ ] external contracts called in each
  - [ ] libraries used in each

*Files and contracts in scope for this audit in the table below:*

| Contract | SLOC | Purpose | Libraries used |  
| ----------- | ----------- | ----------- | ----------- |
| [contracts/folder/sample.sol](https://github.com/code-423n4/repo-name/blob/contracts/folder/sample.sol) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |

## Out of scope

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

### Deposits and Withdrawals

- Consider ways in which deposits might cause trouble with internal market accounting.
- Consider ways in which lenders making withdrawal requests might have them (be they either pending or expired) altered.
- Consider ways in which market tokens can be burned but incorrect amounts of assets are claimable (this is _very_ nuanced and circumstance specific).

### Sentinel and Escrow Contracts

- Consider ways (beyond a hostile Chainalysis oracle) in which lender addresses could be excised from a market via `nukeFromOrbit`.
- Consider ways in which parties to an escrow contract might be locked out of it.
  
---

## Main Invariants

*Describe the project's main invariants (properties that should NEVER EVER be broken).*

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
