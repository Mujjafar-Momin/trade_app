import 'package:flutter/material.dart';
import 'package:trading_app/trade_app.dart';

/// [StockPickerSheet]
/// Modal bottom sheet showing the 10 stocks NOT already in the current
/// watchlist. Tapping one adds it and closes the sheet.
class StockPickerSheet extends StatelessWidget {
  final List<String> availableSymbols;
  final void Function(String symbol) onPick;

  const StockPickerSheet({super.key, required this.availableSymbols, required this.onPick});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Text('Add Stock', style: AppTextStyles.semibold16.copyWith(color: colors.textPrimary)),
            const SizedBox(height: 8),
            if (availableSymbols.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'All 10 stocks are already in this watchlist.',
                  style: AppTextStyles.regular14.copyWith(color: colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableSymbols.length,
                  itemBuilder: (context, index) {
                    final symbol = availableSymbols[index];
                    return ListTile(
                      title: Text(symbol, style: AppTextStyles.medium16.copyWith(color: colors.textPrimary)),
                      trailing: Icon(Icons.add_circle_outline_rounded, color: colors.primary),
                      onTap: () {
                        onPick(symbol);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Convenience opener — computes the "not yet added" list from the
/// controller's current symbols and MarketFeedService's fixed 10, then
/// shows the sheet.
Future<void> showStockPicker(BuildContext context, WatchlistDetailController controller) {
  final available = MarketFeedService().symbols.where((s) => !controller.symbols.contains(s)).toList();
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (_) => StockPickerSheet(availableSymbols: available, onPick: controller.addStock),
  );
}