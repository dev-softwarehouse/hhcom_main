import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String url;
  final double size;
  const UserAvatar(this.url, {this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: url.isEmpty ? placeHolder :
      CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Stack(
              children: [
                placeHolder,
                Positioned.fill(child: Center(child: CircularProgressIndicator())),
              ],
            )),
        errorWidget: (context, url, error) => placeHolder,
      ),
    );
  }

  get placeHolder => Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('assets/images/unknown.png'),
              fit: BoxFit.cover)));
}
