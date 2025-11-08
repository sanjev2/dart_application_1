abstract class BankAccount {
  String _accountNumber;
  String _accountHolderName;
  double _balance;

  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  void withdraw(double amount);
  void deposit(double amount);

  String get getAccountNumber {
    return _accountNumber;
  }

  String get getAccountHolderName {
    return _accountHolderName;
  }

  double get getBalance {
    return _balance;
  }

  set setAccountNumber(String accountNumber) {
    _accountNumber = accountNumber;
  }

  set setAccountHolderName(String accountHolderName) {
    _accountHolderName = accountHolderName;
  }

  set setBalance(double balance) {
    _balance = balance;
  }

  String displayAccountInfo() {
    return 'Account Number: ${getAccountNumber}, Account Holder: ${getAccountHolderName}, Balance: \$${getBalance.toStringAsFixed(2)}';
  }
}

abstract class InterestBearing {
  double calculateInterest();
}

class SavingsAccount extends BankAccount implements InterestBearing {
  final double _minBalance = 500;
  final double _interestRate = 0.2;
  final int _withdrawLimit = 3;
  int _withdrawCount = 0;

  SavingsAccount(
    super._accountNumber,
    super._accountHolderName,
    super._balance,
  );

  @override
  void withdraw(double amount) {
    if (_withdrawCount >= _withdrawLimit) {
      print("Withdrawal limit exceeded");
    } else if (getBalance - amount < _minBalance) {
      print("Cannot withdraw beyond minimum balance.");
    } else {
      setBalance = getBalance - amount;
      _withdrawCount++;
      print(
        "Successfully withdrew \$${amount.toStringAsFixed(2)} \n Your new balance is: \$${getBalance.toStringAsFixed(2)}",
      );
    }
  }

  @override
  void deposit(double amount) {
    setBalance = getBalance + amount;
    print(
      "Deposited \$${amount.toStringAsFixed(2)} \n Your new balance is: \$${getBalance.toStringAsFixed(2)}",
    );
  }

  @override
  double calculateInterest() {
    double interestAmount = getBalance * _interestRate;
    return interestAmount;
  }
}

class CheckingAccount extends BankAccount {
  final double _overdraftFee = 35;

  CheckingAccount(
    super._accountNumber,
    super._accountHolderName,
    super._balance,
  );

  @override
  void deposit(double amount) {
    setBalance = getBalance + amount;
    print(
      "Deposited \$${amount.toStringAsFixed(2)} \n Your new balance is: \$${getBalance.toStringAsFixed(2)}",
    );
  }

  @override
  void withdraw(double amount) {
    if (getBalance - amount < 0) {
      setBalance = getBalance - (amount + _overdraftFee);
      print(
        "You have overdrafted your account. An overdraft fee of \$${_overdraftFee.toStringAsFixed(2)} has been applied. \n Your new balance is: \$${getBalance.toStringAsFixed(2)}",
      );
    } else {
      setBalance = getBalance - amount;
      print(
        "Successfully withdrew \$${amount.toStringAsFixed(2)} \n Your new balance is: \$${getBalance.toStringAsFixed(2)}",
      );
    }
  }
}

class PremiumAccount extends BankAccount implements InterestBearing {
  final double _minBalance = 10000;
  final double _interestRate = 0.5;

  PremiumAccount(
    super._accountNumber,
    super._accountHolderName,
    super._balance,
  );

  @override
  void deposit(double amount) {
    setBalance = getBalance + amount;
    print(
      "Deposited \$${amount.toStringAsFixed(2)} \n Your new balance is: \$${getBalance.toStringAsFixed(2)}",
    );
  }

  @override
  void withdraw(double amount) {
    if (getBalance - amount < _minBalance) {
      print("Cannot withdraw beyond minimum balance.");
    } else {
      setBalance = getBalance - amount;
      print(
        "Successfully withdrew \$${amount.toStringAsFixed(2)} \n Your new balance is: \$${getBalance.toStringAsFixed(2)}",
      );
    }
  }

  @override
  double calculateInterest() {
    double interestAmount = getBalance * _interestRate;
    return interestAmount;
  }
}

class StudentAccount extends BankAccount {
  final double _maxBalance = 5000;

