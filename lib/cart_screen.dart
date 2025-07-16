import 'package:bom_hamburguer/payment_screen.dart';
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
            const Text('Seu pedido:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...selectedList.map((item) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 2,
                child: ListTile(
                  leading: Image.network(item.imageUrl, width: 40, height: 40),
                  title: Text(item.name),
                  trailing: Text('R\$ ${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              )),
              const Divider(height: 32),
              Text('Subtotal: R\$ ${subtotal.toStringAsFixed(2)}'),
              Text('Desconto: R\$ ${discount.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Total: R\$ ${total.toStringAsFixed(2)}',
               style: const TextStyle(fontSize: 18,
                fontWeight: FontWeight.bold),
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