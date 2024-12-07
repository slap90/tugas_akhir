import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class LayananSuratOnlinePage extends StatefulWidget {
  @override
  _LayananSuratOnlinePageState createState() => _LayananSuratOnlinePageState();
}

class _LayananSuratOnlinePageState extends State<LayananSuratOnlinePage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController judulDokumenController = TextEditingController();

  String? filePath;

  // Fungsi untuk memilih file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'], // File yang diperbolehkan
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        filePath = result.files.single.path;
      });
    }
  }

  // Fungsi untuk upload file ke Firebase Storage dan simpan URL ke Firestore
  Future<void> _uploadFileAndSaveData() async {
    if (filePath == null) {
      _showErrorDialog('Harap pilih file terlebih dahulu.');
      return;
    }

    try {
      // Ambil file yang dipilih
      File file = File(filePath!);

      // Tentukan path untuk file yang di-upload
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_file.pdf'; // Nama unik untuk file
      Reference ref = FirebaseStorage.instance.ref().child('surat/$fileName');

      // Upload file ke Firebase Storage
      await ref.putFile(file);

      // Ambil URL download file setelah berhasil di-upload
      String fileUrl = await ref.getDownloadURL();

      // Simpan data ke Firestore
      await FirebaseFirestore.instance.collection('surat_online').add({
        'name': namaController.text.trim(),
        'email': emailController.text.trim(),
        'alamat': alamatController.text.trim(),
        'doc_title': judulDokumenController.text.trim(),
        'fileurl': fileUrl, // URL file yang dapat diakses
        'status': 'pending', // Status awal
        'timestamp': FieldValue.serverTimestamp(), // Tanggal kirim
      });

      _showSuccessDialog('Dokumen berhasil dikirim!');
      _clearFields(); // Bersihkan form setelah pengiriman berhasil
    } catch (e) {
      _showErrorDialog('Gagal mengirim dokumen: ${e.toString()}');
    }
  }

  // Fungsi untuk menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog sukses
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Berhasil'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membersihkan semua field input
  void _clearFields() {
    namaController.clear();
    emailController.clear();
    alamatController.clear();
    judulDokumenController.clear();
    setState(() {
      filePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Text(
            'Input Dokumen',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nama Lengkap Field
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Email Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Alamat Field
              TextField(
                controller: alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Judul Dokumen Field
              TextField(
                controller: judulDokumenController,
                decoration: InputDecoration(
                  labelText: 'Judul Dokumen',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Pilih File
              Row(
                children: [
                  Expanded(
                    child: Text(
                      filePath == null ? 'Tidak ada file dipilih.' : 'File dipilih: ${filePath!.split('/').last}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.attach_file, size: 30, color: Colors.blue),
                    onPressed: _pickFile, // Pilih file
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Tombol Submit
              ElevatedButton(
                onPressed: _uploadFileAndSaveData,
                child: Text('Kirim Dokumen'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
