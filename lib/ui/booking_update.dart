import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingUpdate extends StatefulWidget {
  final String? id;
  final String? namaLapang;
  final String? tanggal;
  final String? jamMulai;
  final String? totalJamMain;
  final String? nominal;
  final Function() fetchDataDetail;

  const BookingUpdate({
    Key? key,
    this.id,
    this.namaLapang,
    this.tanggal,
    this.jamMulai,
    this.totalJamMain,
    this.nominal,
    required this.fetchDataDetail,
  }) : super(key: key);

  @override
  State<BookingUpdate> createState() => _BookingUpdateState();
}

class _BookingUpdateState extends State<BookingUpdate> {
  final TextEditingController _namaLapangController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _jamMulaiController = TextEditingController();
  final TextEditingController _totalJamMainController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaLapangController.text = widget.namaLapang ?? '';
    _tanggalController.text = widget.tanggal ?? '';
    _jamMulaiController.text = widget.jamMulai ?? '';
    _totalJamMainController.text = widget.totalJamMain ?? '';
    _nominalController.text = widget.nominal ?? '';
  }

  Future<void> _updateBooking() async {
    final String url = 'http://192.168.1.18/booking-api/public/booking/${widget.id}';

    try {
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode({
          'nama_lapang': _namaLapangController.text,
          'tanggal': _tanggalController.text,
          'jam_mulai': _jamMulaiController.text,
          'total_jam_main': _totalJamMainController.text,
          'nominal': _nominalController.text,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Data berhasil diperbarui
        _showSuccessDialog();
      } else {
        // Tangani kesalahan jika ada masalah dengan permintaan HTTP
        _showErrorDialog();
      }
    } catch (e) {
      // Tangani kesalahan umum
      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notifikasi'),
          content: const Text('Data berhasil diperbarui.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notifikasi'),
          content: const Text('Gagal memperbarui data. Coba lagi.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Nama Lapangan", _namaLapangController),
            _buildTextField("Tanggal", _tanggalController),
            _buildTextField("Jam Mulai", _jamMulaiController),
            _buildTextField("Total Jam Main", _totalJamMainController),
            _buildTextField("Nomimal", _nominalController),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateBooking();
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
