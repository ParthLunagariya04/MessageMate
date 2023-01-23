import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserImageScreen extends StatelessWidget {
  const UserImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    var imgCode = data['code'];

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.25, horizontal: 5),
      child: Hero(
        tag: 'image',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: imgCode == 1
              ? FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: const AssetImage('assets/avatar.jpg'),
                  image: MemoryImage(data['myImg']),
                )
              : imgCode == 3
                  ? SingleChildScrollView(
                      child: CachedNetworkImage(
                        imageUrl: data['myImg'],
                        maxHeightDiskCache: 2000,
                        placeholder: (context, url) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Image Loading...',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: const AssetImage('assets/avatar.jpg'),
                      image: NetworkImage(data['myImg']),
                    ),
        ),
      ),
    );
  }
}
