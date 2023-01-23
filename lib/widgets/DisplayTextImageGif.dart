import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi/feature/enums/MessageEnums.dart';
import 'package:hi/widgets/VideoPlayerItem.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGif(
      {Key? key, required this.message, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(message,
                style: const TextStyle(color: Colors.white, fontSize: 17)),
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(videoUrl: message)
            : Hero(
                  tag: 'image',
                  child: CachedNetworkImage(
                    imageUrl: message,
                    fit: BoxFit.cover,
                    maxHeightDiskCache: 250,
                    placeholder: (context, url) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Image Loading...',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
              );
  }
}
/*
onTap: () {
Navigator.pushNamed(
context,
'/UserImageScreen',
arguments: {'myImg': message, 'code': 3},
);
},*/
