pragma solidity ^0.5.0;

contract Ownable{
    
    address public owner;
    
    event LogChangeOwner(address indexed sender, address indexed newOwner);
    
    modifier onlyOwner{
        require(msg.sender==owner);
        _;
    }
    
    constructor() public{
        owner = msg.sender;
    }
    
    function changeOwner(address newOwner) public onlyOwner returns(bool success){
        owner = newOwner;
        emit LogChangeOwner(msg.sender,newOwner);
        return true;
        
    }
    
}