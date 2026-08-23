import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:trading_app/data/models/stock.dart';


class MarketRepository {
  static const _assetPath = 'assets/data/stocks.json';

  Future<List<Stock>> fetchStocks() async {
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['stocks'] as List<dynamic>;

    return list.map((e) => Stock.fromJson(e as Map<String, dynamic>)).toList(growable: false);
  }
}
