import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageProfileScreen extends StatelessWidget {
  static String routeName = 'imageprofilescreen';
  static String routeURL = '/imageprofilescreen';
  final String imageURL;
  final String herotag;

  const ImageProfileScreen({
    super.key,
    required this.imageURL,
    required this.herotag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white)),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: herotag,
          child: CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            imageUrl: imageURL,
            placeholder: (context, url) => Container(
              height: 70,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
