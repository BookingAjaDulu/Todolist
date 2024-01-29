import 'package:akadmobile/ui/login.dart';
import 'package:flutter/material.dart';
import 'booking_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'booking_form.dart';

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
      Uri.parse('http://10.200.0.64/lapang-api/public/booking'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> bookings = data['data'];

      setState(() {
        bookingList = bookings.map((item) => Booking.fromJson(item)).toList();
      });
    }
  }

  Future<void> deleteBooking(String id) async {
    final response = await http.delete(
      Uri.parse('http://10.200.0.64/lapang-api/public/booking/$id'),
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
        title: const Text('List Catatan Booking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingForm(),
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
            ListTile(
              trailing: const Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: bookingList.length,
        itemBuilder: (context, index) {
          final booking = bookingList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 5.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetail(
                        id: booking.id,
                        fetchDataPage: fetchDataPage,
                        fetchDataDetail: () {},
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    "${booking.namaLapang} - ${booking.tanggal} ${booking.jamMulai}",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Rp.${booking.nominal}', style: TextStyle(fontSize: 15.0)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDeleteConfirmationDialog(context, booking.id);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, String id) {
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
                deleteBooking(id);
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
