
import Foundation

// MARK: - Bank Account Class

public class BankAccount {

    // Private variable
    private var balance: Double

    // Public variable
    public let accountHolder: String

    // Fileprivate variable
    fileprivate var accountType = "Savings"

    // Internal variable
    internal let bankName = "ABC Bank"

    // Store transaction history
    private var transactions: [String] = []

    // Read-only balance
    public var currentBalance: Double {
        return balance
    }

    // Read-only transaction history
    public var transactionHistory: [String] {
        return transactions
    }

    // Initializer
    public init?(accountHolder: String, openingBalance: Double) {

        if accountHolder.isEmpty || openingBalance < 0 {
            return nil
        }

        self.accountHolder = accountHolder
        self.balance = openingBalance

        transactions.append("Account created")
    }

    // Deposit money
    public func deposit(amount: Double) {

        if amount <= 0 {
            print("Invalid deposit amount")
        } else {
            balance += amount
            transactions.append("Deposited: \(amount)")
            print("Money deposited successfully")
        }
    }

    // Withdraw money
    public func withdraw(amount: Double) {

        if amount <= 0 {
            print("Invalid withdrawal amount")
        } else if amount > balance {
            print("Insufficient balance")
        } else {
            balance -= amount
            transactions.append("Withdrawn: \(amount)")
            print("Money withdrawn successfully")
        }
    }
}


// MARK: - Fileprivate Function

fileprivate func showAccountType(account: BankAccount) {
    print("Account Type: \(account.accountType)")
}

Main Program


// Create account
if let account = BankAccount(accountHolder: "Ahana", openingBalance: 5000) {

    print("Account Holder:", account.accountHolder)
    print("Bank Name:", account.bankName)

    showAccountType(account: account)

    print("Opening Balance:", account.currentBalance)

    // Deposit money
    print("\n===== DEPOSIT =====")

    account.deposit(amount: 2000)

    print("Current Balance:", account.currentBalance)

    // Withdraw money
    print("\n===== WITHDRAWAL =====")

    account.withdraw(amount: 1000)

    print("Current Balance:", account.currentBalance)

    // Invalid deposit
    print("\n===== INVALID DEPOSIT =====")

    account.deposit(amount: -500)

    // Invalid withdrawal
    print("\n===== INVALID WITHDRAWAL =====")

    account.withdraw(amount: 10000)

    // Transaction history
    print("\n===== TRANSACTION HISTORY =====")

    for transaction in account.transactionHistory {
        print(transaction)
    }

    // Final balance
    print("\nFinal Balance:", account.currentBalance)

} else {
    print("Invalid account details")
}


// MARK: - Testing Invalid Account

print("\n===== INVALID ACCOUNT TEST =====")

if let account2 = BankAccount(accountHolder: "", openingBalance: -500) {
    print("Account created")
} else {
    print("Account cannot be created")
}
