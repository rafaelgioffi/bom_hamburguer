import 'package:bom_hamburguer/cart_screen.dart';
import 'package:flutter/material.dart';
import 'cart_screen.dart';

void main() {
  runApp(const BomHamburguerApp());
}

class BomHamburguerApp extends StatelessWidget {
  const BomHamburguerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bom hambúrguer',
      theme: ThemeData(        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

enum ItemType { sandwich, fries, drink }

class MenuItem {
  final String name;
  final double price;
  final ItemType type;

  const MenuItem({required this.name, required this.price, required this.type});
  }

  class _MenuScreenState extends State<MenuScreen> {
    final List<MenuItem> menuItens = const [
      MenuItem(name: 'X-Burguer', price: 5.00, type: ItemType.sandwich),
      MenuItem(name: 'X-Egg', price: 4.50, type: ItemType.sandwich),
      MenuItem(name: 'X-Bacon', price: 7.00, type: ItemType.sandwich),
      MenuItem(name: 'Fries', price: 2.00, type: ItemType.fries),
      MenuItem(name: 'Soft Drink', price: 2.50, type: ItemType.drink),
    ];

    final Map<ItemType, MenuItem?> selectedItems = {
      ItemType.sandwich: null,
      ItemType.fries: null,
      ItemType.drink: null,
    };

    void toggleSelection(MenuItem item) {
      setState(() {
        if (selectedItems[item.type] == item) {
          selectedItems[item.type] = null;
        } else {
          selectedItems[item.type] = item;
        }
      });
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOM HAMBURGUER'),
        centerTitle: true,
      ),
body: ListView.builder(
  itemCount: menuItens.length,
  itemBuilder: (context, index) {
    final item = menuItens[index];
    final isSelected = selectedItems[item.type] == item;

    return ListTile(
      title: Text('${item.name} - R\$ ${item.price.toStringAsFixed(2)}'),
      tileColor: isSelected ? Colors.green.shade100 : null,
      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
      onTap: () => toggleSelection(item),
    );
  },
),
bottomNavigationBar: Padding(padding: const EdgeInsets.all(16),
child: ElevatedButton.icon(
  onPressed: () {
Navigator.push(
  context, 
  MaterialPageRoute(
    builder: (context) => CartScreen(selectedItems: selectedItems),
    ),
  );
},
icon: const Icon(Icons.shopping_cart),
label: const Text('Carrinho'),
    ),
),
    );
  }
  }