import 'package:flutter/material.dart';
import 'main.dart';

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

    return Scaffold(
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
            const SizedBox(height: 12),
            ...selectedList.map(
              (item) => ListTile(
                leading: Image.network(item.imageUrl, width: 40, height: 40),
                title: Text(item.name),
                trailing: Text('R\$ ${item.price.toStringAsFixed(2)}'),
              ),
            ),
            const Divider(height: 32),
            Text(
              'Total: R\$ ${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
