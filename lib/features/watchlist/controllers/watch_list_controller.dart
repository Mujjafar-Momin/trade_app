import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class WatchlistController extends GetxController {
  final WatchlistRepository _repository = WatchlistRepository();

  List<Watchlist> watchLists = [];

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    watchLists = _repository.getAll();
    update();
  }

  Future<bool> createWatchlist(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return false;

    final watchlist = Watchlist(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: trimmed,
    );
    await _repository.create(watchlist);
    _load();
    return true;
  }

  Future<bool> renameWatchlist(String id, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return false;

    await _repository.rename(id, trimmed);
    _load();
    return true;
  }

  Future<void> deleteWatchlist(String id) async {
    await _repository.delete(id);
    _load();
  }

  void reloadData() => _load();
}
