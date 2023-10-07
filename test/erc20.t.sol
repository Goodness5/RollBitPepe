// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {RollBitPepe} from "../src/erc20.sol";

contract RollBitPepeTest is Test {
    RollBitPepe public token;

    address _tester1 = mkaddr("tester1");
    address _assetowner = mkaddr("assetowner");
    address _newowner = mkaddr("newowner");

    function setUp() public {
        string memory name = "MyToken";
        string memory symbol = "MTK";
        address owner = _assetowner;
        uint256 supply = 100000000 ether;
        vm.startPrank(_tester1);
        token = new RollBitPepe(name, symbol, owner, supply);
        vm.stopPrank();
    }

    function testTransfer() public {
        vm.startPrank(_assetowner);
        uint256 amount = 1000 ether;
        token.transfer(_tester1, amount);
        uint256 balance = token.balanceOf(_tester1);
        assertEq(balance, amount, "Transfer failed");
        vm.stopPrank();
    }

  function testApprove() public {
    vm.startPrank(_assetowner);
    uint256 amount = 1000 ether;
    token.approve(_tester1, amount);
    uint256 allowance = token.allowance(_assetowner, _tester1);
    assertEq(allowance, amount, "Approve failed");
    vm.stopPrank();
}

function testTransferFrom() public {
    testApprove();
    vm.startPrank(_tester1);
    uint256 amount = 1000 ether;
    
    token.transferFrom(_assetowner, msg.sender, amount);
    uint256 balance = token.balanceOf(msg.sender);
    assertEq(balance, amount, "TransferFrom failed");
    vm.stopPrank();
}


    function testChangeOwner() public {
        
        vm.startPrank(_assetowner);
        token.changeOwner(_newowner);
        address owner = token.owner();
        assertEq(owner, _newowner, "Change owner failed");
        vm.stopPrank();
    }
function testBurn() public {
    vm.startPrank(_assetowner);
    uint256 initialBalance = token.balanceOf(_assetowner);
    uint256 burnAmount = 500 ether;
    token.burn(burnAmount);
    uint256 finalBalance = token.balanceOf(_assetowner);
    assertEq(finalBalance, initialBalance - burnAmount, "Burn failed");
    vm.stopPrank();
}

function testMint() public {
    vm.startPrank(_assetowner);
    uint256 initialSupply = token.totalSupply();
    uint256 mintAmount = 1000 ether;
    token.mint(_assetowner, mintAmount);
    uint256 finalSupply = token.totalSupply();
    assertEq(finalSupply, initialSupply + mintAmount, "Mint failed");
    vm.stopPrank();
}

function testIncreaseAllowance() public {
    vm.startPrank(_assetowner);
    address spender = _tester1;
    uint256 initialAllowance = token.allowance(_assetowner, spender);
    uint256 increaseAmount = 100 ether;
    token.increaseAllowance(spender, increaseAmount);
    uint256 finalAllowance = token.allowance(_assetowner, spender);
    assertEq(finalAllowance, initialAllowance + increaseAmount, "Increase Allowance failed");
    vm.stopPrank();
}

function testDecreaseAllowance() public {
    testApprove();
    vm.startPrank(_assetowner);
    address spender = _tester1;
    uint256 initialAllowance = token.allowance(_assetowner, spender);
    uint256 decreaseAmount = 50 ether;
    token.decreaseAllowance(spender, decreaseAmount);
    uint256 finalAllowance = token.allowance(_assetowner, spender);
    assertEq(finalAllowance, initialAllowance - decreaseAmount, "Decrease Allowance failed");
    vm.stopPrank();
}

function testBurnFrom() public {
    vm.startPrank(_assetowner);
    uint256 initialBalance = token.balanceOf(_assetowner);
    uint256 burnAmount = 100 ether;
    token.approve(_tester1, burnAmount);
    vm.stopPrank();
    vm.startPrank(_tester1);
    token.burnFrom(_assetowner, burnAmount);
    uint256 finalBalance = token.balanceOf(_assetowner);
    assertEq(finalBalance, initialBalance - burnAmount, "Burn From failed");
    vm.stopPrank();
}



    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
