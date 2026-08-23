import 'package:decimal/decimal.dart';

class Holding {
  final String symbol;
  final int quantity;
  final Decimal avgCost;

  const Holding({
    required this.symbol,
    required this.quantity,
    required this.avgCost,
  });

  Decimal get investedValue => avgCost * Decimal.fromInt(quantity);

  Decimal currentValue(Decimal ltp) => ltp * Decimal.fromInt(quantity);

  Decimal pnl(Decimal ltp) => currentValue(ltp) - investedValue;

  double pnlPercent(Decimal ltp) {
    if (investedValue == Decimal.zero) return 0;
    return (pnl(ltp) / investedValue).toDouble() * 100;
  }

  Holding addBuy({required int buyQty, required Decimal buyPrice}) {
    final newQty = quantity + buyQty;
    final newInvested = investedValue + (buyPrice * Decimal.fromInt(buyQty));
    final newAvgCost = (newInvested / Decimal.fromInt(newQty)).toDecimal(scaleOnInfinitePrecision: 4);
    return Holding(symbol: symbol, quantity: newQty, avgCost: newAvgCost);
  }

  Holding? reduceBySell({required int sellQty}) {
    final newQty = quantity - sellQty;
    if (newQty <= 0) return null;
    return Holding(symbol: symbol, quantity: newQty, avgCost: avgCost);
  }

  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      symbol: json['symbol'] ?? '',
      quantity: json['quantity'] ?? 0,
      avgCost: Decimal.tryParse(json['avgCost'] ?? '') ?? Decimal.zero,
    );
  }

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'quantity': quantity,
        'avgCost': avgCost.toString(),
      };
}
