import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi login menggunakan Firebase Authentication
  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        // Autentikasi dengan Firebase
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Ambil role dari Firestore berdasarkan UID
        String uid = userCredential.user!.uid;
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(uid).get();

        if (userDoc.exists) {
          String role = userDoc['role']; // Ambil role pengguna

          if (role == 'admin') {
            // Navigasi ke halaman Admin
            Navigator.pushReplacementNamed(context, '/adminhome');
          } else if (role == 'user') {
            // Navigasi ke halaman User
            Navigator.pushReplacementNamed(context, '/main');
          } else {
            _showErrorDialog("Role tidak valid.");
          }
        } else {
          _showErrorDialog("Data pengguna tidak ditemukan.");
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'Pengguna tidak ditemukan. Silakan daftar terlebih dahulu.';
        } else if (e.code == 'wrong-password') {
          message = 'Password salah. Silakan coba lagi.';
        } else {
          message = 'Terjadi kesalahan: ${e.message}';
        }
        _showErrorDialog(message);
      }
    } else {
      _showErrorDialog("Email dan Password tidak boleh kosong.");
    }
  }

  // Fungsi login sebagai Guest
  Future<void> _loginAsGuest() async {
    try {
      // Login anonim menggunakan Firebase Authentication
      await _auth.signInAnonymously();

      // Navigasi ke halaman User sebagai Guest
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      _showErrorDialog("Gagal login sebagai Guest. Silakan coba lagi.");
    }
  }

  // Menampilkan pesan error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Login Gagal"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo dan Judul
              Text(
                "Sidakarya",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Login Account",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40),

              // Input Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16),

              // Input Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 8),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Tambahkan navigasi ke halaman "Forgot Password" di sini
                  },
                  child: Text(
                    "Forgot Your Password?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Tombol Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Pemisah atau teks "Or"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Or"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              SizedBox(height: 16),

              // Tombol Login sebagai Guest
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loginAsGuest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Login as Guest',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Tombol Sign Up
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register'); // Navigasi ke halaman Register
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
