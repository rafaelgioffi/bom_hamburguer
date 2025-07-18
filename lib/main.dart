import 'package:bom_hamburguer/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'cart_screen.dart';
import 'orderStorage.dart';
import 'utils.dart';

void main() {
  runApp(const BomHamburguerApp());
}

enum ItemType { sandwich, fries, drink }

class MenuItem {
  final String name;
  final double price;
  final ItemType type;
  final String imageUrl;

  MenuItem(this.name, this.price, this.type, this.imageUrl);
}

final List<MenuItem> menuItems = [
  MenuItem(
    'X-Burguer',
    5.00,
    ItemType.sandwich,
    'https://cdn-icons-png.flaticon.com/512/3075/3075977.png',
  ),
  MenuItem(
    'X-Egg',
    4.50,
    ItemType.sandwich,
    'https://cdn-icons-png.flaticon.com/512/1858/1858002.png',
  ),
  MenuItem(
    'X-Bacon',
    7.00,
    ItemType.sandwich,
    'https://cdn-icons-png.flaticon.com/512/5098/5098990.png',
  ),
  MenuItem(
    'Fries',
    2.00,
    ItemType.fries,
    'https://cdn-icons-png.flaticon.com/512/1046/1046786.png',
  ),
  MenuItem(
    'Soft Drink',
    2.50,
    ItemType.drink,
    'https://cdn-icons-png.flaticon.com/512/5825/5825459.png',
  ),
];

class BomHamburguerApp extends StatelessWidget {
  const BomHamburguerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bom Hambúrguer',      
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    const OrderScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Fazer Pedido',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Ver Pedidos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<ItemType, MenuItem?> _selectedItems = {};

  void _toggleItem(MenuItem item) {
    setState(() {
      if (_selectedItems[item.type] == item) {
        _selectedItems.remove(item.type);
      } else {
        _selectedItems[item.type] = item;
      }
    });
  }

  void _goToCart() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nenhum item selecionado')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartScreen(selectedItems: _selectedItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Monte seu pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: menuItems.map((item) {
            final selected = _selectedItems[item.type] == item;
            return Card(
              color: selected ? Colors.deepOrange.shade100 : null,
              child: ListTile(
                leading: Image.network(item.imageUrl, width: 40, height: 40),
                title: Text(item.name),
                subtitle: Text('R\$ ${item.price.toStringAsFixed(2)}'),
                trailing: selected
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () => _toggleItem(item),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCart,
        label: const Text('Ver Carrinho'),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  Future<List<Map<String, dynamic>>> _loadOrders() async {
    return await OrderStorage.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Pedidos')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text('Nenhum pedido encontrado.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final order = orders[index];
              final formatter = DateFormat.yMd(locale).add_Hm();
              final formattedDate = formatter.format(DateTime.parse(order['date']).toLocal());

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order['customerName'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Itens: ${order['items']}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: R\$ ${order['total'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
