import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String adminName = "Admin"; // Nama admin

  Future<void> _logout() async {
    // Logika logout, bisa ditambahkan SharedPreferences untuk menghapus data login
    Navigator.pushReplacementNamed(context, '/loginpage'); // Navigasi ke halaman login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[700], // Warna header sesuai gambar
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 20,
                  child: Icon(Icons.person, color: Colors.grey),
                ),
                SizedBox(width: 8),
                Text(
                  "Hi, Admin", // Ganti "Hi, Guest" dengan nama admin
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                // Logika logout
                Navigator.pushReplacementNamed(context, '/loginpage');
              },
              icon: Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Desa Sidakarya",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Fitur Utama
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FeatureIcon(
                  title: 'Beranda',
                  icon: Icons.home,
                  onTap: () => Navigator.pushNamed(context, '/adminhome'),
                ),
                FeatureIcon(
                  title: 'Dokumen',
                  icon: Icons.document_scanner,
                  onTap: () => Navigator.pushNamed(context, '/dokumenadmin'),
                ),
                FeatureIcon(
                  title: 'Berita',
                  icon: Icons.article,
                  onTap: () => Navigator.pushNamed(context, '/beritaadmin'),
                ),
                FeatureIcon(
                  title: 'Profile Desa',
                  icon: Icons.location_city,
                  onTap: () => Navigator.pushNamed(context, '/profiledesa'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Lainnya",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Daftar fitur lainnya
          ],
        ),
      ),
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: 0,
    onTap: (index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/adminsuratpage'); // Navigasi ke Aktivitas Surat Admin
    } else if (index == 0) {
      Navigator.pushNamed(context, '/adminhome'); // Navigasi ke Home
    }
    // Tambahkan logika navigasi lainnya jika ada
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Aktivitas Surat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class FeatureIcon extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const FeatureIcon({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          SizedBox(height: 5),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class SpecialFeatureTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SpecialFeatureTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
