// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18 ;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract Fundfundme is Script {
    uint256 constant SEND_VALUE= 0.5 ether;
    function fundFundMe (address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value:SEND_VALUE}();
        vm.stopBroadcast();
        console.log("funded fundme %s",SEND_VALUE);

    }

    function run () external {

        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentDeployed);
    }

 }