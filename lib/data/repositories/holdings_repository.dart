import 'dart:convert';
import 'package:trading_app/trade_app.dart';


class HoldingsRepository {
  HoldingsRepository._internal();
  static final HoldingsRepository _instance = HoldingsRepository._internal();
  factory HoldingsRepository() => _instance;

  /// Reads all holdings as a symbol -> Holding map.
  /// Returns an empty map on first launch rather than null.
  Map<String, Holding> getAll() {
    final raw = AppStorage.read<String>(AppStorageKeys.holdings);
    if (raw == null) return {};

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
            (symbol, json) =>
            MapEntry(symbol, Holding.fromJson(json as Map<String, dynamic>)),
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

  /// Applies a successful Buy: creates a new holding, or updates the
  /// existing one's quantity + weighted-average cost via Holding.addBuy().
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

  /// Applies a successful Sell: reduces quantity, or removes the holding
  /// entirely if quantity reaches zero (per Holding.reduceBySell()).
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