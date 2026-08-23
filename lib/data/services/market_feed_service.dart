import 'dart:async';
import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:get/get.dart';
import 'package:trading_app/data/models/price_tick.dart';
import 'package:trading_app/data/repositories/market_api_repository.dart';

class MarketFeedService {
  MarketFeedService._internal();

  static final MarketFeedService _instance = MarketFeedService._internal();

  factory MarketFeedService() => _instance;

  final MarketRepository _api = MarketRepository();
  final Random _random = Random();

  final Map<String, Rx<PriceTick>> prices = {};
  final List<String> symbols = [];
  final RxBool isLoading = true.obs;
  final RxString loadError = ''.obs;

  final Map<String, Timer> _tickers = {};

  final Map<String, Duration> _tickIntervals = {};
  static const Duration _minTickInterval = Duration(seconds: 1);
  static const Duration _maxTickInterval = Duration(seconds: 5);

  bool _initialized = false;

  static const double _maxDriftPercent = 10.0;

  Future<MarketFeedService> init() async {
    if (_initialized) return this;
    _initialized = true;

    try {
      final stocks = await _api.fetchStocks();
      for (final stock in stocks) {
        symbols.add(stock.symbol);
        prices[stock.symbol] = PriceTick.initial(stock).obs;
        _tickIntervals[stock.symbol] = _randomInterval();
      }
      isLoading.value = false;
      _startTicking();
    } catch (e) {
      loadError.value = 'Failed to load market data: $e';
      isLoading.value = false;
    }
    return this;
  }

  PriceTick? snapshot(String symbol) => prices[symbol]?.value;

  Duration _randomInterval() {
    final rangeMs = _maxTickInterval.inMilliseconds - _minTickInterval.inMilliseconds;
    return Duration(milliseconds: _minTickInterval.inMilliseconds + _random.nextInt(rangeMs + 1));
  }

  void _startTicking() {
    _stopTicking();
    for (final symbol in symbols) {
      _scheduleNextTick(symbol);
    }
  }

  void _stopTicking() {
    for (final timer in _tickers.values) {
      timer.cancel();
    }
    _tickers.clear();
  }

  void _scheduleNextTick(String symbol) {
    final interval = _tickIntervals[symbol] ?? _randomInterval();
    _tickers[symbol] = Timer(interval, () => _tickOne(symbol));
  }

  void _tickOne(String symbol) {
    final rx = prices[symbol];
    if (rx != null) {
      rx.value = _nextTick(rx.value);
    }
    _scheduleNextTick(symbol);
  }

  PriceTick _nextTick(PriceTick current) {
    final isSpike = _random.nextInt(50) == 0;
    final maxPct = isSpike ? 1.2 : 0.3;
    final pct = (_random.nextDouble() * 2 - 1) * maxPct;

    final deltaFactor = Decimal.parse((pct / 100).toStringAsFixed(6));
    var nextLtp = current.ltp + (current.ltp * deltaFactor);
    final band = current.prevClose * Decimal.parse((_maxDriftPercent / 100).toStringAsFixed(4));
    final upperBound = current.prevClose + band;
    final lowerBound = current.prevClose - band;
    if (nextLtp > upperBound) nextLtp = upperBound;
    if (nextLtp < lowerBound) nextLtp = lowerBound;

    if (nextLtp <= Decimal.zero) nextLtp = current.ltp;

    nextLtp = _roundTo2dp(nextLtp);

    return current.copyWith(
      ltp: nextLtp,
      updatedAt: DateTime.now(),
      isUp: nextLtp >= current.ltp,
    );
  }

  Decimal _roundTo2dp(Decimal value) {
    final scaled = (value * Decimal.fromInt(100)).round();
    return (scaled / Decimal.fromInt(100)).toDecimal(scaleOnInfinitePrecision: 2);
  }

  void setTickIntervalRange({required Duration min, required Duration max}) {
    final rangeMs = max.inMilliseconds - min.inMilliseconds;
    for (final symbol in symbols) {
      _tickIntervals[symbol] = Duration(milliseconds: min.inMilliseconds + _random.nextInt(rangeMs + 1));
    }
    if (!isLoading.value) _startTicking();
  }

  void setUniformTickInterval(Duration interval) {
    for (final symbol in symbols) {
      _tickIntervals[symbol] = interval;
    }
    if (!isLoading.value) _startTicking();
  }

  Duration intervalFor(String symbol) => _tickIntervals[symbol] ?? _maxTickInterval;

  void dispose() {
    _stopTicking();
  }
}
