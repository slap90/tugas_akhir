import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AktivitasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktivitas'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('aktivitas')
            .orderBy('waktu', descending: true) // Urutkan berdasarkan waktu
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var activities = snapshot.data!.docs;

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              var activity = activities[index];
              return AktivitasItem(
                imageUrl: 'https://via.placeholder.com/50', // Ganti dengan URL gambar pengguna
                title: activity['nama'], // Ambil data nama dari Firestore
                description: 'Mengajukan dokumen: ${activity['judul_dokumen']}',
                time: 'Terkirim', // Anda bisa mengganti dengan waktu yang lebih dinamis
              );
            },
          );
        },
      ),
    );
  }
}

class AktivitasItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String time;

  const AktivitasItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 25,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
