import 'package:trading_app/trade_app.dart';

class OrderService {
  OrderService._internal();

  static final OrderService _instance = OrderService._internal();

  factory OrderService() => _instance;

  final MarketFeedService _feed = MarketFeedService();
  final WalletService _wallet = WalletService();
  final OrderRepository _orderRepository = OrderRepository();
  final HoldingsRepository _holdingsRepository = HoldingsRepository();

  Future<OrderResult> submit({
    required String symbol,
    required OrderSide side,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      return OrderResult.failure('Quantity must be a positive whole number.');
    }

    final tick = _feed.snapshot(symbol);
    if (tick == null) {
      return OrderResult.failure('No live price available for $symbol.');
    }
    final ltp = tick.ltp;
    final orderValue = ltp * Decimal.fromInt(quantity);

    if (side == OrderSide.buy) {
      if (!_wallet.canAfford(orderValue)) {
        return OrderResult.failure(
          'Insufficient balance. Order value ₹$orderValue exceeds available balance.',
        );
      }
    } else {
      final held = _holdingsRepository.getForSymbol(symbol);
      final heldQty = held?.quantity ?? 0;
      if (quantity > heldQty) {
        return OrderResult.failure(
          'Cannot sell $quantity shares — only $heldQty held.',
        );
      }
    }

    final order = Order(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      symbol: symbol,
      side: side,
      quantity: quantity,
      priceAtExecution: ltp,
      timestamp: DateTime.now(),
    );

    await _orderRepository.add(order);

    if (side == OrderSide.buy) {
      await _wallet.debit(orderValue);
      await _holdingsRepository.applyBuy(
        symbol: symbol,
        qty: quantity,
        buyPrice: ltp,
      );
    } else {
      await _wallet.credit(orderValue);
      await _holdingsRepository.applySell(symbol: symbol, qty: quantity);
    }

    return OrderResult.success(order);
  }
}
