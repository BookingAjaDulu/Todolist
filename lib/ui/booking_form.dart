import 'package:booking/ui/booking_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookingForm extends StatefulWidget {
  const BookingForm({Key? key}) : super(key: key);

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _namaLapangTextboxController = TextEditingController();
  final _tanggalTextboxController = TextEditingController();
  final _jamMulaiTextboxController = TextEditingController();
  final _totalJamMainTextboxController = TextEditingController();
  final _nominalTextboxController = TextEditingController();

  late String _namaLapang = '';
  late String _tanggal = '';
  late String _jamMulai = '';
  late String _totalJamMain = '';
  late String _nominal = '';

  Future<String> _simpanData() async {
    const String url = 'http://192.168.18.5/lapang-api/public/booking';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'nama_lapang': _namaLapangTextboxController.text,
        'tanggal': _tanggalTextboxController.text,
        'jam_mulai': _jamMulaiTextboxController.text,
        'total_jam_main': _totalJamMainTextboxController.text,
        'nominal': _nominalTextboxController.text,
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw 'Failed to submit data.';
    }
  }

  void _showNotification(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
        title: const Text('Form Catatan Booking'),
        backgroundColor: Colors.black, // Ubah warna Navbar menjadi hitam
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _textboxNamaLapang(),
            _textboxTanggal(),
            _textboxJamMulai(),
            _textboxTotalJamMain(),
            _textboxNominal(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: ()
               {
                _simpanData().then((id) {
                  _namaLapang = _namaLapangTextboxController.text;
                  _tanggal = _tanggalTextboxController.text;
                  _jamMulai = _jamMulaiTextboxController.text;
                  _totalJamMain = _totalJamMainTextboxController.text;
                  _nominal = _nominalTextboxController.text;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(
                        id: id,
                        namaLapang: _namaLapang,
                        tanggal: _tanggal,
                        jamMulai: _jamMulai,
                        totalJamMain: _totalJamMain,
                        nominal: _nominal,
                      ),
                    ),
                  );

                  _showNotification('Data berhasil dimasukkan.');
                }).catchError((error) {
                  _showNotification(error.toString());
                });
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  backgroundColor: Colors.black, // Set the background color to black
                ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.yellow, // Set latar belakang menjadi kuning
    );
  }

  Widget _textboxNamaLapang() {
    return TextField(
      decoration: InputDecoration(
      labelText: "Nama Lapangan",
      labelStyle: TextStyle(color: Colors.black), // Ubah warna label teks
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black), // Ubah warna garis bawah saat focus
      ),
    ),
      controller: _namaLapangTextboxController,
      cursorColor: Colors.black, // Ubah warna kursor menjadi hitam
    );
  }

  Widget _textboxTanggal() {
    return TextField(
      decoration: InputDecoration(
      labelText: "Tanggal",
      labelStyle: TextStyle(color: Colors.black), // Ubah warna label teks
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black), // Ubah warna garis bawah saat focus
      ),
    ),
      controller: _tanggalTextboxController,
      cursorColor: Colors.black, // Ubah warna kursor menjadi hitam
    );
  }

  Widget _textboxJamMulai() {
    return TextField(
      decoration: InputDecoration(
      labelText: "Jam Mulai",
      labelStyle: TextStyle(color: Colors.black), // Ubah warna label teks
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black), // Ubah warna garis bawah saat focus
      ),
    ),
      controller: _jamMulaiTextboxController,
      cursorColor: Colors.black, // Ubah warna kursor menjadi hitam
    );
  }

  Widget _textboxTotalJamMain() {
    return TextField(
      decoration: InputDecoration(
      labelText: "Total Jam Main",
      labelStyle: TextStyle(color: Colors.black), // Ubah warna label teks
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black), // Ubah warna garis bawah saat focus
      ),
    ),
      controller: _totalJamMainTextboxController,
      cursorColor: Colors.black, // Ubah warna kursor menjadi hitam
    );
  }

  Widget _textboxNominal() {
    return TextField(
      decoration: InputDecoration(
      labelText: "Harga",
      labelStyle: TextStyle(color: Colors.black), // Ubah warna label teks
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black), // Ubah warna garis bawah saat focus
      ),
    ),
      controller: _nominalTextboxController,
      cursorColor: Colors.black, // Ubah warna kursor menjadi hitam
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String? id;
  final String namaLapang;
  final String tanggal;
  final String jamMulai;
  final String totalJamMain;
  final String nominal;

  const ResultScreen({
    Key? key,
    required this.namaLapang,
    required this.tanggal,
    required this.jamMulai,
    required this.totalJamMain,
    required this.nominal,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Input'),
        backgroundColor: Colors.black, // Ubah warna Navbar menjadi hitam
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResult("Nama Lapangan", namaLapang),
            _buildResult("Tanggal", tanggal),
            _buildResult("Jam Mulai", jamMulai),
            _buildResult("Total Jam Main", totalJamMain),
            _buildResult("Harga", nominal),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookingPage(),
                  ),
                );
              },
              child: const Text('Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
