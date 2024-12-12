import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'edit_profile_page.dart';  // Import halaman Edit Profile

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? displayName = '';
  String? email = '';
  String? phone = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fungsi untuk membaca data pengguna
  Future<void> fetchUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        setState(() {
          displayName = user.displayName ?? 'Nama tidak tersedia';
          email = user.email ?? 'Email tidak tersedia';
        });

        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            phone = userDoc['phone'] ?? 'Nomor telepon tidak tersedia';
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  // Gambar profil menggunakan ikon
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.grey[300], // Warna latar belakang lingkaran
                    child: Icon(
                      Icons.person, // Ikon bawaan Flutter
                      size: 50.0, // Ukuran ikon
                      color: Colors.grey[700], // Warna ikon
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    displayName ?? 'Loading...', // Tampilkan nama pengguna
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Info Pengguna',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Email
            InfoTile(
              label: 'Email',
              value: email ?? 'Loading...', // Tampilkan email pengguna
              onTap: () {
                // Arahkan ke halaman Edit Email
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(),
                  ),
                );
              },
            ),
            // Nomor Telepon
            InfoTile(
              label: 'Nomor Telepon',
              value: phone ?? 'Loading...', // Tampilkan nomor telepon pengguna
              onTap: () {
                // Arahkan ke halaman Edit Nomor Telepon
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const InfoTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton.icon(
              onPressed: onTap,
              icon: Icon(Icons.edit, color: Colors.blue),
              label: Text(
                'Ubah',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
