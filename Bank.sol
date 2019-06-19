// First, a simple Bank contract
// Allows deposits, withdrawals, and balance checks
pragma solidity 0.4.25;

contract Bank {
    struct AccountStruct {
        string name;
        uint currentBalance;
    }
    
    // dictionary that maps addresses to balances
    // always be careful about overflow attacks with numbers
    mapping (address => AccountStruct) private balances;

    /// @notice Create the person's bank account
    /// @param name person's name
    /// @return true if creation successful
    function createAccount(string name) public payable returns (bool) {
        AccountStruct memory acc;
        acc.name = name;
        
        balances[msg.sender] = acc;
        
        return true;
    }
    
    function deposit() public payable returns (uint) {
        AccountStruct memory acc = balances[msg.sender];
        
        if (! slabReached(msg.sender)) {
            acc.currentBalance += msg.value;
        }
        return acc.currentBalance;
    }
    
    function slabReached(address accountAddress) internal view returns (bool) {
        return balances[accountAddress].currentBalance == 100;
    }
}
