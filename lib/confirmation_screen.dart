import 'package:flutter/material.dart';
import 'main.dart';
import 'utils.dart';
import 'orderStorage.dart';

class ConfirmationScreen extends StatelessWidget {
  final String customerName;
  final Map<ItemType, MenuItem?> selectedItems;
  final double total;

  const ConfirmationScreen({
    super.key,
    required this.customerName,
    required this.selectedItems,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final selectedList = selectedItems.values.whereType<MenuItem>().toList();
    final subtotal = selectedList.fold(0.0, (sum, item) => sum + item.price);
    final discountRate = calculateDiscountRate(selectedItems);
    final discount = subtotal * discountRate;

WidgetsBinding.instance.addPostFrameCallback((_) {
     OrderStorage.saveOrder(customerName, selectedItems, total);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Pedido Confirmado')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Obrigado, $customerName!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Seu pedido:'),
            const SizedBox(height: 8),
            ...selectedList.map((item) {
              final discounted = item.price * (1 - discountRate);
              return ListTile(
                leading: Image.network(item.imageUrl, width: 36, height: 36),
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
                      'R\$ ${discounted.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),                
              );
            }),
            const Divider(height: 32),
            Text(
              'Subtotal: R\$ ${subtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
              ),
              Text(
              discountRate > 0
                  ? 'Desconto de ${(discountRate * 100).toInt()}%: -R\$ ${discount.toStringAsFixed(2)}'
                  : 'Desconto: R\$ 0,00',
                      style: const TextStyle(fontSize: 16, 
                      color: Colors.green),
                    ),
              const SizedBox(height: 8),
              Text(
                'Total: R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  ),            
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Voltar ao Início'),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
