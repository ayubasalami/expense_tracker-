import 'package:flutter/material.dart';

class My_screen_button extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onpressed;
  My_screen_button(
      {required this.text, required this.icon, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(20),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.orange),
        ),
        onPressed: onpressed,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
