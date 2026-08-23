import 'package:decimal/decimal.dart';

class Wallet {
  final Decimal balance;

  const Wallet({required this.balance});

  factory Wallet.initial() => Wallet(balance: Decimal.parse('1000000.00'));

  bool canAfford(Decimal amount) => balance >= amount;

  Wallet debit(Decimal amount) => Wallet(balance: balance - amount);

  Wallet credit(Decimal amount) => Wallet(balance: balance + amount);

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(balance: Decimal.tryParse(json['balance'] ?? "") ?? Decimal.zero);
  }

  Map<String, dynamic> toJson() => {'balance': balance.toString()};
}
