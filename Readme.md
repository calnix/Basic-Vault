# Objectives: multi-user safe
[https://github.com/yieldprotocol/mentorship2022/issues/2]

1. This is a single-token Vault that holds a pre-specified erc-20 token.
2. Users can send tokens to the Vault contract.
3. Vault contract records the user's token deposits.
4. Users can withdraw their tokens only to the address they deposited from. 

# Contracts
- ERC20Mock.sol 
- BasicVault.sol

# Vault contract 
1. Deposit: After approval (handles by front-end), token is deposited via transferFrom.
2. Withdraw: Token is returned, and the Vault updates its user records. 
> Vault contract should import the IERC20 interface, take the Token address in the Vault constructor, and cast it into an IERC20 state variable

# ERC2Mock contract 
1. Public, unrestricted mint() function (anyone should be able to mint)
2. Instead of OpenZepplin implementation, import https://github.com/yieldprotocol/yield-utils-v2/blob/main/contracts/mocks/ERC20Mock.sol  

# Additional Details
1. Add full NatSpec: the contract as well as every event and function should have complete NatSpec. 
- contracts should have @title, @notice, @dev, @author. 
- functions should have @notice, @dev, @param, @return. 
- events should have @notice (no need param or return).
https://docs.soliditylang.org/en/v0.5.10/natspec-format.html

2. Implement CI so when you push to gh, your tests are run automatically.
https://gist.github.com/clifton/b5ee5286bb229281fb31d7c4b15e6f31
https://book.getfoundry.sh/config/continous-integration.html


# Testing
- Vault contract should be fully tested.
- No need to test ERC20Mock. Assume it works as intended. 

## Testing States
**StateZero**
(user has no tokens)
- cannot deposit  (testUserCannotWithdraw)
- cannot withdraw (testUserCannotDeposit)
+ fuzz testing	  (testUserMintApproveDeposit)
** unsure to keep testUserMintApproveDeposit. but was looking for a positive test condition to end this state phase.

**StateTokensMinted**
(user has minted 100 wmd tokens)
(only action available is deposit)
- if transfer fails, deposit should revert (testDepositRevertsIfTransferFails)
+ deposit tokens into vault                (testDeposit)

**StateTokensDeposited**
(user has deposited tokens into Vault)
- cannot withdraw if transfer fails     (testWithdrawRevertsIfTransferFails)
- cannot withdraw more than deposit     (testUserCannotWithdrawExcessOfDeposit)
+ partial withdrawal                    (testUserWithdrawPartial)
+ full withdrawal	                    (testUserWithdrawAll)


### Testing Guidelines
- All state variable changes in the contracts that you code.
- All state variable changes in other contracts caused by calls from contracts that you code.
- All require or revert in the contracts that you code.
- All events being emitted.
- All return values in contracts that you code.


# Deployment
- Rinkeby (Deploy both contracts; token and vault)
- WMD Token: https://rinkeby.etherscan.io/address/0x944403ee436a6dff974983a2fa84ff37c587bad1#writeContract
- Vault: https://rinkeby.etherscan.io/address/0xc5a93d9c0337352f0c2fd2743a2ffffd69818486#writeContract

# Tenderly
For monitoring/alerts as well as for simulating transactions before running them and also for reviewing transactions after the fact.
After you have deployed your vault and done some transactions via etherscan, go on to Tenderly and inspect one of those transactions. 
There is also a debugger (similar to Foundry debugger) that allows you to step through opcodes. If you're up for it, try simulating a transaction as well. 
Here is a video of Alberto demo'ing Tenderly: [https://drive.google.com/file/d/1fW16HhnP_Swc4in-fevFf5Z_1Og_p6za/view]
