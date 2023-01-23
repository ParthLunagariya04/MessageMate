import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WorldWideUserContainer extends ConsumerStatefulWidget {
  const WorldWideUserContainer({
    Key? key,
    required this.name,
    required this.networkImage,
    required this.gradiant,
  }) : super(key: key);

  final String name;
  final String networkImage;
  final List<Color> gradiant;

  @override
  ConsumerState<WorldWideUserContainer> createState() =>
      _WorldWideUserContainerState();
}

class _WorldWideUserContainerState
    extends ConsumerState<WorldWideUserContainer> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 3.7, right: 15, bottom: 3.7),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: widget.gradiant),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          /*const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(net),
          ),*/
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: FadeInImage(
              fit: BoxFit.cover,
              width: 45,
              height: 45,
              placeholder: const AssetImage('assets/avatar.jpg'),
              image: NetworkImage(widget.networkImage),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * 0.7,
                  child: Expanded(
                    child: Text(
                      toBeginningOfSentenceCase(widget.name).toString(),
                      maxLines: 1,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
