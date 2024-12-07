import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AdminSuratPage extends StatefulWidget {
  @override
  _AdminSuratPageState createState() => _AdminSuratPageState();
}

class _AdminSuratPageState extends State<AdminSuratPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk mengambil daftar surat yang dikirimkan oleh pengguna
  Stream<QuerySnapshot> _getSuratMasuk() {
    return _firestore.collection('surat_online')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Fungsi untuk mengubah status surat menjadi approved/rejected
  Future<void> _ubahStatusSurat(String suratId, String status) async {
    try {
      await _firestore.collection('surat_online').doc(suratId).update({
        'status': status,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status surat berhasil diubah menjadi $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah status surat: $e')),
      );
    }
  }

  // Fungsi untuk mengunduh file PDF
  Future<String> _downloadFile(String fileUrl) async {
    Dio dio = Dio();
    try {
      // Mendapatkan direktori aplikasi untuk menyimpan file
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = "${appDocDir.path}/surat_${DateTime.now().millisecondsSinceEpoch}.pdf";

      // Mulai mengunduh file
      print("Mulai mengunduh file dari $fileUrl ke $filePath");
      await dio.download(fileUrl, filePath);
      print("File berhasil diunduh ke $filePath");

      return filePath; // Mengembalikan path file yang telah diunduh
    } catch (e) {
      print("Gagal mengunduh file: $e");
      throw 'Gagal mengunduh file: $e';
    }
  }

  // Fungsi untuk membuka file surat dalam halaman baru
  Future<void> _openFileInPopup(String fileUrl) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuratDetailPage(fileUrl: fileUrl),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka file $fileUrl')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surat Masuk'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getSuratMasuk(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada surat masuk.'));
          }

          var suratData = snapshot.data!.docs;

          return ListView.builder(
            itemCount: suratData.length,
            itemBuilder: (context, index) {
              var surat = suratData[index];

              String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(surat['timestamp'].toDate());

              Color statusColor;
              String status = surat['status'] ?? 'Menunggu';
              if (status == 'approved') {
                statusColor = Colors.green;
              } else if (status == 'rejected') {
                statusColor = Colors.red;
              } else {
                statusColor = Colors.orange;
              }

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surat['name'],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(surat['doc_title'], style: TextStyle(fontSize: 14)),
                            SizedBox(height: 4),
                            Text('Tanggal: $formattedDate', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            SizedBox(height: 8),
                            // Tombol untuk melihat isi surat
                            surat['fileurl'] != null && surat['fileurl'].isNotEmpty
                                ? TextButton(
                                    onPressed: () => _openFileInPopup(surat['fileurl']),
                                    child: Text('Lihat Isi Surat', style: TextStyle(color: Colors.blue)),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () {
                                  _ubahStatusSurat(surat.id, 'approved');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  _ubahStatusSurat(surat.id, 'rejected');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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


class SuratDetailPage extends StatelessWidget {
  final String fileUrl;

  SuratDetailPage({required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Surat"),
      ),
      body: FutureBuilder<String>(
        future: _downloadFile(fileUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Gagal mengunduh file'));
          }

          if (snapshot.hasData) {
            // Menampilkan PDF setelah berhasil diunduh
            return PDFView(
              filePath: snapshot.data!, // Menampilkan file PDF setelah diunduh
            );
          }

          return Center(child: Text('Tidak ada data untuk ditampilkan.'));
        },
      ),
    );
  }

  Future<String> _downloadFile(String fileUrl) async {
    Dio dio = Dio();
    try {
      // Mendapatkan direktori aplikasi untuk menyimpan file
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = "${appDocDir.path}/surat_${DateTime.now().millisecondsSinceEpoch}.pdf";

      // Mulai mengunduh file
      print("Mulai mengunduh file dari $fileUrl ke $filePath");
      await dio.download(fileUrl, filePath);
      print("File berhasil diunduh ke $filePath");

      return filePath; // Mengembalikan path file yang telah diunduh
    } catch (e) {
      print("Gagal mengunduh file: $e");
      throw 'Gagal mengunduh file: $e';
    }
  }
}
