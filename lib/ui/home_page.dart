import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String displayName = "Guest"; // Default menjadi Guest

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Periksa apakah pengguna sudah login
  }

  // Fungsi untuk memeriksa status login pengguna
  void _checkLoginStatus() {
    User? user = _auth.currentUser;
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      setState(() {
        displayName = user.displayName!; // Tampilkan nama pengguna jika login
      });
    } else {
      setState(() {
        displayName = "Guest"; // Tampilkan Guest jika belum login
      });
    }
  }

  // Fungsi logout
  Future<void> _logout() async {
    await _auth.signOut(); // Melakukan proses logout
    setState(() {
      displayName = "Guest"; // Set kembali ke Guest setelah logout
    });
    Navigator.pushReplacementNamed(context, '/loginpage'); // Arahkan kembali ke HomePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bagian Profil
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300], // Latar belakang abu-abu terang
                  radius: 20, // Ukuran lingkaran profil
                  child: Icon(
                    Icons.person, // Ikon bawaan Flutter
                    color: Colors.black, // Warna hitam untuk ikon
                    size: 20, // Ukuran ikon
                  ),
                ),
                SizedBox(width: 8), // Spasi antara avatar dan teks
                Text(
                  "Hi, $displayName", // Menampilkan nama pengguna atau Guest
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            IconButton(
              onPressed: _logout, // Memanggil fungsi logout
              icon: Icon(Icons.logout, color: Colors.black),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fitur Utama
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FeatureIcon(
                  title: 'Beranda',
                  onTap: () => Navigator.pushNamed(context, '/main'),
                ),
                FeatureIcon(
                  title: 'Dokumen',
                  onTap: () => Navigator.pushNamed(context, '/dokumen'),
                ),
                FeatureIcon(
                  title: 'Berita',
                  onTap: () => Navigator.pushNamed(context, '/berita'),
                ),
                FeatureIcon(
                  title: 'Profile Desa',
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
            Expanded(
              child: ListView(
                children: [
                  SpecialFeatureTile(
                    title: 'Layanan Surat Online',
                    onTap: () => Navigator.pushNamed(context, '/layananSuratOnline'),
                    icon: Icons.mail,
                  ),
                  SpecialFeatureTile(
                    title: 'Pengaduan Masyarakat',
                    onTap: () => Navigator.pushNamed(context, '/pengaduanmasyarakat'),
                    icon: Icons.report,
                  ),
                  SpecialFeatureTile(
                    title: 'Agenda',
                    onTap: () => Navigator.pushNamed(context, '/agenda'),
                    icon: Icons.event,
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

class FeatureIcon extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FeatureIcon({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;

    // Menentukan ikon yang sesuai untuk setiap menu
    switch (title) {
      case 'Beranda':
        icon = Icons.home; // Ikon untuk beranda
        break;
      case 'Dokumen':
        icon = Icons.document_scanner; // Ikon untuk dokumen
        break;
      case 'Berita':
        icon = Icons.article; // Ikon untuk berita
        break;
      case 'Profile Desa':
        icon = Icons.location_city; // Ikon untuk profil desa
        break;
      default:
        icon = Icons.circle; // Ikon default jika tidak ada yang cocok
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(5), // Mengatur ujung melengkung
            ),
            child: Icon(icon, size: 40),
          ),
          SizedBox(height: 5),
          Text(
            title.isNotEmpty ? title : 'Default', // Pastikan teks tidak null atau kosong
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14), // Tambahkan style jika diperlukan
          ),
        ],
      ),
    );
  }
}

class SpecialFeatureTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;

  const SpecialFeatureTile({
    required this.title,
    required this.onTap,
    required this.icon,
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
              title.isNotEmpty ? title : 'Default', // Pastikan teks tidak null atau kosong
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Warna teks
              ),
            ),
          ],
        ),
      ),
    );
  }
}
