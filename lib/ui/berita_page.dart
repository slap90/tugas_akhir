import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BeritaPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getBerita() {
    return _firestore.collection('berita')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita Terbaru'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getBerita(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada berita.'));
          }

          var beritaData = snapshot.data!.docs;
          print("Jumlah berita: ${beritaData.length}");

          return ListView.builder(
            itemCount: beritaData.length,
            itemBuilder: (context, index) {
              var berita = beritaData[index];
             String? imageUrl = berita['image_url'];
            if (imageUrl == null || imageUrl.isEmpty) {
             imageUrl = ''; 
            }


              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Menampilkan gambar thumbnail jika ada
                        if (imageUrl.isNotEmpty)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          )
                        else
                          // Gambar default jika image_url tidak ada
                          Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],  // Warna abu-abu sebagai placeholder
                            child: Icon(Icons.image, color: Colors.white), // Ikon gambar
                          ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                berita['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BeritaDetailPage(beritaId: berita.id),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Baca selengkapnya >>',
                                  style: TextStyle(color: Colors.blue, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BeritaDetailPage extends StatelessWidget {
  final String beritaId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BeritaDetailPage({required this.beritaId});

  Future<DocumentSnapshot> _getBeritaDetail() async {
    return await _firestore.collection('berita').doc(beritaId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Berita'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getBeritaDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Berita tidak ditemukan.'));
          }

          var berita = snapshot.data!;

          // Debug: Menampilkan data berita detail
          print("Berita Detail: ${berita['title']}");
          print("Gambar URL Detail: ${berita['image_url']}");

          // Menangani jika field image_url tidak ada
          String? imageUrl = berita['image_url'];
          if (imageUrl == null) {
            imageUrl = '';  // Gambar default jika tidak ada
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menampilkan gambar header jika ada
                if (imageUrl.isNotEmpty)
                  Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                else
                  // Gambar default jika image_url tidak ada
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, color: Colors.white),
                  ),
                SizedBox(height: 20),
                Text(
                  berita['title'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  berita['content'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Tanggal: ${DateFormat('dd MMM yyyy, HH:mm').format(berita['timestamp'].toDate())}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
