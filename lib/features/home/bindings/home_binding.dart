import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<WatchlistController>(() => WatchlistController());
    Get.lazyPut<MarketController>(() => MarketController());
    Get.lazyPut<HoldingsController>(() => HoldingsController());
  }
}