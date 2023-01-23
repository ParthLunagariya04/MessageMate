import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MobileLayoutLoadingEffect extends StatelessWidget {
  const MobileLayoutLoadingEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 3.7, right: 15, bottom: 3.7),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0x80006592),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Shimmer.fromColors(
        baseColor: Color(0xCC038CC9),
        highlightColor: Color(0xCCA1A1A1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), color: Colors.grey),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey),
                ),
                const SizedBox(height: 7),
                Container(
                  width: 150,
                  height: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
