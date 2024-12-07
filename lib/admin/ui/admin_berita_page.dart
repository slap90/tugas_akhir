import 'dart:io'; // Import dart:io untuk File

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminBeritaPage extends StatefulWidget {
  @override
  _AdminBeritaPageState createState() => _AdminBeritaPageState();
}

class _AdminBeritaPageState extends State<AdminBeritaPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imagePicker = ImagePicker();
  String? _imageUrl; // Menyimpan URL gambar yang diunggah
  bool _isUploading = false;

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });
      await _uploadImage(pickedFile);
    }
  }

// Fungsi untuk mengunggah gambar ke Firebase Storage
Future<void> _uploadImage(XFile imageFile) async {
  try {
    // Menentukan path untuk gambar yang diunggah
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance.ref().child('berita_images/$fileName');
    
    // Mengonversi path gambar menjadi objek File
    File file = File(imageFile.path);

    // Mengunggah file ke Firebase Storage
    final uploadTask = storageRef.putFile(file);

    // Menunggu proses unggah selesai
    await uploadTask;

    // Mendapatkan URL gambar yang diunggah
    final imageUrl = await storageRef.getDownloadURL();

    setState(() {
      _imageUrl = imageUrl; // Menyimpan URL gambar
      _isUploading = false;
    });
  } catch (e) {
    setState(() {
      _isUploading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengunggah gambar: $e')));
  }
}

  // Fungsi untuk menyimpan berita ke Firestore
  Future<void> _saveBerita() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty || _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Harap isi semua field dan unggah gambar')));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('berita').add({
        'title': _titleController.text,
        'content': _contentController.text,
        'image_url': _imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Reset form setelah berita berhasil disimpan
      _titleController.clear();
      _contentController.clear();
      setState(() {
        _imageUrl = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berita berhasil disimpan')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan berita: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Berita'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Judul Berita'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Isi Berita'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  image: _imageUrl != null
                      ? DecorationImage(image: NetworkImage(_imageUrl!), fit: BoxFit.cover)
                      : null,
                ),
                child: _imageUrl == null
                    ? Center(child: Text('Pilih Gambar'))
                    : null,
              ),
            ),
            SizedBox(height: 16),
            _isUploading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _saveBerita,
                    child: Text('Simpan Berita'),
                  ),
          ],
        ),
      ),
    );
  }
}
