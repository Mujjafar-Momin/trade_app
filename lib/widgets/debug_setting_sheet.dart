import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class DebugSettingsSheet extends StatelessWidget {
  const DebugSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Text('Debug Settings', style: AppTextStyles.semibold16.copyWith(color: colors.textPrimary)),
            const SizedBox(height: 4),
            Text(
              'Tick rate',
              style: AppTextStyles.medium14.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 10),
            _TickRateOption(
              label: 'Normal (1–5s, per-stock)',
              subtitle: 'Each stock ticks independently at its own random pace',
              onTap: () => MarketFeedService().setTickIntervalRange(
                min: const Duration(seconds: 1),
                max: const Duration(seconds: 5),
              ),
            ),
            _TickRateOption(
              label: 'Fast (500ms, uniform)',
              subtitle: '2 ticks/sec per stock',
              onTap: () => MarketFeedService().setUniformTickInterval(const Duration(milliseconds: 500)),
            ),
            _TickRateOption(
              label: 'Stress test (200ms, uniform)',
              subtitle: '5 ticks/sec per stock = 50 ticks/sec overall',
              onTap: () => MarketFeedService().setUniformTickInterval(const Duration(milliseconds: 200)),
            ),
            const SizedBox(height: 20),
            Divider(color: colors.border),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _confirmReset(context),
                style: OutlinedButton.styleFrom(foregroundColor: colors.error, side: BorderSide(color: colors.error)),
                child: const Text('Reset Demo Data'),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Resets wallet balance, orders, and holdings. Watchlists are kept.',
              textAlign: TextAlign.center,
              style: AppTextStyles.regular12.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset demo data?'),
          content: const Text('Wallet balance, order history, and holdings will be cleared. This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _resetDemoData();
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                if (context.mounted) Navigator.of(context).pop(); // close the sheet too
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetDemoData() async {
    await WalletService().reset();
    await OrderRepository().clear();
    await HoldingsRepository().clear();

    MarketFeedService().setTickIntervalRange(
      min: const Duration(seconds: 1),
      max: const Duration(seconds: 5),
    );

    if (Get.isRegistered<HoldingsController>()) {
      Get.find<HoldingsController>().refreshData();
    }
  }
}

class _TickRateOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _TickRateOption({required this.label, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: AppTextStyles.medium14.copyWith(color: colors.textPrimary)),
      subtitle: Text(subtitle, style: AppTextStyles.regular12.copyWith(color: colors.textSecondary)),
      trailing: Icon(Icons.chevron_right_rounded, color: colors.textDisabled),
      onTap: onTap,
    );
  }
}

/// Opens the sheet — call from any AppBar action:
/// `IconButton(icon: Icon(Icons.tune), onPressed: () => showDebugSettingsSheet(context))`
Future<void> showDebugSettingsSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (_) => const DebugSettingsSheet(),
  );
}
