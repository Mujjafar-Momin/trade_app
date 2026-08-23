import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GetBuilder<WatchlistController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Watch Lists')),
          body: controller.watchLists.isEmpty
              ? _EmptyState(onCreate: () => _showCreateDialog(context, controller))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.watchLists.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final watchlist = controller.watchLists[index];
                    return _WatchlistTile(
                      name: watchlist.name,
                      stockCount: watchlist.symbols.length,
                      onTap: () {
                        Get.to(
                          () => const WatchlistDetailScreen(),
                          binding: WatchlistDetailBinding(watchlistId: watchlist.id),
                        )?.then(
                          (value) {
                            controller.reloadData();
                          },
                        );
                      },
                      onRename: () => _showRenameDialog(context, controller, watchlist),
                      onDelete: () => _confirmDelete(context, controller, watchlist),
                    );
                  },
                ),
          floatingActionButton: controller.watchLists.isEmpty
              ? null
              : FloatingActionButton(
                  onPressed: () => _showCreateDialog(context, controller),
                  backgroundColor: colors.primary,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
        );
      },
    );
  }

  void _showCreateDialog(BuildContext context, WatchlistController controller) {
    _showNameDialog(
      context: context,
      title: 'New watchlist',
      confirmLabel: 'Create',
      onConfirm: (name) => controller.createWatchlist(name),
    );
  }

  void _showRenameDialog(BuildContext context, WatchlistController controller, Watchlist watchlist) {
    _showNameDialog(
      context: context,
      title: 'Rename watchlist',
      confirmLabel: 'Save',
      initialValue: watchlist.name,
      onConfirm: (name) => controller.renameWatchlist(watchlist.id, name),
    );
  }

  void _showNameDialog({
    required BuildContext context,
    required String title,
    required String confirmLabel,
    required Future<bool> Function(String) onConfirm,
    String initialValue = '',
  }) {
    final textController = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title, style: AppTextStyles.semibold16),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Watchlist name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final success = await onConfirm(textController.text);
                if (success && dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WatchlistController controller, Watchlist watchlist) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final colors = context.appColors;
        return AlertDialog(
          title: const Text('Delete watchlist?'),
          content: Text('This will remove "${watchlist.name}" and its stock list. This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteWatchlist(watchlist.id);
                Navigator.of(dialogContext).pop();
              },
              child: Text('Delete', style: TextStyle(color: colors.error)),
            ),
          ],
        );
      },
    );
  }
}

class _WatchlistTile extends StatelessWidget {
  final String name;
  final int stockCount;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const _WatchlistTile({
    required this.name,
    required this.stockCount,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.semibold16.copyWith(color: colors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(
                      '$stockCount ${stockCount == 1 ? 'stock' : 'stocks'}',
                      style: AppTextStyles.regular12.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'rename') onRename();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'rename', child: Text('Rename')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.list_alt_rounded, size: 48, color: colors.textDisabled),
            const SizedBox(height: 16),
            Text(
              'No watchlists yet',
              style: AppTextStyles.semibold16.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              'Create a watchlist to start tracking stocks.',
              style: AppTextStyles.regular14.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: onCreate,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Create watchlist'),
                )),
          ],
        ),
      ),
    );
  }
}
