// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


import {Test, console} from "forge-std/Test.sol";
import {MockUSDC} from "../contracts/MockUSDC.sol";
import {Vault} from "../contracts/Vault.sol";

contract VaultTest is ERC20 {
  MockUSDC public usdc;
  Vault public vault;

  address public alice = makeAddr("alice");

  function setUp() public {
    usdc = new MockUSDC();
    vault = new Vault();
  }

  // forge test -v
  function test_Deposit() public {
    vm.startPrank(alice);
    
    console.log(alice);

    usdc.mint(alice, 1000);
    usdc.approve(address(vault), 1000);

    vm.expectEmit(true, true, true, true);
    emit Vault.Deposit(alice, 1000);

    // Deposit to vault as Alice
    vault.deposit(1000);
    assertEq(vault.balanceOf(alice), 1000);

    vm.stopPrank();
  }

  function test_Withdraw() public {
    // deposit
    vm.startPrank(alice);
    usdc.mint(alice, 1000);
    usdc.approve(addres(vault), 1000);

    vm.expectEmit(true, true, true, true);
    emit Vault.Deposit(alice, 1000);

    vault.deposit(1000);
    assertEq(vault.balanceOf(alice), 1000);
    vm.stopPrank();

    // distribute
    vm.expectEmit(true, true, true, true);
    emit Vault.DistributeYield(addres(this), 1000);

    vault.distributeYield(1000);
    assertEq(vault.balanceOf(alice), 2000);

    // withdraw
    vm.expectEmit(true, true, true, true);
    emit Vault.Withdraw(alice, 1000);

    vm.prank(alice);
    vault.withdraw(500);

    assertEq(usdc.balanceOf(alice), 1000);
  }

  function test_CallTestEvent() public {
    vm.expectEmit(true, true, true, true);
    emit Vault.TestEvent(1, 2, 3, 4);
  }
}