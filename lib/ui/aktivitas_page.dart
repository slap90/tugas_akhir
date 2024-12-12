import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AktivitasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktivitas'),
        centerTitle: true,
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Pantau status login
        builder: (context, authSnapshot) {
          if (!authSnapshot.hasData || authSnapshot.data!.isAnonymous) {
            // Jika pengguna belum login atau login sebagai guest
            return Center(
              child: Text(
                'Silakan login untuk melihat aktivitas Anda.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final userId = authSnapshot.data!.uid; // Ambil UID pengguna yang login

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('surat_online')
                .where('user_id', isEqualTo: userId) // Filter data berdasarkan user_id
                .orderBy('timestamp', descending: true) // Urutkan berdasarkan timestamp terbaru
                .snapshots(),
            builder: (context, activitySnapshot) {
              if (!activitySnapshot.hasData) {
                // Tampilkan loading jika data belum tersedia
                return Center(child: CircularProgressIndicator());
              }

              var activities = activitySnapshot.data!.docs;

              if (activities.isEmpty) {
                // Jika tidak ada aktivitas untuk pengguna yang login
                return Center(
                  child: Text(
                    'Belum ada aktivitas.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              // Tampilkan aktivitas dalam ListView
              return ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  var activity = activities[index];
                  return AktivitasItem(
                    title: activity['name'], // Nama pengguna
                    description: 'Mengajukan dokumen: ${activity['doc_title']}', // Judul dokumen
                    status: activity['status'], // Status dokumen
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class AktivitasItem extends StatelessWidget {
  final String title;
  final String description;
  final String status;

  const AktivitasItem({
    required this.title,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Warna status berdasarkan nilai status
    Color statusColor = status.toLowerCase() == 'approved' ? Colors.green : Colors.orange;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white, // Warna putih untuk box
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!, width: 1), // Border abu-abu
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow sedikit ke bawah
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status:',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2), // Warna latar belakang transparan
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(), // Tampilkan status dalam huruf besar
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor, // Warna teks sesuai status
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
