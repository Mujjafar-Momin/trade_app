import 'dart:convert';
import 'package:trading_app/trade_app.dart';

class WalletRepository {
  WalletRepository._internal();
  static final WalletRepository _instance = WalletRepository._internal();
  factory WalletRepository() => _instance;


  Wallet get() {
    final raw = AppStorage.read<String>(AppStorageKeys.wallet);
    if (raw == null) return Wallet.initial();

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return Wallet.fromJson(decoded);
    } catch (_) {
      return Wallet.initial();
    }
  }

  Future<void> save(Wallet wallet) async {
    await AppStorage.write(AppStorageKeys.wallet, jsonEncode(wallet.toJson()));
  }

  Future<void> reset() async {
    await save(Wallet.initial());
  }
}