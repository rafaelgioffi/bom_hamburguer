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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
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
  final String imageUrl;

  const MenuItem({
    required this.name,
    required this.price,
    required this.type,
    required this.imageUrl,
  });
}

class _MenuScreenState extends State<MenuScreen> {
  final List<MenuItem> menuItens = const [
    MenuItem(
      name: 'X-Burguer',
      price: 5.00,
      type: ItemType.sandwich,
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png',
    ),
    MenuItem(
      name: 'X-Egg',
      price: 4.50,
      type: ItemType.sandwich,
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/1858/1858002.png',
    ),
    MenuItem(
      name: 'X-Bacon',
      price: 7.00,
      type: ItemType.sandwich,
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/5098/5098990.png',
    ),
    MenuItem(
      name: 'Fries',
      price: 2.00,
      type: ItemType.fries,
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/1046/1046786.png',
    ),
    MenuItem(
      name: 'Soft Drink',
      price: 2.50,
      type: ItemType.drink,
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/5825/5825459.png',
    ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('BOM HAMBURGUER'), centerTitle: true),
      body: ListView.builder(
        itemCount: menuItens.length,
        itemBuilder: (context, index) {
          final item = menuItens[index];
          final isSelected = selectedItems[item.type] == item;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: isSelected ? Colors.deepOrange.shade50 : null,
            elevation: 2,
            child: ListTile(
              leading: Image.network(item.imageUrl, width: 50, height: 50),
              title: Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('R\$ ${item.price.toStringAsFixed(2)}'),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.add_circle_outline),
              onTap: () => toggleSelection(item),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
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
