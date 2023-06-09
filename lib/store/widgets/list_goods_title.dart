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
      direction: DismissDirection.none, //DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: const Color.fromARGB(170, 7, 211, 72),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.remove,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          goods.name == '' ? '-' : goods.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('容量: ${goods.capacity}'),
            Text('單價: ${goods.unitPrice}'),
            Text('進貨數量: ${goods.quantity}'),
            Text('售出數量: ${goods.soldQuantity}'),
            Text('進貨日期: ${'${goods.purchaseDate.toLocal()}'.split(' ')[0]}'),
            Text('過期日期: ${'${goods.expirationDate.toLocal()}'.split(' ')[0]}'),
          ],
        ),
        trailing: Text(
          '${goods.atStoreQuantity}',
          //red
          style: theme.textTheme.displayMedium
              ?.copyWith(color: const Color(0xFFE57373)),
        ),
      ),
    );
  }
}
