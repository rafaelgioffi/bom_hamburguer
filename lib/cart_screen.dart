import 'package:flutter/material.dart';
import 'main.dart';
import 'payment_screen.dart';
import 'utils.dart';

class CartScreen extends StatelessWidget {
  final Map<ItemType, MenuItem?> selectedItems;

  const CartScreen({super.key, required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    final selectedList = selectedItems.values.whereType<MenuItem>().toList();
    final discountRate = calculateDiscountRate(selectedItems);
    final subtotal = selectedList.fold(0.0, (sum, item) => sum + item.price);
    final discount = subtotal * discountRate;
    final total = subtotal - discount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Carrinho')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seu pedido:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...selectedList.map((item) {
              final discountedPrice = item.price * (1 - discountRate);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 2,
                child: ListTile(
                  leading: Image.network(item.imageUrl, width: 40, height: 40),
                  title: Text(item.name),
                  subtitle: Row(
                    children: [
                      Text(
                        'R\$ ${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'R\$ ${discountedPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: discountRate > 0
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${(discountRate * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                ),
              );
            }),
            const Divider(height: 32),
            Text('Subtotal: R\$ ${subtotal.toStringAsFixed(2)}'),
            Text(
              discountRate > 0
                  ? 'Desconto de ${(discountRate * 100).toInt()}%: -R\$ ${discount.toStringAsFixed(2)}'
                  : 'Desconto: R\$ 0,00',
              style: TextStyle(
                color: discountRate > 0 ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total: R\$ ${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                        selectedItems: selectedItems,                        
                        total: total,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.payment),
                label: const Text('Ir para Pagamento'),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
