import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:trading_app/data/models/holding.dart';
import 'package:trading_app/data/services/storage_service.dart';

class HoldingsRepository {
  HoldingsRepository();

  Map<String, Holding> getAll() {
    final raw = AppStorage.read<String>(AppStorageKeys.holdings) ?? '{}';
    try {
      final decoded = jsonDecode(raw);
      return decoded.map(
        (symbol, json) => MapEntry(symbol, Holding.fromJson(json)),
      );
    } catch (_) {
      return {};
    }
  }

  Holding? getForSymbol(String symbol) => getAll()[symbol];

  Future<void> _saveAll(Map<String, Holding> holdings) async {
    final encoded = jsonEncode(
      holdings.map((symbol, holding) => MapEntry(symbol, holding.toJson())),
    );
    await AppStorage.write(AppStorageKeys.holdings, encoded);
  }

  Future<void> applyBuy({
    required String symbol,
    required int qty,
    required Decimal buyPrice,
  }) async {
    final all = getAll();
    final existing = all[symbol];
    if (existing == null) {
      all[symbol] = Holding(symbol: symbol, quantity: qty, avgCost: buyPrice);
    } else {
      all[symbol] = existing.addBuy(buyQty: qty, buyPrice: buyPrice);
    }
    await _saveAll(all);
  }

  Future<void> applySell({
    required String symbol,
    required int qty,
  }) async {
    final all = getAll();
    final existing = all[symbol];
    if (existing == null) return;
    final updated = existing.reduceBySell(sellQty: qty);
    if (updated == null) {
      all.remove(symbol);
    } else {
      all[symbol] = updated;
    }
    await _saveAll(all);
  }

  Future<void> clear() async {
    await AppStorage.write(AppStorageKeys.holdings, jsonEncode(<String, dynamic>{}));
  }
}
