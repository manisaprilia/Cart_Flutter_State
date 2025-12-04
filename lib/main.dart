import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green,
          secondary: Colors.greenAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),
      home: const CatalogPage(),
    );
  }
}

class VegItem {
  final String name;
  final int price;
  bool isSelected;

  VegItem({required this.name, required this.price, this.isSelected = false});
}

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  List<VegItem> catalog = [
    VegItem(name: "Bayam", price: 3000),
    VegItem(name: "Kangkung", price: 4000),
    VegItem(name: "Wortel", price: 8000),
    VegItem(name: "Kentang", price: 10000),
    VegItem(name: "Brokoli", price: 15000),
    VegItem(name: "Kubis", price: 6000),
  ];

  int get totalItems => catalog.where((item) => item.isSelected).length;

  int get totalPrice => catalog
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sayur Segar Sehat Hijau"),
        actions: [
          Row(
            children: [
              const Icon(Icons.shopping_cart),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 4),
                child: Text(
                  totalItems.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: catalog.length,
        itemBuilder: (context, index) {
          final item = catalog[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.25),
                  Colors.green.withOpacity(0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() {
                  item.isSelected = !item.isSelected;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // nama + harga
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Rp ${item.price}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    // icon pilih
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: item.isSelected
                          ? const Icon(
                              Icons.check_circle,
                              key: ValueKey(1),
                              color: Colors.green,
                              size: 30,
                            )
                          : const Icon(
                              Icons.add_circle_outline,
                              key: ValueKey(2),
                              color: Colors.green,
                              size: 30,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Item: $totalItems",
              style: const TextStyle(color: Colors.green, fontSize: 16),
            ),
            Text(
              "Total Harga: Rp $totalPrice",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            ElevatedButton(
              onPressed: totalItems == 0
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PayPage(selectedItems: catalog),
                        ),
                      );
                    },
              child: const Text("Bayar"),
            ),
          ],
        ),
      ),
    );
  }
}

class PayPage extends StatelessWidget {
  final List<VegItem> selectedItems;

  const PayPage({super.key, required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    final items = selectedItems.where((e) => e.isSelected).toList();
    final total = items.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sayur yang dibeli:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index].name),
                    trailing: Text(
                      "Rp ${items[index].price}",
                      style: const TextStyle(color: Colors.green),
                    ),
                  );
                },
              ),
            ),
            Text(
              "Total Pembayaran: Rp $total",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Selesai"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
