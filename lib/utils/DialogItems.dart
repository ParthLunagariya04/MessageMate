import 'package:flutter/material.dart';

class DialogItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;

  const DialogItem(
      {Key? key, required this.icon, required this.name, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.white),
          Text(
            name,
            style: const TextStyle(fontSize: 10, color: Colors.white),
          )
        ],
      ),
    );
  }
}
