import 'package:decimal/decimal.dart';
import 'package:trading_app/data/models/order_side.dart';

class Order {
  final String id;
  final String symbol;
  final OrderSide side;
  final int quantity;
  final Decimal priceAtExecution;
  final DateTime timestamp;

  const Order({
    required this.id,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.priceAtExecution,
    required this.timestamp,
  });

  Decimal get value => priceAtExecution * Decimal.fromInt(quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      side: OrderSideX.fromString(json['side'] ?? ''),
      quantity: json['quantity'] ?? 0,
      priceAtExecution: Decimal.tryParse(json['priceAtExecution'] ?? '') ?? Decimal.zero,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'symbol': symbol,
        'side': side.name,
        'quantity': quantity,
        'priceAtExecution': priceAtExecution.toString(),
        'timestamp': timestamp.toIso8601String(),
      };
}
