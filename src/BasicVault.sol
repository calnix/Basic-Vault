// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "yield-utils-v2/token/IERC20.sol";

/**
@title An on-chain name registry
@author Calnix
@dev Vault for a specific ERC20 token; token address to be passed to constructor.
@notice Vault for a pre-defined ERC20 token that was set on deployment. 
*/

contract BasicVault {
    
    ///@notice ERC20 interface specifying token contract functions
    ///@dev For constant variables, the value has to be fixed at compile-time, while for immutable, it can still be assigned at construction time.
    IERC20 public immutable wmdToken;    

    ///@notice mapping addresses to their respective token balances
    mapping(address => uint) public balances;

    /// @notice Emit event when tokens are deposited into Vault
    event Deposit(address indexed, uint amt);
    
    /// @notice Emit event when tokens are withdrawn from Vault
    event Withdrawal(address indexed, uint amt);

    constructor(address wmdToken_){
        wmdToken = IERC20(wmdToken_);

    }

    /// @notice User can deposit tokens into Vault
    /// @dev Expect Deposit to revert if transfer fails
    /// @param amount The amount of tokens to deposit
    function deposit(uint amount) external {
        require(wmdToken.balanceOf(msg.sender) >= amount,"Insufficient tokens!");
        
        emit Deposit(msg.sender, amount);
        balances[msg.sender] += amount;
        
        (bool success) = wmdToken.transferFrom(msg.sender, address(this), amount);
        require(success, "Deposit failed!"); 
    }


    /// @notice User can withdraw tokens from Vault
    /// @dev Expect Withdraw to revert if transfer fails
    /// @param amount The amount of tokens to deposit
    function withdraw(uint amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance!");
        
        emit Withdrawal(msg.sender, amount);
        balances[msg.sender] -= amount;
        
        (bool success) = wmdToken.transfer(address(this), amount);
        require(success, "Token transfer frm User to Vendor failed!");
    }

}
