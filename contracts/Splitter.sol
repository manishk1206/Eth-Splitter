pragma solidity ^0.5.0;

contract Splitter{
    
    address public Alice;
    
    event LogSplitFundsBob(address, uint);
    event LogSplitFundsCarol(address, uint);
    event LogReturnedFunds(address, uint);
    
    constructor () public payable{
        Alice = msg.sender;
    }
    function splitBalance(address payable _bob, address payable _carol) 
    public payable returns(uint amount1){
        // only Alice can send ether to be split
        require(msg.sender == Alice);
         // There should be some value to split
        require ( msg.value > 0 );
        // Bob and Carol should have a valid address
        require( _bob != address(0));
        require( _carol != address(0));

        amount1 = msg.value/2;
        _bob.transfer (amount1);
        emit LogSplitFundsBob(_bob,amount1);
        _carol.transfer(amount1);
        emit LogSplitFundsCarol(_carol,amount1);
    }
    function refundBalance() public  {
        require(msg.sender == Alice);
        uint balance = address(this).balance;
        require ( balance > 0 );
        emit LogReturnedFunds(msg.sender, balance);
        msg.sender.transfer(balance);
  }
    function getBalance (address _who) public view returns (uint bal){
      bal = (_who).balance;
    }
}