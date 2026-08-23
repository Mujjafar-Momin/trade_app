import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class WatchlistDetailScreen extends StatelessWidget {
  const WatchlistDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WatchlistDetailController>(
      builder: (controller) {
        if (controller.watchlist == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Watchlist')),
            body: const Center(child: Text('This watchlist no longer exists.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(controller.watchlist!.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: () => showStockPicker(context, controller),
              ),
            ],
          ),
          body: controller.symbols.isEmpty
              ? _EmptyState(onAdd: () => showStockPicker(context, controller))
              : ReorderableListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.symbols.length,
                  onReorder: controller.reorder,
                  itemBuilder: (context, index) {
                    final symbol = controller.symbols[index];
                    return _WatchlistStockRow(
                      key: ValueKey(symbol),
                      symbol: symbol,
                      onTap: () => controller.onRowTap(symbol),
                      onRemove: () => controller.removeStock(symbol),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _WatchlistStockRow extends StatelessWidget {
  final String symbol;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _WatchlistStockRow({super.key, required this.symbol, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(symbol, style: AppTextStyles.semibold14.copyWith(color: colors.textPrimary)),
                ),
                Expanded(
                  flex: 4,
                  child: PriceFlashCell(
                    priceRx: MarketFeedService().prices[symbol]!,
                    builder: (context, tick, dotColor) {
                      final Color directionColor;
                      if (tick.change == Decimal.zero) {
                        directionColor = colors.neutral;
                      } else if (tick.change < Decimal.zero) {
                        directionColor = colors.error;
                      } else {
                        directionColor = colors.success;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('₹${tick.ltp}', style: AppTextStyles.semibold14.copyWith(color: colors.textPrimary)),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${tick.change < Decimal.zero ? '' : '+'}${tick.change} (${tick.changePercent.toStringAsFixed(2)}%)',
                                  style: AppTextStyles.regular12.copyWith(color: directionColor),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, size: 20, color: colors.textSecondary),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.show_chart_rounded, size: 48, color: colors.textDisabled),
            const SizedBox(height: 16),
            Text('No stocks yet', style: AppTextStyles.semibold16.copyWith(color: colors.textPrimary)),
            const SizedBox(height: 6),
            Text(
              'Add stocks to start tracking them here.',
              style: AppTextStyles.regular14.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: onAdd,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Add stock'),
                )),
          ],
        ),
      ),
    );
  }
}
