pragma solidity ^0.5.0;

import "./Ownable.sol";

contract Pausable is Ownable{
    bool isRunning;
    
    event LogPausedContract(address sender);
    event LogResumedContract(address sender);
    
    modifier onlyIfRunning {
        require(isRunning);
        _;
    }
    
    constructor() public{
        isRunning = true;
    }
    
    function pauseContract() public onlyOwner onlyIfRunning returns (bool success){
        isRunning = false;
        emit LogPausedContract(msg.sender);
        return true;
    }
    
    function resumeContract() public onlyOwner onlyIfRunning returns (bool success){
        require(!isRunning);
        isRunning = true;
        emit LogResumedContract(msg.sender);
        return true;
    }
}