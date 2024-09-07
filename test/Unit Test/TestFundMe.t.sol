// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {FundMe} from "src/FundMe.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";
import {Script} from "forge-std/Script.sol";

contract FundMeTest is Test, Script {
FundMe fundme;
uint256 num=1;
address USER = makeAddr("user");
uint256 constant SEND_VALUE = 10 ether;


function setUp () external {

DeployFundMe deployfundme= new DeployFundMe ();
fundme= deployfundme.run();
num=2;
vm.deal(USER,SEND_VALUE);
}

function testdemo () view public {

assertEq (num,2);

}

function testMinimumDollarFiver() view public{

console.log ("Minimum dollar",fundme.MINIMUM_USD());

assertEq (fundme.MINIMUM_USD(),5e18);
}

function testOwnerIsSender () view public 
{

assertEq(fundme.getOwner(), msg.sender);


}
function testPriceFeedVersion () view public {

console.log ("test price feed");
    assertEq (fundme.getVersion(),4);


}
function testNotSendEnoughtETH()  public {
vm.expectRevert();
fundme.fund(); //i send more than 5 ETH so the test failed because it didnt revert.
    
}

function testUpdatingValuesOfFunders () public {
        vm.startPrank(USER);
        fundme.fund{value: SEND_VALUE}();
        vm.stopPrank();
         
uint256 amountFunded=fundme.getAddressToAmountFunded(USER);
assertEq (amountFunded, 10 ether);
} 

function testAddFundersToArray () public {

       vm.startPrank(USER);
        fundme.fund{value: SEND_VALUE}();
        vm.stopPrank();

address funderaddress= fundme.getFUnder(0);
assertEq(funderaddress, USER);

}
modifier funded ()
{

vm.prank (USER);
fundme.fund{value:SEND_VALUE}();
_;   
}
function testOnlyOwnerCanWithdraw () public funded
{
    vm.prank(USER);
    vm.expectRevert();
   fundme.withdraw();
}
function testWithdrawSingleFunder () public funded 
{
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance= address(fundme).balance;
        vm.prank (fundme.getOwner());
        fundme.withdraw();
        uint256 endingOwnerBalance = fundme.getOwner().balance;
        uint256 endingFundMeBalance= address(fundme).balance;
        assertEq (endingFundMeBalance,0);
        assertEq (startingOwnerBalance+startingFundMeBalance,endingOwnerBalance);

}

function testWithMultipleFunders () public funded 
{

        for (uint160 i=0;i < 10; i++)
        {
                hoax(address(i),SEND_VALUE);
                fundme.fund{value:SEND_VALUE}();

        }
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance= address(fundme).balance;

        vm.prank(fundme.getOwner());
        fundme.withdraw();
        assert (address(fundme).balance== 0);
       assert (startingFundMeBalance+startingOwnerBalance == fundme.getOwner().balance);
}

}