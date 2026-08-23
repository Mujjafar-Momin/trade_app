import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class MarketController extends GetxController {
  final MarketFeedService _feed = MarketFeedService();

  List<String> get symbols => _feed.symbols;

  Rx<PriceTick> priceRxFor(String symbol) => _feed.prices[symbol]!;

  void onRowTap(String symbol) {
    Get.to(
      () => const BuySellScreen(),
      binding: BuySellBinding(symbol: symbol, initialSide: OrderSide.buy),
    );
  }
}
