// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "src/FundMe.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";
import {Fundfundme} from "script/Interaction.s.sol";
import {Test} from "forge-std/Test.sol";

contract interactionTest is Script, Test {

FundMe fundme;
uint256 num=1;
address USER = makeAddr("user");
uint256 constant SEND_VALUE = 10 ether;

    function setup () external {
    DeployFundMe deployfundme= new DeployFundMe ();
    fundme= deployfundme.run();

    vm.deal(USER,SEND_VALUE);

    }
    function testUserCanFund () public {

            Fundfundme fundFundme= new Fundfundme ();
            fundFundme.fundFundMe (address (fundme));
            vm.deal(USER,5e18);
            address funder= fundme.getFUnder(0);     
          assertEq(funder,USER);
    }

}

