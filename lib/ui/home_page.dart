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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bagian Profil
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueAccent, // Latar belakang biru terang
                  radius: 25, // Ukuran lingkaran profil
                  child: Icon(
                    Icons.person, // Ikon bawaan Flutter
                    color: Colors.white, // Warna putih untuk ikon
                    size: 25, // Ukuran ikon
                  ),
                ),
                SizedBox(width: 10), // Spasi antara avatar dan teks
                Text(
                  "Hi, $displayName", // Menampilkan nama pengguna atau Guest
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            IconButton(
              onPressed: _logout, // Memanggil fungsi logout
              icon: Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple], // Gradient untuk app bar
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header text: "Selamat Datang di Desa Sidakarya"
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "Selamat Datang di Desa Sidakarya", 
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Tab Menu
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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
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
        icon = Icons.home;
        break;
      case 'Dokumen':
        icon = Icons.document_scanner;
        break;
      case 'Berita':
        icon = Icons.article;
        break;
      case 'Profile Desa':
        icon = Icons.location_city;
        break;
      default:
        icon = Icons.circle;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(15), // Rounded corners
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))], // Shadow
            ),
            child: Icon(icon, size: 40, color: Colors.blue),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
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
      onTap: () async {
        // Periksa apakah user sudah login menggunakan FirebaseAuth
        FirebaseAuth auth = FirebaseAuth.instance;
        User? user = auth.currentUser;

        if (user == null) {
          // Jika user belum login, arahkan ke halaman login
          Navigator.pushNamed(context, '/loginpage');
        } else {
          // Jika sudah login, lanjutkan ke halaman tujuan
          onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.all(18),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))], // Shadow
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
