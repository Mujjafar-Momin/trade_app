import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class WalletService {
  WalletService._internal();

  static final WalletService _instance = WalletService._internal();

  factory WalletService() => _instance;

  final WalletRepository _repository = WalletRepository();

  late final Rx<Decimal> balance;

  bool _initialized = false;

  void init() {
    if (_initialized) return;
    _initialized = true;
    balance = _repository.get().balance.obs;
  }

  bool canAfford(Decimal amount) => balance.value >= amount;

  Future<void> debit(Decimal amount) async {
    balance.value = balance.value - amount;
    await _repository.save(Wallet(balance: balance.value));
  }

  Future<void> credit(Decimal amount) async {
    balance.value = balance.value + amount;
    await _repository.save(Wallet(balance: balance.value));
  }

  Future<void> reset() async {
    await _repository.reset();
    balance.value = Wallet.initial().balance;
  }
}
