import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class NetworkImageHandel extends StatelessWidget {
  const NetworkImageHandel({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: MediaQuery.sizeOf(context).width / 3.2,
        height: MediaQuery.sizeOf(context).height / 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
      ),
      errorWidget: (context, url, error) => const ErrorNetworkImage(),
      placeholder: (context, url) => const ErrorNetworkImage(),
    );
  }
}

class ErrorNetworkImage extends StatelessWidget {
  const ErrorNetworkImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: MediaQuery.sizeOf(context).width / 2.9,
      height: MediaQuery.sizeOf(context).height / 4.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: MemoryImage(kTransparentImage), fit: BoxFit.cover)),
    );
  }
}
