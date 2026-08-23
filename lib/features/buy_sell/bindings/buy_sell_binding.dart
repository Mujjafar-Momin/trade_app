import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class BuySellBinding extends Bindings {
  final String symbol;
  final OrderSide initialSide;

  BuySellBinding({required this.symbol, this.initialSide = OrderSide.buy});

  @override
  void dependencies() {
    Get.lazyPut<BuySellController>(() => BuySellController(symbol: symbol, initialSide: initialSide));
  }
}