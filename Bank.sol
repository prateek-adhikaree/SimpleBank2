// A simple Bank contract
// Allows deposits, withdrawals, and balance checks
pragma solidity 0.4.25;

contract Bank {
    address owner = msg.sender;
    
    struct AccountStruct {
        string name;
        uint currentBalance;
    }
    
    mapping (address => AccountStruct) private balances;
    
    function createAccount(string name) public payable returns (bool) {
        AccountStruct acc;
        acc.name = name;
        
        balances[msg.sender] = acc;
        
        return true;
    }
    
    function deposit() public payable returns (uint) {
        AccountStruct memory acc = balances[msg.sender];
        
        assert(balances[msg.sender].currentBalance != 0);
        
        if (! slabReached(msg.sender)) {
            acc.currentBalance += msg.value;
        }
        return acc.currentBalance;
    }
    
    function slabReached(address accountAddress) internal view returns (bool) {
        return balances[accountAddress].currentBalance == 100;
    }
    
    function assert(bool condition) public {
        // do some assertions here based on the system requirements
    }
    
    function withdraw(uint withdrawAmount) public returns (uint remainingBal) {
        AccountStruct memory acc = balances[msg.sender];
        if(acc.currentBalance >= withdrawAmount) {
            acc.currentBalance -= withdrawAmount;

            if (!msg.sender.send(withdrawAmount)) {
                acc.currentBalance += withdrawAmount;
            }
        }
        return acc.currentBalance;
    }
    
    function balance() public constant returns (uint) {
        AccountStruct memory acc = balances[msg.sender];
        return acc.currentBalance;
    }
}
