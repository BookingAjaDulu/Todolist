import 'package:flutter/material.dart';
import 'matkul_update.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MatkulDetail extends StatefulWidget {
  final String id; // Menggunakan id sebagai parameter
  final Function() fetchDataPage;
  final Function() fetchDataDetail;

  const MatkulDetail({
    Key? key,
    required this.id,
    required this.fetchDataPage,
    required this.fetchDataDetail,
  }) : super(key: key);

  @override
  State<MatkulDetail> createState() => _MatkulDetailState();
}

class _MatkulDetailState extends State<MatkulDetail> {
  String? namaLapang;
  String? tanggal;
  String? jamMulai;
  String? totalJamMain;
  String? nominal;

  @override
  void initState() {
    super.initState();
    fetchDataDetail();
  }

  Future<void> fetchDataDetail() async {
    final response = await http.get(
      Uri.parse('http://192.168.18.5/lapang-api/public/booking/${widget.id}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final lapangValue = data['data']['nama_lapang'];

      if (lapangValue != null) {
        setState(() {
          namaLapang = data['data']['nama_lapang'];
          tanggal = data['data']['tanggal'];
          jamMulai = data['data']['jam_mulai'];
          totalJamMain = data['data']['total_jam_main'];
          nominal = data['data']['nominal'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailColumn("Nama Lapangan", namaLapang),
            _buildDetailColumn("Tanggal", tanggal),
            _buildDetailColumn("Jam Mulai", jamMulai),
            _buildDetailColumn("Total Jam Main", totalJamMain),
            _buildDetailColumn("Nominal", nominal),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatkulUpdate(
                      id: widget.id,
                      namaLapang: namaLapang,
                      tanggal: tanggal,
                      jamMulai: jamMulai,
                      totalJamMain: totalJamMain,
                      nominal:nominal,
                      fetchDataDetail: widget.fetchDataDetail,
                    ),
                  ),
                ).then((_) {
                  widget.fetchDataPage();
                  fetchDataDetail();
                });
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailColumn(String title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            content ?? 'N/A',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
