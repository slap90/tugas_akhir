import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DokumenPage extends StatelessWidget {
  final Dio _dio = Dio(); // Instance Dio untuk mengunduh file

  // Fungsi untuk meminta izin penyimpanan
  Future<void> requestPermission() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      print("Izin storage tidak diberikan");
      return; // Tidak lanjutkan proses jika izin ditolak
    }
  }

  // Fungsi untuk mengunduh dokumen
  Future<void> downloadFile(String urlDokumen, String filename, BuildContext context) async {
    try {
      // Meminta izin penyimpanan sebelum melanjutkan
      await requestPermission();

      // Jika URL dokumen kosong atau tidak valid
      if (urlDokumen?.isEmpty ?? true) {  // Menggunakan null-aware operator
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('URL dokumen tidak valid'),
        ));
        return;
      }

      // Menentukan direktori penyimpanan - arahkan ke folder 'Download'
      final directory = await getExternalStorageDirectory();

      // Pastikan kita mendapatkan direktori yang benar untuk folder Download
      if (directory == null) {
        print("Direktori penyimpanan tidak ditemukan");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Tidak dapat menemukan direktori penyimpanan'),
        ));
        return;
      }

      // Lokasi penyimpanan di folder 'Download'
      final downloadDirectory = Directory('${directory.path}/Download');
      if (!await downloadDirectory.exists()) {
        await downloadDirectory.create(recursive: true);
      }

      final savePath = '${downloadDirectory.path}/$filename';  // Lokasi penyimpanan file di folder 'Download'

      // Mengunduh file menggunakan Dio
      print("Mencoba mengunduh file dari URL: $urlDokumen");
      print("Menyimpan file di: $savePath");

      await _dio.download(urlDokumen, savePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          print("Progress: ${(received / total * 100).toStringAsFixed(0)}%");
        }
      });

      // Memberikan feedback ke user jika unduhan berhasil
      print('File berhasil diunduh di: $savePath');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File berhasil diunduh di: $savePath'),
      ));
    } catch (e) {
      print('Gagal mengunduh file: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal mengunduh file: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          'Halaman Dokumen',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi, Burhan',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text(
              'Dokumen Terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('dokumen')  // Nama koleksi dokumen di Firestore
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final documents = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final doc = documents[index];
                      final judulDokumen = doc['judul_dokumen']; // Mengambil data judul dari Firestore
                      final urlDokumen = doc['url']; // Mengambil URL file
                      final filename = doc['filename']; // Mengambil nama file dari Firestore

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[50], // Latar belakang biru muda
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        judulDokumen,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'File: $filename', // Menampilkan nama file
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () async {
                                          if (urlDokumen?.isEmpty ?? true) {
                                            print("URL dokumen tidak ditemukan atau kosong");
                                            return;
                                          }

                                          // Memanggil fungsi untuk mengunduh file
                                          await downloadFile(urlDokumen, filename, context);
                                        },
                                        child: const Text(
                                          'Unduh Dokumen>>',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 14,
                                          ),
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
            ),
          ],
        ),
      ),
    );
  }
}
