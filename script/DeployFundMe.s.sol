// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script{

function run () external returns (FundMe)
 {
HelperConfig helperconfig= new HelperConfig();
address ethtoUSD = helperconfig.activenetworkconfig();

vm.startBroadcast();
FundMe fundme= new FundMe(ethtoUSD);
vm.stopBroadcast();
return fundme;
}

}