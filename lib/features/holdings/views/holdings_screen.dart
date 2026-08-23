import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class HoldingsScreen extends StatelessWidget {
  const HoldingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HoldingsController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Holdings'),
            actions: [
              PopupMenuButton<HoldingsSortBy>(
                onSelected: controller.setSort,
                icon: const Icon(Icons.sort_rounded),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: HoldingsSortBy.pnl, child: Text('Sort by P&L')),
                  PopupMenuItem(value: HoldingsSortBy.symbol, child: Text('Sort by Symbol')),
                  PopupMenuItem(value: HoldingsSortBy.value, child: Text('Sort by Value')),
                ],
              ),
            ],
          ),
          body: controller.holdings.isEmpty
              ? const _EmptyHoldings()
              : Column(
                  children: [
                    _AggregateSummary(holdings: controller.holdings),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        itemCount: controller.holdings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final holding = controller.holdings[index];
                          return _HoldingRow(
                            holding: holding,
                            onTap: () => controller.onRowTap(holding.symbol),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

/// Sums P&L/value live by reading each holding's own Rx<PriceTick> inside
/// Obx — this ties the aggregate directly to the same feed ticks driving
/// each row, so it's never out of sync with what's on screen, regardless
/// of HoldingsController's slower 500ms resort cadence.
class _AggregateSummary extends StatelessWidget {
  final List<Holding> holdings;

  const _AggregateSummary({required this.holdings});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final feed = MarketFeedService();

    return Obx(() {
      var totalInvested = Decimal.zero;
      var totalCurrent = Decimal.zero;

      for (final h in holdings) {
        final tick = feed.prices[h.symbol]!.value; // Obx subscribes to each
        totalInvested += h.investedValue;
        totalCurrent += h.currentValue(tick.ltp);
      }

      final totalPnl = totalCurrent - totalInvested;
      final totalPnlPct = totalInvested == Decimal.zero ? 0.0 : (totalPnl / totalInvested).toDouble() * 100;
      final Color pnlColor;
      if (totalPnl == Decimal.zero) {
        pnlColor = colors.neutral;
      } else if (totalPnl < Decimal.zero) {
        pnlColor = colors.error;
      } else {
        pnlColor = colors.success;
      }

      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SummaryStat(label: 'Invested', value: '₹$totalInvested'),
                _SummaryStat(label: 'Current Value', value: '₹$totalCurrent'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Total P&L', style: AppTextStyles.regular12.copyWith(color: colors.textSecondary)),
                const Spacer(),
                Text(
                  '${totalPnl < Decimal.zero ? '' : '+'}₹$totalPnl (${totalPnlPct.toStringAsFixed(2)}%)',
                  style: AppTextStyles.semibold16.copyWith(color: pnlColor),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.regular12.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.semibold14.copyWith(color: colors.textPrimary)),
      ],
    );
  }
}

class _HoldingRow extends StatelessWidget {
  final Holding holding;
  final VoidCallback onTap;

  const _HoldingRow({required this.holding, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Obx(() {
            final tick = MarketFeedService().prices[holding.symbol]!.value;
            final pnl = holding.pnl(tick.ltp);
            final pnlPct = holding.pnlPercent(tick.ltp);
            final Color pnlColor;
            if (pnl == Decimal.zero) {
              pnlColor = colors.neutral;
            } else if (pnl < Decimal.zero) {
              pnlColor = colors.error;
            } else {
              pnlColor = colors.success;
            }

            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(holding.symbol, style: AppTextStyles.semibold14.copyWith(color: colors.textPrimary)),
                      const SizedBox(height: 2),
                      Text(
                        '${holding.quantity} @ ₹${holding.avgCost}',
                        style: AppTextStyles.regular12.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${holding.currentValue(tick.ltp)}',
                        style: AppTextStyles.semibold14.copyWith(color: colors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${pnl < Decimal.zero ? '' : '+'}₹$pnl (${pnlPct.toStringAsFixed(2)}%)',
                        style: AppTextStyles.regular12.copyWith(color: pnlColor),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _EmptyHoldings extends StatelessWidget {
  const _EmptyHoldings();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pie_chart_outline_rounded, size: 48, color: colors.textDisabled),
            const SizedBox(height: 16),
            Text('No holdings yet', style: AppTextStyles.semibold16.copyWith(color: colors.textPrimary)),
            const SizedBox(height: 6),
            Text(
              'Buy a stock to see it appear here.',
              style: AppTextStyles.regular14.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
