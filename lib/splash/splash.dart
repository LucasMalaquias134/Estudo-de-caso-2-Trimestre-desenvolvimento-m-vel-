import 'package:estudo_de_caso_2_trimestre/conteudo/telaPrincipal.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Telaprincipal()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone,
              color: Colors.indigoAccent,
              size: 150,
              shadows: [Shadow(blurRadius: 10, color: Colors.indigo)],
            ),
            SizedBox(height: 100),
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: Colors.indigo,
                strokeWidth: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
