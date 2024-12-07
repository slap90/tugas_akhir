import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DokumenAdminPage extends StatefulWidget {
  @override
  _DokumenAdminPageState createState() => _DokumenAdminPageState();
}

class _DokumenAdminPageState extends State<DokumenAdminPage> {
  final TextEditingController titleController = TextEditingController();
  String? filePath; // Path file yang dipilih

  // Fungsi untuk memilih file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'], // File yang diizinkan
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });
    }
  }

  // Fungsi untuk meng-upload file ke Firebase Storage dan menyimpan data ke Firestore
  Future<void> _uploadFile() async {
    if (filePath == null || titleController.text.isEmpty) {
      _showErrorDialog('Judul dan file harus diisi.');
      return;
    }

    try {
      // Menyimpan file ke Firebase Storage
      String fileName = filePath!.split('/').last;
      Reference storageRef = FirebaseStorage.instance.ref().child('dokumen/$fileName');
      File file = File(filePath!);

      // Meng-upload file
      await storageRef.putFile(file);

      // Mendapatkan URL file setelah di-upload
      String fileUrl = await storageRef.getDownloadURL();

      // Menambahkan data dokumen ke Firestore tanpa tanggal_upload
      await FirebaseFirestore.instance.collection('dokumen').add({
        'judul_dokumen': titleController.text, // Judul dokumen dari input
        'url': fileUrl, // URL file
        'filename': fileName, // Nama file
      });

      // Menampilkan dialog sukses
      _showSuccessDialog('Dokumen berhasil di-upload dan disimpan ke Firestore.');
      _clearFields();
    } catch (e) {
      _showErrorDialog('Gagal meng-upload file: $e');
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
    titleController.clear();
    setState(() {
      filePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          'Dokumen Admin',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah/Edit Dokumen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),

            // Judul Dokumen
            TextField(
              controller: titleController,
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
            SizedBox(height: 20),

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
              onPressed: _uploadFile,
              child: Text('Simpan Dokumen'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
