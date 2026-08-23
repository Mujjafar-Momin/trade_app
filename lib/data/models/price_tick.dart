import 'package:decimal/decimal.dart';
import 'package:trading_app/data/models/stock.dart';

class PriceTick {
  final String symbol;
  final Decimal ltp;
  final Decimal prevClose;
  final DateTime updatedAt;
  final bool isUp;

  const PriceTick({
    required this.symbol,
    required this.ltp,
    required this.prevClose,
    required this.updatedAt,
    required this.isUp,
  });

  factory PriceTick.initial(Stock stock) {
    return PriceTick(
      symbol: stock.symbol,
      ltp: stock.basePrice,
      prevClose: stock.prevClose,
      updatedAt: DateTime.now(),
      isUp: stock.basePrice >= stock.prevClose,
    );
  }

  Decimal get change => ltp - prevClose;

  double get changePercent {
    if (prevClose == Decimal.zero) return 0;
    return (change / prevClose).toDouble() * 100;
  }

  PriceTick copyWith({
    Decimal? ltp,
    DateTime? updatedAt,
    bool? isUp,
  }) {
    return PriceTick(
      symbol: symbol,
      ltp: ltp ?? this.ltp,
      prevClose: prevClose,
      updatedAt: updatedAt ?? this.updatedAt,
      isUp: isUp ?? this.isUp,
    );
  }
}
