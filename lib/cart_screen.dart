import 'package:flutter/material.dart';
import 'main.dart';

class CartScreen extends StatelessWidget {
  final Map<ItemType, MenuItem?> selectedItems;

  const CartScreen({super.key, required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    final selectedList = selectedItems.values.whereType<MenuItem>().toList();
    final subtotal = selectedList.fold(0.0, (sum, item) => sum + item.price);
    final discount = _calculateDiscount(selectedItems);
    final total = subtotal - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Itens selecionados:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...selectedList.map((item) => Text('${item.name} - R\$ ${item.price.toStringAsFixed(2)}')),
              const Divider(height: 24),
              Text('Subtotal: R\$ ${subtotal.toStringAsFixed(2)}'),
              Text('Desconto: R\$ ${discount.toStringAsFixed(2)}'),
              Text('Total: R\$ ${total.toStringAsFixed(2)}',
               style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    //Implementar depois.. tela de pagamentos...
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('Pagar'),
                  ),
              ),              
          ],
        ),
        ),
    );
  }

double _calculateDiscount(Map<ItemType, MenuItem?> items) {
  final hasSandwich = items[ItemType.sandwich] != null;
  final hasFries = items[ItemType.fries] != null;
  final hasDrink = items[ItemType.drink] != null;

  //Validações...
  //Se tiver hambúrguer, batata e bebida, 20% de desconto...
  if (hasSandwich && hasFries && hasDrink) {
    return _sum(items) * 0.20;
    //se tiver sanduiche e bebida, 15% de desconto...
  } else if (hasSandwich && hasDrink) {
return _sum(items) * 0.15;
  }
  //se tiver hambúrguer e batata, 10% de desconto...
  else if (hasSandwich && hasFries) {
    return _sum(items) * 0.10;
  }
  return 0;
}

double _sum(Map<ItemType, MenuItem?> items) {
  return items.values
  .whereType<MenuItem>()
  .fold(0.0, (sum, item) => sum + item.price);
}
}