import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class WatchlistDetailBinding extends Bindings {
  final String watchlistId;

  WatchlistDetailBinding({required this.watchlistId});

  @override
  void dependencies() {
    Get.lazyPut<WatchlistDetailController>(() => WatchlistDetailController(watchlistId: watchlistId));
  }
}
