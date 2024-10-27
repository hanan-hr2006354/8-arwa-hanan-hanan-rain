import 'package:flutter/material.dart';

class ManageCashingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFFF7),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 7.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.PNG'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Manage Cashing',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF915050),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    ' ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF915050).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 3.4,
            left: 0,
            right: 0,
            child: ClipPath(
              child: Container(
                color: Color(0xFFFEFFF7),
                padding: EdgeInsets.all(30),
                child: Column(children: []),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
