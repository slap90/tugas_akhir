import 'package:flutter/material.dart';

class DesaProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Profil Desa Sidakarya'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan secara horizontal
          children: [
            // Tambahkan logo desa di atas penjelasan
            Center(
              child: Image.asset(
                'assets/images/logo_app.png', // Path ke logo desa Anda
                width: 100, // Sesuaikan ukuran logo
                height: 100,
              ),
            ),
            SizedBox(height: 20), // Jarak antara logo dan teks
            Center(
              child: Text(
                'Desa Sidakarya resmi menjadi desa definitif pada 1 Juni 1982, sebelumnya bagian dari Desa Sesetan. Terletak di Kecamatan Denpasar Selatan, Kota Denpasar, desa ini memiliki 12 dusun. Nama Sidakarya berasal dari peristiwa sejarah di masa Sri Dalem Waturenggong, ketika wabah di Bali dihentikan oleh Brahmana Keling. Pengakuan atas jasanya diabadikan dalam tradisi yadnya umat Hindu di Bali.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify, // Perataan teks justify
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                color: Colors.grey[300], // Placeholder image
                child: Icon(Icons.image, color: Colors.grey),
              ),
              title: Text('Struktur Desa Sidakarya'),
              onTap: () {
                // Navigate to Struktur Desa page
              },
            ),
            Divider(),
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                color: Colors.grey[300], // Placeholder image
                child: Icon(Icons.image, color: Colors.grey),
              ),
              title: Text('Visi Misi Desa Sidakarya'),
              onTap: () {
                // Navigate to Visi Misi Desa page
              },
            ),
          ],
        ),
      ),
    );
  }
}
