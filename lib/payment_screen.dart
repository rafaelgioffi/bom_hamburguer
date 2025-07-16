import 'package:flutter/material.dart';
import 'main.dart';
import 'confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<ItemType, MenuItem?> selectedItems;
  final double discountRate;
  final double total;

  const PaymentScreen({
    super.key,
    required this.selectedItems,
    required this.discountRate,
    required this.total,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _finalizeOrder() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmationScreen(
            customerName: _nameController.text,
            selectedItems: widget.selectedItems,
            discountRate: widget.discountRate,
            total: widget.total,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedList = widget.selectedItems.values.whereType<MenuItem>().toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Qual seu nome?',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite seu nome' : null,
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child:
              Text('Resumo do pedido:',
                   style: TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                     ),
                   ),
            Text(
              'Total a pagar: R\$ ${widget.total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _finalizeOrder,
                icon: const Icon(Icons.check_circle),
                label: const Text('Finalizar Pedido'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
