import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: FiturTambahLagu()));

class FiturTambahLagu extends StatefulWidget {
  @override
  _FiturTambahLaguState createState() => _FiturTambahLaguState();
}

class _FiturTambahLaguState extends State<FiturTambahLagu> {
  // List untuk menyimpan data lagu
  final List<Lagu> _daftarLagu = [];

  // Controller untuk mengambil teks dari input
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _penyanyiController = TextEditingController();

  void _tambahLagu() {
    if (_judulController.text.isNotEmpty &&
        _penyanyiController.text.isNotEmpty) {
      setState(() {
        _daftarLagu.add(
          Lagu(
            judul: _judulController.text,
            penyanyi: _penyanyiController.text,
          ),
        );
      });
      // Kosongkan input setelah menambah
      _judulController.clear();
      _penyanyiController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Playlist Saya")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              decoration: InputDecoration(labelText: "Judul Lagu"),
            ),
            TextField(
              controller: _penyanyiController,
              decoration: InputDecoration(labelText: "Penyanyi"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _tambahLagu,
              child: Text("Tambah ke Playlist"),
            ),
            Divider(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: _daftarLagu.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.music_note),
                      title: Text(_daftarLagu[index].judul),
                      subtitle: Text(_daftarLagu[index].penyanyi),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
