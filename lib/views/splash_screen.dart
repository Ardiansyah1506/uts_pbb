import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo dengan animasi skala
            AnimatedScale(
              scale: 1.2,
              duration: Duration(seconds: 3),
              curve: Curves.elasticOut,
              child: Image.asset(
                'assets/logo.jpg', // Ganti dengan logo keyboard Anda
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 20),
            // Teks dengan gaya khusus
            Text(
              'Welcome to MechaKeys Store',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
                fontFamily:
                    'RobotoMono', // Pastikan font sudah ditambahkan di pubspec.yaml
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your one-stop shop for mechanical keyboards!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade300,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 50),
            // Animasi loading
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
