import 'package:flutter/material.dart';
import 'package:goods_repository/goods_repository.dart';

class GoodsListTitle extends StatelessWidget {
  const GoodsListTitle({
    super.key,
    required this.goods,
    this.onToggleAtStore,
    this.onDismissed,
    this.onTap,
  });

  final Goods goods;
  final ValueChanged<bool>? onToggleAtStore;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;

    return Dismissible(
      key: Key('goodsListTile_dismissible_${goods.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          goods.name == '' ? '-' : goods.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: !goods.atStore
              ? null
              : TextStyle(
                  color: captionColor,
                  decoration: TextDecoration.lineThrough,
                ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Capacity: ${goods.capacity}'),
            Text('Quantity: ${goods.quantity}'),
            Text('Sold Quantity: ${goods.soldQuantity}'),
            Text(
                'Purchase Date: ${'${goods.purchaseDate.toLocal()}'.split(' ')[0]}'),
            Text(
                'Expiration Date: ${'${goods.expirationDate.toLocal()}'.split(' ')[0]}'),
          ],
        ),
        leading: Checkbox(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          value: goods.atStore,
          onChanged: onToggleAtStore == null
              ? null
              : (value) => onToggleAtStore!(value!),
        ),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      ),
    );
  }
}
