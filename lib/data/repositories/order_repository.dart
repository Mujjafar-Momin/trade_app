import 'dart:convert';
import 'package:trading_app/data/models/order.dart';
import 'package:trading_app/data/services/storage_service.dart';

class OrderRepository {
  OrderRepository._internal();

  static final OrderRepository _instance = OrderRepository._internal();

  factory OrderRepository() => _instance;

  List<Order> getAll() {
    final raw = AppStorage.read<String>(AppStorageKeys.orders);
    if (raw == null) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final orders = decoded.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
      orders.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return orders;
    } catch (_) {
      return [];
    }
  }

  Future<void> add(Order order) async {
    final all = getAll();
    all.insert(0, order);
    await _saveAll(all);
  }

  List<Order> getForSymbol(String symbol) {
    return getAll().where((o) => o.symbol == symbol).toList();
  }

  Future<void> _saveAll(List<Order> orders) async {
    final encoded = jsonEncode(orders.map((o) => o.toJson()).toList());
    await AppStorage.write(AppStorageKeys.orders, encoded);
  }

  Future<void> clear() async {
    await AppStorage.write(AppStorageKeys.orders, jsonEncode(<dynamic>[]));
  }
}
