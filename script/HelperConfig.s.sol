// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol"; 
import {FundMe} from "../src/FundMe.sol";
import {MockV3Aggregator} from "../test/Mock/MockV3Aggregator.sol";


contract HelperConfig is Script{
 
uint8 public constant DECIMAL=8;
int public constant INITALPRICE=2000e18;

struct NetworkConfig {
    
    address pricefeed;

}

NetworkConfig public activenetworkconfig;

constructor ()
{
    if (block.chainid== 11155111)
    {

    activenetworkconfig=getSepoliaETH();
    } else 
    {

activenetworkconfig=getAnvilETH();

    }

}


 function getSepoliaETH ( ) public pure returns (NetworkConfig memory){

NetworkConfig memory sepoliaconfig = NetworkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);

return sepoliaconfig;
 }


 function getAnvilETH ( ) public returns (NetworkConfig memory) {
    if (activenetworkconfig.pricefeed != address(0))
    {
        return activenetworkconfig;

    }
    vm.startBroadcast();
    MockV3Aggregator mockpricefeed= new MockV3Aggregator (DECIMAL,INITALPRICE);
    vm.stopBroadcast();
    NetworkConfig memory anvilconfig = NetworkConfig (address (mockpricefeed));
return anvilconfig ;
 }
}

