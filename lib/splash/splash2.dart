import 'package:flutter/material.dart';

class Splash2 extends StatefulWidget {
  const Splash2(this.segs, this.classe, {super.key});

  final int segs;
  final Widget classe;

  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: widget.segs), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget.classe,
        ), //passar o usuario aqui
      );
    });
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
