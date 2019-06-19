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

    /// @notice Deposit tokens into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
        AccountStruct memory acc = balances[msg.sender];
        acc.currentBalance += msg.value;

        return acc.currentBalance;
    }

    /// @notice Withdraw token from bank
    /// @dev This does not return any excess tokens sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint remainingBal) {
        AccountStruct memory acc = balances[msg.sender];
        if(acc.currentBalance >= withdrawAmount) {
            // Note the way we deduct the balance right away, before sending - due to
            // the risk of a recursive call that allows the caller to request an amount greater
            // than their balance
            acc.currentBalance -= withdrawAmount;

            if (!msg.sender.send(withdrawAmount)) {
                // increment back only on fail, as may be sending to contract that
                // has overridden 'send' on the receipt end
                acc.currentBalance += withdrawAmount;
            }
        }

        return acc.currentBalance;
    }

    /// @notice Get balance
    /// @return The balance of the user
    // 'constant' prevents function from editing state variables;
    function balance() public constant returns (uint) {
        AccountStruct memory acc = balances[msg.sender];
        return acc.currentBalance;
    }
}
