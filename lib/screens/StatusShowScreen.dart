import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi/Models/StatusModel.dart';
import 'package:hi/common/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:story_view/widgets/story_view.dart';

class StatuesShowScreen extends ConsumerStatefulWidget {
  const StatuesShowScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StatuesShowScreen> createState() => _StatuesShowScreenState();
}

class _StatuesShowScreenState extends ConsumerState<StatuesShowScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItem = [];

  @override
  void initState() {
    super.initState();
    //initStoryPageItem();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void initStoryPageItem(var statusData) {
    for (int i = 0; i < statusData.length; i++) {
      storyItem.add(
        StoryItem.pageImage(
          duration: const Duration(seconds: 15),
          url: statusData[i],
          controller: controller,
        ),
      );
    }
  }

  ///this is for showing like today , yesterday etc...
  String getTextForDate(DateTime date) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "...";
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    var statusData = data['statusData'];
    var userName = data['userName'];
    var profilePic = data['profilePic'];
    var createdAt = data['createdAt'];
    //getTextForDate(createdAt);

    initStoryPageItem(statusData);
    return Scaffold(
      body: storyItem.isEmpty
          ? const Loader()
          : SafeArea(
              child: Stack(
                children: [
                  StoryView(
                    storyItems: storyItem,
                    controller: controller,
                    onComplete: () => Navigator.pop(context),
                    onVerticalSwipeComplete: (direction) {
                      if (direction == Direction.down) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 20,
                    child: Container(
                      margin: const EdgeInsets.only(right: 160, left: 10),
                      padding:
                          const EdgeInsets.only(top: 8, left: 8, bottom: 8),
                      decoration: const BoxDecoration(
                        color: Color(0x6600dbfe),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                              backgroundImage: NetworkImage(profilePic),
                              radius: 20),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 130,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  getTextForDate(createdAt) +
                                      DateFormat(" h:mm a").format(createdAt),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
