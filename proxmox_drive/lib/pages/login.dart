import 'package:flutter/material.dart';

class Login extends StatelessWidget {

  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proxmox Drive"),
      ),
      body: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all()
            ),
            child: Column(
              children: [
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}