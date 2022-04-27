// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

import 'src/BasicVault.sol';
import 'test/WMDTokenWithFailedTransfers.sol';

abstract contract StateZero is Test {
        
    BasicVault public vault;
    WMDTokenWithFailedTransfers public wmd;
    address user;
    address deployer;

    function setUp() public virtual {
        wmd = new WMDTokenWithFailedTransfers();
        vault = new BasicVault(address(wmd));

        user = 0x0000000000000000000000000000000000000001;
        vm.label(user, "user");
    }
}

contract StateZeroTest is StateZero {
    
    function testGetUserBalance() public {
        console2.log("Check User has zero tokens in vault");
        vm.prank(user);
        uint balance = vault.balances(user);
        assertTrue(balance == 0);
    }

    function testUserCannotWithdraw(uint amount) public {
        console2.log("User cannot withdraw with no balance");
        vm.assume(amount > 0);
        vm.prank(user);
        vm.expectRevert("Insufficient balance!");
        vault.withdraw(amount);
    }
   
    function testUserMintApproveDeposit(uint amount) public {
        console2.log("User mints tokens and deposits into vault");
        vm.startPrank(user);
        vm.assume(amount > 0);
        wmd.mint(user, amount);
        wmd.approve(address(vault), amount);
        vault.deposit(amount);
        uint balance = vault.balances(user);
        assertTrue(balance == amount);
        vm.stopPrank();
    }

}

abstract contract StateTokensMinted is StateZero {
    uint userTokens;
    
    function setUp() public override virtual {
        super.setUp();
        
        // state transition: user mints 100 tokens
        userTokens = 100 * 10**18;
        vm.prank(user);
        wmd.mint(user, userTokens);
    }

}

contract StateTokensMintedTest is StateTokensMinted {

    function testUserCannotDepositWithoutApproval() public {
        console2.log("User cannot deposit tokens into Vault before setting allowance");
        vm.prank(user);
        vm.expectRevert("ERC20: Insufficient approval");
        vault.deposit(userTokens);
    }

    function testDepositRevertsIfTransferFails() public {
        console2.log("Deposit transaction should revert if transfer fails");
        wmd.setFailTransfers(true);
        vm.startPrank(user);
        wmd.approve(address(vault), userTokens);
        vm.expectRevert("Deposit failed!");
        vault.deposit(userTokens);
        vm.stopPrank();

    }

    function testUserApproveAndDeposit() public {
        console2.log("User sets allowance and deposits into Vault");
        vm.startPrank(user);
        wmd.approve(address(vault), userTokens);
        vault.deposit(userTokens);
        uint balance = vault.balances(user);
        assertTrue(balance == userTokens);
        vm.stopPrank();
    }

}

abstract contract StateTokensDeposited is StateTokensMinted {
    
    function setUp() public override virtual {
        super.setUp();  
        vm.startPrank(user);
        wmd.approve(address(vault), userTokens);
        vault.deposit(userTokens);
        vm.stopPrank();
    }
}

contract StateTokensDepositedTest is StateTokensDeposited {
    
    function testWithdrawRevertsIfTransferFails() public {
        console2.log("Withdraw transaction should revert if transfer fails");
        wmd.setFailTransfers(true);
        vm.prank(user);
        vm.expectRevert("Token transfer frm User to Vendor failed!");
        vault.withdraw(userTokens);
    }

    function testUserCannotWithdrawExcessOfDeposit() public {
        console2.log("User cannot withdraw more than he has deposited");
        vm.prank(user);
        vm.expectRevert("Insufficient balance!");
        vault.withdraw(userTokens + 100*10**18);
    }

    function testUserWithdrawPartial() public {
        console2.log("User to partially withdraw deposits from Vault");
        vm.prank(user);
        vault.withdraw(userTokens/2);
        uint balance = vault.balances(user);
        assertTrue(balance == userTokens/2);
    }
 
    function testUserWithdrawAll() public {
        console2.log("User to withdraw deposits from Vault");
        vm.prank(user);
        vault.withdraw(userTokens);
        uint balance = vault.balances(user);
        assertTrue(balance == 0);
    }

}