pragma solidity ^0.5.0;

contract Splitter{
    
    address public Alice;
    mapping(address => uint) public balances;
    
    event LogSplitFunds(address indexed beneficiary, uint indexed amount, uint indexed mywei);
    event LogWithdrawnFunds(address indexed beneficiary, uint indexed amount);

    constructor () public payable{
        Alice = msg.sender;
    }
    
    modifier onlyAlice(){
        
        require(msg.sender == Alice, "You are not Alice almighty, buzz off!" );
        _;
    }
    
    //Main function that is used to Split the funds by Alice
    function splitBalance(address _bob, address _carol) public payable onlyAlice returns(bool isSuccess){

        require ( msg.value > 0, "There should be some non-zero value to split" );
        
        // Bob and Carol should have a valid address
        require( _bob != address(0)&&_carol != address(0));

        uint split = msg.value/2;
        uint mywei = msg.value%2;  //in case of odd msg.value, 1 wei will be left
        
        balances[_bob] += split;
        emit LogSplitFunds(_bob,balances[_bob],0);
        
        balances[_carol] += split;
        emit LogSplitFunds(_carol,balances[_carol],0);
        
        if (mywei > 0) {
            address(msg.sender).transfer(mywei);
        }
        emit LogSplitFunds(msg.sender,0,mywei);
        
        return true;
    }
    
    //Pull pattern for withdrawing funds as suggested by Adel
    function withdrawFunds() public  {
        uint myBalance = balances[msg.sender];
        require(myBalance > 0, "No balance to withdraw");
        balances[msg.sender] = 0; // Making balance 0 in the mapping as it would be withdrawn 
        address(msg.sender).transfer(myBalance);
        emit LogWithdrawnFunds(msg.sender, myBalance);
    }
    
    //Kill the contract and transfer any remaining funds back to owner(Alice)
    function kill() external onlyAlice {
        selfdestruct(msg.sender); 
    }
    
    //fall-back function
    function() external {
        revert("Default Call to fallback");
    }
 }
