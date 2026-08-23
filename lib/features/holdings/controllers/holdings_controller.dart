import 'dart:async';
import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

enum HoldingsSortBy { pnl, symbol, value }

class HoldingsController extends GetxController {
  final HoldingsRepository _repository = HoldingsRepository();
  final MarketFeedService _feed = MarketFeedService();

  List<Holding> holdings = [];
  HoldingsSortBy sortBy = HoldingsSortBy.pnl;

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    _load();
    _refreshTimer = Timer.periodic(const Duration(milliseconds: 500), (_) => _load());
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  void _load() {
    holdings = _repository.getAll().values.toList();
    _applySort();
    update();
  }

  /// Call after a Buy/Sell order succeeds so Holdings reflects it
  /// immediately instead of waiting up to 500ms for the next periodic
  /// refresh.
  ///
  /// NOTE: deliberately NOT named `refresh()` — that name is already
  /// defined by GetX's own ListNotifierMixin (which GetxController uses
  /// internally), and update() calls it to notify listeners. Overriding
  /// it here caused update() -> refresh() (our override) -> _load() ->
  /// update() -> ... an infinite loop / StackOverflowError.
  void refreshData() => _load();

  void setSort(HoldingsSortBy sort) {
    sortBy = sort;
    _applySort();
    update();
  }

  void _applySort() {
    switch (sortBy) {
      case HoldingsSortBy.pnl:
        holdings.sort((a, b) => _pnl(b).compareTo(_pnl(a))); // descending
      case HoldingsSortBy.symbol:
        holdings.sort((a, b) => a.symbol.compareTo(b.symbol));
      case HoldingsSortBy.value:
        holdings.sort((a, b) => _currentValue(b).compareTo(_currentValue(a))); // descending
    }
  }

  Decimal _ltp(String symbol) => _feed.snapshot(symbol)?.ltp ?? Decimal.zero;

  Decimal _pnl(Holding h) => h.pnl(_ltp(h.symbol));

  Decimal _currentValue(Holding h) => h.currentValue(_ltp(h.symbol));

  void onRowTap(String symbol) {
    Get.to(
      () => const BuySellScreen(),
      binding: BuySellBinding(symbol: symbol, initialSide: OrderSide.sell),
    );
  }
}
