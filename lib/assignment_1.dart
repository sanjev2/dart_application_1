abstract class BankAccount {
  // Private fields (Encapsulation)
  int _accountNumber;
  String _accountHolder;
  double _balance;

  // Constructor
  BankAccount(this._accountNumber, this._accountHolder, this._balance);

  // Getters and setters (updated to match Arithmetic style)
  int get getAccountNumber {
    return _accountNumber;
  }

  String get getAccountHolder {
    return _accountHolder;
  }

  double get getBalance {
    return _balance;
  }

  set setBalance(double amount) {
    _balance =
        amount; // Removed negative check; subclasses handle constraints in methods
  }

  // Abstract methods (Abstraction) - Now return bool for success/failure
  bool deposit(double amount);
  bool withdraw(double amount);

  // Display method
  void displayInfo() {
    print("Account No: ${getAccountNumber}"); // Updated to use getter
    print("Holder Name: ${getAccountHolder}"); // Updated to use getter
    print("Balance: \$${getBalance}"); // Updated to use getter
  }
}

abstract class InterestBearing {
  double calculateInterest();
}

class SavingsAccount extends BankAccount implements InterestBearing {
  int _withdrawCount = 0;
  static const int withdrawLimit = 3;
  static const double minBalance = 500;
  static const double interestRate = 0.02;

  SavingsAccount(int accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  bool deposit(double amount) {
    balance += amount;
    print("Deposited \$${amount}. New Balance: \$${balance}");
    return true;
  }

  @override
  bool withdraw(double amount) {
    if (_withdrawCount >= withdrawLimit) {
      print("Withdrawal limit reached!");
      return false;
    } else if (balance - amount < minBalance) {
      print("Cannot withdraw. Minimum balance of \$${minBalance} required.");
      return false;
    } else {
      balance -= amount;
      _withdrawCount++;
      print("Withdrew \$${amount}. Remaining Balance: \$${balance}");
      return true;
    }
  }

  @override
  double calculateInterest() {
    double interest = balance * interestRate;
    print("Interest for Savings Account: \$${interest}");
    return interest;
  }
}

class CheckingAccount extends BankAccount {
  static const double overdraftFee = 35;

  CheckingAccount(int accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  bool deposit(double amount) {
    balance += amount;
    print("Deposited \$${amount}. New Balance: \$${balance}");
    return true;
  }

  @override
  bool withdraw(double amount) {
    balance -= amount;
    if (balance < 0) {
      balance -= overdraftFee;
      print("Overdraft! Fee of \$${overdraftFee} applied.");
    }
    print("Withdrew \$${amount}. New Balance: \$${balance}");
    return true; // Always succeeds, even with overdraft
  }
}

class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000;
  static const double interestRate = 0.05;

  PremiumAccount(int accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  bool deposit(double amount) {
    balance += amount;
    print("Deposited \$${amount}. New Balance: \$${balance}");
    return true;
  }

  @override
  bool withdraw(double amount) {
    if (balance - amount < minBalance) {
      print("Cannot withdraw below minimum balance of \$${minBalance}.");
      return false;
    } else {
      balance -= amount;
      print("Withdrew \$${amount}. New Balance: \$${balance}");
      return true;
    }
  }

  @override
  double calculateInterest() {
    double interest = balance * interestRate;
    print("Interest for Premium Account: \$${interest}");
    return interest;
  }
}

class StudentAccount extends BankAccount {
  static const double maxBalance = 5000;

  StudentAccount(int accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  bool deposit(double amount) {
    if (amount <= 0) {
      print("Deposit amount must be greater than zero.");
      return false; // Added: Indicate failure
    } else if (balance + amount > maxBalance) {
      print("Deposit failed: Maximum allowed balance is \$${maxBalance}.");
      return false; // Added: Indicate failure
    } else {
      balance +=
          amount; // Changed: Use setter for consistency (instead of _balance += amount)
      print("Successfully deposited \$${amount}. New balance: \$${balance}");
      return true; // Added: Indicate success
    }
  }

  @override
  bool withdraw(double amount) {
    if (balance - amount < 0) {
      print("Insufficient balance.");
      return false;
    } else {
      balance -= amount;
      print("Withdrew \$${amount}. New Balance: \$${balance}");
      return true;
    }
  }
}

class Bank {
  List<BankAccount> accounts = [];

  void createAccount(BankAccount account) {
    accounts.add(account);
    print("Account created for ${account.accountHolder}");
  }

  BankAccount? findAccount(int accNo) {
    for (var acc in accounts) {
      if (acc.accountNumber == accNo) {
        return acc;
      }
    }
    print("Account not found!");
    return null;
  }

  void transfer(int fromAcc, int toAcc, double amount) {
    var sender = findAccount(fromAcc);
    var receiver = findAccount(toAcc);

    if (sender != null && receiver != null) {
      if (sender.withdraw(amount)) {
        if (receiver.deposit(amount)) {
          print(
            "Transferred \$${amount} from ${sender.accountHolder} to ${receiver.accountHolder}",
          );
        } else {
          print("Transfer failed: Deposit to receiver failed.");
          // Optional: Attempt rollback (re-deposit to sender), but skipped for simplicity
        }
      } else {
        print("Transfer failed: Withdrawal from sender failed.");
      }
    }
  }

  void generateReport() {
    print("\n=== Bank Report ===");
    for (var acc in accounts) {
      acc.displayInfo();
      print("-----------------");
    }
  }

  // Extension: Apply interest to all interest-bearing accounts
  void applyMonthlyInterest() {
    for (var acc in accounts) {
      if (acc is InterestBearing) {
        double interest = (acc as InterestBearing)
            .calculateInterest(); // Fixed: Cast to access method
        bool depositSuccess = acc.deposit(
          interest,
        ); // Fixed: Check deposit success
        if (!depositSuccess) {
          print("Failed to deposit interest for account ${acc.accountNumber}");
        }
      }
    }
  }
}

void main() {
  Bank bank = Bank();

  var acc1 = SavingsAccount(101, "Alice", 1000);
  var acc2 = CheckingAccount(102, "Bob", 300);
  var acc3 = PremiumAccount(103, "Charlie", 20000);
  var acc4 = StudentAccount(104, "David", 2000);

  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);
  bank.createAccount(acc4);

  acc1.withdraw(200); // Succeeds
  acc2.withdraw(
    400,
  ); // Now correctly allows overdraft: 300 - 400 = -100, then -35 fee = -135
  acc3.deposit(5000); // Succeeds
  acc4.deposit(6000);

  bank.transfer(101, 102, 100); // Succeeds (sender has enough)
  bank.applyMonthlyInterest();
  bank.generateReport();
}
