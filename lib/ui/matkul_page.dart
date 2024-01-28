import 'package:flutter/material.dart';
import 'matkul_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'matkul_form.dart';

class Booking {
  final String id;
  final String namaLapang;
  final String tanggal;
  final String jamMulai;
  final String totalJamMain;
  final String nominal;

  Booking({
    required this.id,
    required this.namaLapang,
    required this.tanggal,
    required this.jamMulai,
    required this.totalJamMain,
    required this.nominal,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      namaLapang: json['nama_lapang'],
      tanggal: json['tanggal'],
      jamMulai: json['jam_mulai'],
      totalJamMain: json['total_jam_main'],
      nominal: json['nominal'],
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Booking> bookingList = [];

  @override
  void initState() {
    super.initState();
    fetchDataPage();
  }

  Future<void> fetchDataPage() async {
    final response = await http.get(
      Uri.parse('http://localhost/lapang-api/public/booking'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> matkuls = data['data'];

      setState(() {
        bookingList = matkuls.map((item) => Booking.fromJson(item)).toList();
      });
    }
  }

  Future<void> deleteMatkul(String id) async {
    final response = await http.delete(
      Uri.parse('http://localhost/lapang-api/public/booking/$id'),
    );

    if (response.statusCode == 200) {
      fetchDataPage();
    } else {
      // Handle deletion error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Booking'),
        actions: [
          GestureDetector(
            child: const Icon(Icons.add),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatkulForm(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // You can navigate to the home page or perform other actions here
              },
            ),
            // Add more items as needed
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: bookingList.length,
        itemBuilder: (context, index) {
          final booking = bookingList[index];
          return ItemBooking(
            id: booking.id,
            namaLapang: booking.namaLapang,
            tanggal: booking.tanggal,
            jamMulai: booking.jamMulai,
            totalJamMain: booking.totalJamMain,
            nominal: booking.nominal,
            fetchDataPage: fetchDataPage,
            onDelete: () {
              deleteMatkul(booking.id);
            },
          );
        },
      ),
    );
  }
}

class ItemBooking extends StatelessWidget {
  final String id;
  final String namaLapang;
  final String tanggal;
  final String jamMulai;
  final String totalJamMain;
  final String nominal;
  final Function() fetchDataPage;
  final Function() onDelete;

  const ItemBooking({
    Key? key,
    required this.id,
    required this.namaLapang,
    required this.tanggal,
    required this.jamMulai,
    required this.totalJamMain,
    required this.nominal,
    required this.fetchDataPage,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          "$namaLapang - $tanggal $jamMulai s/d selesai",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Rp.' + nominal.toString(), style: TextStyle(fontSize: 14.0)),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            showDeleteConfirmationDialog(context);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatkulDetail(
                id: id,
                fetchDataPage: fetchDataPage,
                fetchDataDetail: () {},
              ),
            ),
          );
        },
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Penghapusan'),
          content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}