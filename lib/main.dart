import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tugas_akhir/admin/ui/admin_berita_page.dart';
import 'package:tugas_akhir/admin/ui/admin_home_page.dart';
import 'package:tugas_akhir/admin/ui/admin_surat_page.dart';
import 'package:tugas_akhir/admin/ui/dokumen_admin.dart';
import 'package:tugas_akhir/firebase_options.dart';
import 'package:tugas_akhir/splash_screen.dart';
import 'package:tugas_akhir/ui/agenda_page.dart';
import 'package:tugas_akhir/ui/aktivitas_page.dart';
import 'package:tugas_akhir/ui/berita_page.dart';
import 'package:tugas_akhir/ui/dokumen_page.dart';
import 'package:tugas_akhir/ui/home_page.dart';
import 'package:tugas_akhir/ui/layanan_surat_online.dart';
import 'package:tugas_akhir/ui/login_page.dart';
import 'package:tugas_akhir/ui/pengaduan_masyarakat_page.dart';
import 'package:tugas_akhir/ui/profile_desa.dart';
import 'package:tugas_akhir/ui/profile_page.dart';
import 'package:tugas_akhir/ui/register_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  
  runApp(TugasAkhirApp());
}

class TugasAkhirApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Akhir',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/', // Set halaman login sebagai halaman awal
      routes: {
        '/': (context) => SplashScreen(),
        '/main':(context) => MainPage(), 
        '/home': (context) => HomePage(), 
        '/layananSuratOnline': (context) => LayananSuratOnlinePage(),
        '/aktivitas': (context) => AktivitasPage(),
        '/profile': (context) => ProfilePage(),
        '/berita' : (context) => BeritaPage(),
        '/dokumen':(context) => DokumenPage(),
        '/profiledesa':(context) => DesaProfilePage(),
        '/pengaduanmasyarakat':(context) => PengaduanMasyarakatPage(),
        '/agenda':(context) => AgendaPage(),
        '/loginpage':(context) => LoginPage(),
        '/register':(context) => RegisterPage(),
        '/adminhome':(context) => AdminHomePage(),
        '/adminsuratpage':(context) => AdminSuratPage(),
        '/dokumenadmin':(context) => DokumenAdminPage(),
        '/beritaadmin':(context) => AdminBeritaPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Daftar halaman untuk tiap item di BottomNavigationBar
  static List<Widget> _pages = <Widget>[
    HomePage(),
    AktivitasPage(),
    ProfilePage(),
  ];

  // Fungsi untuk mengganti halaman berdasarkan item yang dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Aktivitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }
}
