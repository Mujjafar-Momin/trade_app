import 'package:trading_app/trade_app.dart';

class OrderResult {
  final bool success;
  final Order? order;
  final String? errorMessage;

  const OrderResult._({required this.success, this.order, this.errorMessage});

  factory OrderResult.success(Order order) => OrderResult._(success: true, order: order);

  factory OrderResult.failure(String message) => OrderResult._(success: false, errorMessage: message);
}
