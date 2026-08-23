import 'dart:convert';
import 'package:trading_app/trade_app.dart';

class WatchlistRepository {
  WatchlistRepository._internal();

  static final WatchlistRepository _instance = WatchlistRepository._internal();

  factory WatchlistRepository() => _instance;

  List<Watchlist> getAll() {
    final raw = AppStorage.read<String>(AppStorageKeys.watchLists);
    if (raw == null) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => Watchlist.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Watchlist? getById(String watchlistId) {
    final all = getAll();
    try {
      return all.firstWhere((w) => w.id == watchlistId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveAll(List<Watchlist> watchLists) async {
    final encoded = jsonEncode(watchLists.map((w) => w.toJson()).toList());
    await AppStorage.write(AppStorageKeys.watchLists, encoded);
  }

  Future<void> create(Watchlist watchlist) async {
    final all = getAll();
    all.add(watchlist);
    await _saveAll(all);
  }

  Future<void> rename(String watchlistId, String newName) async {
    final all = getAll();
    final index = all.indexWhere((w) => w.id == watchlistId);
    if (index == -1) return;
    all[index] = all[index].copyWith(name: newName);
    await _saveAll(all);
  }

  Future<void> delete(String watchlistId) async {
    final all = getAll();
    all.removeWhere((w) => w.id == watchlistId);
    await _saveAll(all);
  }

  Future<void> updateSymbols(String watchlistId, List<String> symbols) async {
    final all = getAll();
    final index = all.indexWhere((w) => w.id == watchlistId);
    if (index == -1) return;
    all[index] = all[index].copyWith(symbols: symbols);
    await _saveAll(all);
  }

  Future<void> clear() async {
    await AppStorage.write(AppStorageKeys.watchLists, jsonEncode(<dynamic>[]));
  }
}
