// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "yield-utils-v2/contracts/token/IERC20.sol";

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
    event Deposited(address indexed from, uint amount);
    
    /// @notice Emit event when tokens are withdrawn from Vault
    event Withdrawal(address indexed from, uint amount);
    
    ///@param wmdToken_ ERC20 contract address
    constructor(IERC20 wmdToken_){
        wmdToken = wmdToken_;
    }

    /// @notice User can deposit tokens into Vault
    /// @dev Expect Deposit to revert if transferFrom fails
    /// @param amount The amount of tokens to deposit
    function deposit(uint amount) external {    
        balances[msg.sender] += amount;

        bool success = wmdToken.transferFrom(msg.sender, address(this), amount);
        require(success, "Deposit failed!"); 
        emit Deposited(msg.sender, amount);
    }


    /// @notice User can withdraw tokens from Vault
    /// @dev Expect Withdraw to revert if transfer fails
    /// @param amount The amount of tokens to withdraw
    function withdraw(uint amount) external {      
        balances[msg.sender] -= amount;
        
        bool success = wmdToken.transfer(msg.sender, amount);
        require(success, "Withdrawal failed!");
        emit Withdrawal(msg.sender, amount);
    }

}
