import 'package:flutter/material.dart';
import 'order_form_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class PromoItem {
  String title;
  String description;
  bool isExpanded;

  PromoItem({
    required this.title,
    required this.description,
    this.isExpanded = false,
  });
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Data Dummy Katalog Produk
  final List<Map<String, String>> _products = [
    {
      'name': 'Laptop Asus ROG Strix',
      'category': 'Elektronik',
      'price': 'Rp 18.500.000',
      'badge': 'Diskon 15%',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Kursi Kerja Ergonomis',
      'category': 'Perlengkapan Kantor',
      'price': 'Rp 1.450.000',
      'badge': 'Stok 3',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Printer Epson L3210 All-in-One',
      'category': 'Elektronik',
      'price': 'Rp 2.300.000',
      'badge': 'Promo',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Meja Kantor Minimalis',
      'category': 'Perlengkapan Kantor',
      'price': 'Rp 850.000',
      'badge': 'Diskon 10%',
      'image': 'https://via.placeholder.com/150'
    },
  ];

  // Data Dummy Ketentuan Promo
  final List<PromoItem> _promos = [
    PromoItem(
      title: 'Voucher Member Loyalitas',
      description: 'Potongan hingga 20% khusus untuk pelanggan terpilih dengan min. belanja Rp 1.000.000.',
    ),
    PromoItem(
      title: 'Syarat & Ketentuan Gratis Ongkir',
      description: 'Gratis ongkos kirim reguler untuk area Jabodetabek tanpa minimum pembelian.',
    ),
    PromoItem(
      title: 'Ketentuan Diskon Pembelian Grosir',
      description: 'Pembelian di atas 10 unit produk kategori perlengkapan kantor mendapat potongan ekstra 5%.',
    ),
  ];

  void _openOrderForm(String productName) async {
    // Navigasi ke Halaman Formulir Pemesanan (Passing Data)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderFormScreen(productName: productName),
      ),
    );

    // Menerima Respon Balikan (Returning Data) dan Menampilkan SnackBar
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.toString()),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // WIDGET TAB KATALOG (TabBar & TabBarView)
  Widget _buildKatalogTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.blue.shade50,
            child: const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(icon: Icon(Icons.inventory_2), text: 'Produk'),
                Tab(icon: Icon(Icons.confirmation_number), text: 'Ketentuan Promo'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // TAB 1: Daftar Produk (ListView.builder + Stack & Positioned Badge)
                ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final item = _products[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: SizedBox(
                          width: 70,
                          height: 70,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Icon(Icons.shopping_bag, size: 35, color: Colors.blue),
                                ),
                              ),
                              // Lencana Diskon/Stok menggunakan Positioned
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    item['badge']!,
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['category']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(item['price']!, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _openOrderForm(item['name']!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Pesan'),
                        ),
                      ),
                    );
                  },
                ),

                // TAB 2: Ketentuan Promo (ExpansionPanelList)
                SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _promos[index].isExpanded = isExpanded;
                      });
                    },
                    children: _promos.map<ExpansionPanel>((PromoItem promo) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: const Icon(Icons.local_offer, color: Colors.orange),
                            title: Text(
                              promo.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                        body: Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.centerLeft,
                          color: Colors.orange.shade50,
                          child: Text(promo.description),
                        ),
                        isExpanded: promo.isExpanded,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET TAB RIWAYAT (DataTable)
  Widget _buildRiwayatTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rekapitulasi Penjualan Kasir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.blue.shade100),
              columns: const [
                DataColumn(label: Text('No. Nota', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Produk', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Metode Kirim', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('SR-001')),
                  DataCell(Text('Laptop Asus ROG Strix')),
                  DataCell(Text('Instan')),
                  DataCell(Text('Rp 18.500.000')),
                  DataCell(Text('Sukses', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                ]),
                DataRow(cells: [
                  DataCell(Text('SR-002')),
                  DataCell(Text('Kursi Kerja Ergonomis')),
                  DataCell(Text('Reguler')),
                  DataCell(Text('Rp 1.450.000')),
                  DataCell(Text('Sukses', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                ]),
                DataRow(cells: [
                  DataCell(Text('SR-003')),
                  DataCell(Text('Printer Epson L3210')),
                  DataCell(Text('Kargo')),
                  DataCell(Text('Rp 2.300.000')),
                  DataCell(Text('Diproses', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET TAB INFORMASI TOKO (SelectableText)
  Widget _buildInfoTokoTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.store, size: 60, color: Colors.blue),
                const SizedBox(height: 12),
                const Text('SmartRetail Store Subang', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Jl. Brigjen Katamso No. 37, Subang', style: TextStyle(color: Colors.grey)),
                const Divider(height: 30),
                const Text('Kode Lisensi Resmi Aplikasi:', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const SelectableText(
                    'LIC-SMARTRETAIL-2026-POS-OK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('(Teks lisensi di atas dapat diblok dan disalin)', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildKatalogTab(),
      _buildRiwayatTab(),
      _buildInfoTokoTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dasbor Kasir SmartRetail'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // Drawer Navigasi Samping
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text('Kasir: Admin Store', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('ID: KASIR-001 | Shift Pagi', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dasbor Utama'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan Kasir'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Keluar / Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context); // Kembali ke Login
              },
            ),
          ],
        ),
      ),
      body: pages[_currentIndex],
      // BottomNavigationBar 3 Menu Utama
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Katalog'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Informasi Toko'),
        ],
      ),
    );
  }
}