  StudentAccount(
    super._accountNumber,
    super._accountHolderName,
    super._balance,
  );

  @override
  void deposit(double amount) {
    if (getBalance + amount > _maxBalance) {
      print("Deposit failed: Maximum balance of \$${_maxBalance} exceeded.");
    } else {
      setBalance = getBalance + amount;
      print(
        "Deposited \$${amount.toStringAsFixed(2)} \n Your new balance is: \$${getBalance.toStringAsFixed(2)}",
      );
    }
  }

  @override
  void withdraw(double amount) {
    if (getBalance - amount < 0) {
      print("Insufficient balance.");
    } else {
      setBalance = getBalance - amount;
      print(
        "Successfully withdrew \$${amount.toStringAsFixed(2)} \n Your new balance is: \$${getBalance.toStringAsFixed(2)}",
      );
    }
  }
}

class Bank {
  final List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    _accounts.add(account);
    print("Account created successfully for ${account.getAccountHolderName}");
  }

  BankAccount? findAccount(String accountNumber) {
    for (var acc in _accounts) {
      if (acc.getAccountNumber == accountNumber) {
        return acc;
      }
    }
    print("Account not found.");
    return null;
  }

  void transferMoney(String fromAccNo, String toAccNo, double amount) {
    BankAccount? fromAcc = findAccount(fromAccNo);
    BankAccount? toAcc = findAccount(toAccNo);

    if (fromAcc != null && toAcc != null) {
      fromAcc.withdraw(amount);
      toAcc.deposit(amount);
      print(
        "Successfully transferred \$${amount.toStringAsFixed(2)} from ${fromAcc.getAccountHolderName} to ${toAcc.getAccountHolderName}",
      );
    } else {
      print("Transfer failed due to invalid account details.");
    }
  }

  void displayAllAccounts() {
    for (var acc in _accounts) {
      print(acc.displayAccountInfo());
    }
  }

  void applyMonthlyInterest() {
    for (var acc in _accounts) {
      if (acc is InterestBearing) {
        double interest = (acc as InterestBearing).calculateInterest();
        acc.deposit(interest);
        print(
          "Applied interest of \$${interest.toStringAsFixed(2)} to ${acc.getAccountHolderName}'s account.",
        );
      }
    }
  }
}

void main() {
  Bank bank = Bank();

  SavingsAccount savingsAccount = SavingsAccount("SA123", "John", 1000);
  CheckingAccount checkingAccount = CheckingAccount("CA123", "Alexa", 500);
  PremiumAccount premiumAccount = PremiumAccount("PA123", "Jack", 15000);
  StudentAccount studentAccount = StudentAccount("ST123", "David", 2000);

  bank.createAccount(savingsAccount);
  bank.createAccount(checkingAccount);
  bank.createAccount(premiumAccount);
  bank.createAccount(studentAccount);

  print("=== Testing Each Account Type ===");

  print("\n--- SavingsAccount ---");
  print("Success Test: Deposit");
  savingsAccount.deposit(200);
  print("Error Test: Withdrawal limit");
  savingsAccount.withdraw(100);
  savingsAccount.withdraw(100);
  savingsAccount.withdraw(100);
  savingsAccount.withdraw(100);

  print("\n--- CheckingAccount ---");
  print("Success Test: Withdrawal");
  checkingAccount.withdraw(200);
  print("Error Test: Overdraft");
  checkingAccount.withdraw(400);

  print("\n--- PremiumAccount ---");
  print("Success Test: Deposit");
  premiumAccount.deposit(1000);
  print("Error Test: Min balance withdrawal");
  premiumAccount.withdraw(10000);

  print("\n--- StudentAccount ---");
  print("Success Test: Deposit");
  studentAccount.deposit(1000);
  print("Error Test: Max balance");
  studentAccount.deposit(3000);

  print("\n=== Testing Bank Features ===");
  print("Success Test: Transfer");
  bank.transferMoney("PA123", "ST123", 1000);

  print("Interest Application");
  bank.applyMonthlyInterest();

  print("Account Finding");
  var found = bank.findAccount("SA123");
  if (found != null) print("Found: ${found.displayAccountInfo()}");

  print("Final Report");
  bank.displayAllAccounts();
}
