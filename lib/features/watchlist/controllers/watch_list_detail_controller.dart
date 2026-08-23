import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class WatchlistDetailController extends GetxController {
  final String watchlistId;

  WatchlistDetailController({required this.watchlistId});

  final WatchlistRepository _repository = WatchlistRepository();
  Watchlist? watchlist;
  List<String> symbols = [];

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    watchlist = _repository.getById(watchlistId);
    symbols = watchlist == null ? [] : List<String>.from(watchlist!.symbols);
    update();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex -= 1;
    final symbol = symbols.removeAt(oldIndex);
    symbols.insert(newIndex, symbol);
    update();
    await _repository.updateSymbols(watchlistId, symbols);
  }

  Future<void> addStock(String symbol) async {
    if (symbols.contains(symbol)) return;
    symbols.add(symbol);
    update();
    await _repository.updateSymbols(watchlistId, symbols);
  }

  Future<void> removeStock(String symbol) async {
    symbols.remove(symbol);
    update();
    await _repository.updateSymbols(watchlistId, symbols);
  }

  void onRowTap(String symbol) {
    Get.to(
      () => const BuySellScreen(),
      binding: BuySellBinding(symbol: symbol, initialSide: OrderSide.buy),
    );
  }
}
