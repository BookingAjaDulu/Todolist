import 'package:booking/ui/login.dart';
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
  List<Booking> filteredBookingList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataPage();
  }

  Future<void> fetchDataPage() async {
    final response = await http.get(
      Uri.parse('http://192.168.100.53/booking-api/public/booking'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> bookings = data['data'];

      setState(() {
        bookingList = bookings.map((item) => Booking.fromJson(item)).toList();
        filteredBookingList = List.from(bookingList); // Clone bookingList
      });
    } else {
      // Handle API error
    }
  }

  Future<void> deleteBooking(String id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.100.53/booking-api/public/booking/$id'),
    );

    if (response.statusCode == 200) {
      fetchDataPage();
    } else {
      // Handle deletion error
    }
  }

  void filterBookingList(String query) {
    List<Booking> filteredList = bookingList.where((booking) {
      // Filter berdasarkan nama lapangan atau tanggal
      return booking.namaLapang.toLowerCase().contains(query.toLowerCase()) ||
          booking.tanggal.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredBookingList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Catatan Booking'),
        backgroundColor: Color.fromARGB(255, 121, 116, 101),
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
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookingSearchDelegate(filteredBookingList),
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
      backgroundColor: Colors.yellow,
      body: ListView.builder(
        itemCount: filteredBookingList.length,
        itemBuilder: (context, index) {
          final booking = filteredBookingList[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Rp.${booking.nominal}',
                      style: TextStyle(fontSize: 15.0)),
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

class BookingSearchDelegate extends SearchDelegate<String> {
  final List<Booking> bookingList;

  BookingSearchDelegate(this.bookingList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Booking> suggestionList = query.isEmpty
        ? bookingList
        : bookingList.where((booking) {
            return booking.namaLapang.toLowerCase().contains(query.toLowerCase()) ||
                booking.tanggal.toLowerCase().contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final booking = suggestionList[index];
        return ListTile(
          title: Text("${booking.namaLapang} - ${booking.tanggal} ${booking.jamMulai}"),
          onTap: () {
            close(context, booking.id);
          },
        );
      },
    );
  }
}

