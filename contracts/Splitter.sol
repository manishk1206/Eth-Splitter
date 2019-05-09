pragma solidity ^0.5.0;

import "./SafeMath.sol";
import "./Pausable.sol";

contract Splitter is Pausable{
    
    using SafeMath for uint;
    
    mapping(address => uint) public balances;
    
    event LogSplitFunds(address indexed splitby,address indexed beneiciary, uint indexed amount);
    event LogWithdrawnFunds(address indexed beneficiary, uint indexed amount);

    constructor () public payable{
        
    }
    
    //Main function that is used to Split the funds
    function splitBalance(address receiver1, address receiver2) public payable onlyIfRunning returns(bool isSuccess) {

        require ( msg.value > 0, "There should be some non-zero value to split" );
        
        // Bob and Carol should have a valid address
        require( receiver1 != address(0) && receiver2 != address(0));
        
        //All three accounts should be different to make sense
        require( receiver1 != msg.sender && receiver2 != msg.sender && receiver1 != receiver2,"Duplicate address");
        
        uint split = msg.value/2;
        uint mywei = msg.value%2;  //in case of odd msg.value, 1 wei will be left
        
        balances[receiver1] = balances[receiver1].add(split);
        emit LogSplitFunds(msg.sender,receiver1,split);
        
        balances[receiver2] = balances[receiver2].add(split);
        emit LogSplitFunds(msg.sender,receiver2,split);
        
        if (mywei > 0) {
            balances[msg.sender] = balances[msg.sender].add(mywei);
            emit LogSplitFunds(msg.sender,msg.sender,mywei);
        }
        return true;
    }
    
    //Pull pattern for withdrawing funds as suggested by Adel
    function withdrawFunds() public onlyIfRunning {
        uint myBalance = balances[msg.sender];
        require(myBalance > 0, "No balance to withdraw");
        balances[msg.sender] = 0; // Making balance 0 in the mapping as it would be withdrawn 
        msg.sender.transfer(myBalance);
        emit LogWithdrawnFunds(msg.sender, myBalance);
    }
        
    //fall-back function, not payable
    function() external {
        revert("Default Call to fallback");
    }
 }
