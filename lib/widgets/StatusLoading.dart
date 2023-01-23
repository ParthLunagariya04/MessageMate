import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StatusLoading extends StatelessWidget {
  const StatusLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Shimmer.fromColors(
        baseColor: Color(0xCC038CC9),
        highlightColor: Color(0xCCC4C2C2),
        child: Column(
          children: [
            CircleAvatar(radius: 30),
            const SizedBox(height: 5),
            Container(
              width: 50,
              height: 15,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
