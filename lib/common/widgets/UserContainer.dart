import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserContainer extends ConsumerStatefulWidget {
  const UserContainer({
    Key? key,
    required this.name,
    required this.lastMessage,
    required this.networkImage,
    required this.time,
    required this.gradiant,
  }) : super(key: key);

  final String name;
  final String lastMessage;
  final String networkImage;
  final DateTime time;
  final List<Color> gradiant;

  @override
  ConsumerState<UserContainer> createState() => _UserContainerState();
}

class _UserContainerState extends ConsumerState<UserContainer> {
  ///this is for showing like today , yesterday etc..
  String getTextForDate(DateTime date) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat("h:mm a").format(date);
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return DateFormat("yMd").format(date);
    }
  }

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
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
                      Text(getTextForDate(widget.time),
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: SizedBox(
                    width: size.width * 0.5,
                    child: Text(
                      widget.lastMessage,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
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
