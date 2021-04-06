import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/constant/constants.dart';

///
/// des: 圆形头像
///
class XAvatar extends StatefulWidget {
  final String url;
  final double width, height;
  final String text;

  XAvatar(Key key, this.url, this.width, this.height, {this.text})
      : super(key: key);

  @override
  _XAvatarState createState() => _XAvatarState();
}

class _XAvatarState extends State<XAvatar> {
  String avatarName;

  @override
  Widget build(BuildContext context) {
    avatarName = widget.text;
    if (avatarName == null || avatarName.isEmpty) {
      avatarName = '';
    }
    return CachedNetworkImage(
      imageUrl: widget.url,
      placeholder: (context, url) => _avatarView(null, isPlaceholder: true),
      errorWidget: (context, url, error) => _avatarView(null),
      imageBuilder: (context, image) => _avatarView(image),
    );
  }

  Widget _loader(BuildContext context, String url) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _avatarView(ImageProvider image, {bool isPlaceholder = false}) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Text(avatarName,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center),
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.all(Radius.circular(100)),
        border: Border.all(
          color: Colors.grey,
          width: 0.8,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 0.6,
            spreadRadius: 0.5,
          )
        ],
        image: isPlaceholder
            ? null
            : DecorationImage(
                alignment: Alignment(0, 0),
                fit: BoxFit.cover,
                image: image != null
                    ? image
                    : ExactAssetImage(
                        Constants.ASSETS_IMG + "default_avatar.png")),
        backgroundBlendMode: BlendMode.exclusion,
      ),
    );
  }
}
