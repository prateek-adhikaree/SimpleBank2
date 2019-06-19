// First, a simple Bank contract
// Allows deposits, withdrawals, and balance checks
pragma solidity 0.4.25;

contract Bank {
    // dictionary that maps addresses to balances
    // always be careful about overflow attacks with numbers
    mapping (address => uint) private balances;
    
    address public owner = msg.sender;

    // Events - publicize actions to external listeners
    event LogDepositMade(address accountAddress, uint amount);

    constructor () public {
        
    }

    /// @notice Deposit tokens into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
        balances[msg.sender] += msg.value;

        // fire event
        emit LogDepositMade(msg.sender, msg.value);

        return balances[msg.sender];
    }

    /// @notice Withdraw token from bank
    /// @dev This does not return any excess tokens sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint remainingBal) {
        if(balances[msg.sender] >= withdrawAmount) {
            // Note the way we deduct the balance right away, before sending - due to
            // the risk of a recursive call that allows the caller to request an amount greater
            // than their balance
            balances[msg.sender] -= withdrawAmount;

            if (!msg.sender.send(withdrawAmount)) {
                // increment back only on fail, as may be sending to contract that
                // has overridden 'send' on the receipt end
                balances[msg.sender] += withdrawAmount;
            }
        }

        return balances[msg.sender];
    }

    /// @notice Get balance
    /// @return The balance of the user
    // 'constant' prevents function from editing state variables;
    function balance() public constant returns (uint) {
        return balances[msg.sender];
    }
}
