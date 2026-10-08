import 'package:flutter/material.dart';

class OrderFormScreen extends StatefulWidget {
  final String productName;

  const OrderFormScreen({super.key, required this.productName});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  // Option State
  String _selectedKurir = 'Reguler'; // Radio
  bool _asuransi = false; // Checkbox 1
  bool _bubbleWrap = false; // Checkbox 2
  bool _packingKayu = false; // Checkbox 3

  DateTime? _selectedDate; // DatePicker
  TimeOfDay? _selectedTime; // TimePicker

  double _diskonMember = 0.0; // Slider
  bool _isDropship = false; // Switch

  // DatePicker Handler
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // TimePicker Handler
  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // Alur Konfirmasi Transaksi (BottomSheet -> AlertDialog -> Returning Data)
  void _prosesTransaksi() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rincian Biaya Pemesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const Divider(),
              Text('• Produk: ${widget.productName}'),
              Text('• Kurir: $_selectedKurir'),
              Text('• Layanan Ekstra: ${[
                if (_asuransi) 'Asuransi',
                if (_bubbleWrap) 'Bubble Wrap',
                if (_packingKayu) 'Packing Kayu',
                if (!_asuransi && !_bubbleWrap && !_packingKayu) 'Tidak Ada'
              ].join(', ')}'),
              Text('• Tanggal Ambil: ${_selectedDate != null ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}" : "Belum diatur"}'),
              Text('• Jam Ambil: ${_selectedTime != null ? _selectedTime!.format(context) : "Belum diatur"}'),
              Text('• Diskon Member: ${_diskonMember.round()}%'),
              Text('• Opsi Dropship: ${_isDropship ? "Aktif" : "Tidak"}'),
              const SizedBox(height: 20),
              
              // Tombol Konfirmasi Akhir dalam Bottom Sheet
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Memicu AlertDialog persetujuan transaksi
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Konfirmasi Transaksi Kasir'),
                        content: Text('Apakah Anda setuju memproses pesanan ${widget.productName}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext); // Tutup AlertDialog
                              Navigator.pop(context); // Tutup BottomSheet
                              
                              // Tutup Form & Kirim status transaksi sukses (returning data)
                              Navigator.pop(
                                context,
                                'Transaksi "${widget.productName}" Berhasil Diproses!',
                              );
                            },
                            child: const Text('Setuju & Kirim'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Konfirmasi Akhir Transaksi'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Pemesanan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Nama Produk (Passing Data)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                'Produk Dipilih: ${widget.productName}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),

            // 1. Metode Pengiriman (Radio)
            const Text('Metode Pengiriman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Column(
              children: ['Reguler', 'Kargo', 'Instan'].map((kurir) {
                return RadioListTile<String>(
                  title: Text(kurir),
                  value: kurir,
                  groupValue: _selectedKurir,
                  onChanged: (val) {
                    setState(() => _selectedKurir = val!);
                  },
                );
              }).toList(),
            ),
            const Divider(),

            // 2. Layanan Ekstra (Checkbox)
            const Text('Layanan Ekstra Proteksi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text('Asuransi Pengiriman'),
              value: _asuransi,
              onChanged: (val) => setState(() => _asuransi = val!),
            ),
            CheckboxListTile(
              title: const Text('Bubble Wrap Ekstra'),
              value: _bubbleWrap,
              onChanged: (val) => setState(() => _bubbleWrap = val!),
            ),
            CheckboxListTile(
              title: const Text('Packing Kayu'),
              value: _packingKayu,
              onChanged: (val) => setState(() => _packingKayu = val!),
            ),
            const Divider(),

            // 3. Jadwal Pengambilan (DatePicker & TimePicker)
            const Text('Jadwal Pengambilan Barang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_selectedDate == null
                        ? 'Pilih Tanggal'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                    onPressed: _pickDate,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(_selectedTime == null ? 'Pilih Jam' : _selectedTime!.format(context)),
                    onPressed: _pickTime,
                  ),
                ),
              ],
            ),
            const Divider(),

            // 4. Penyesuaian Tambahan (Slider & Switch)
            const Text('Penyesuaian Tambahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Diskon Member: ${_diskonMember.round()}%'),
            Slider(
              value: _diskonMember,
              min: 0,
              max: 50,
              divisions: 10,
              label: '${_diskonMember.round()}%',
              onChanged: (val) {
                setState(() => _diskonMember = val);
              },
            ),
            SwitchListTile(
              title: const Text('Kirim sebagai Dropship / Bungkus Kado'),
              value: _isDropship,
              onChanged: (val) => setState(() => _isDropship = val),
            ),
            const SizedBox(height: 24),

            // Tombol Proses Transaksi
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _prosesTransaksi,
                child: const Text('PROSES TRANSAKSI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}