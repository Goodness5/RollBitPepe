// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {RollBitPepe} from "../src/erc20.sol";

contract deployRollBitPepe is Script {
        RollBitPepe _rollbitpepe;
        string _name = "RollBitPepe";
        string _symbol = "$ROB";
        address _owner = msg.sender;
        uint256 _supply = 300000000 ether;
    function run() public {
        uint256 key = vm.envUint("private_key");
        vm.startBroadcast(key);
        _rollbitpepe = new RollBitPepe(_name, _symbol, _owner, _supply);
        vm.stopBroadcast();

        console2.log(address(_rollbitpepe));
        
    }
}
