import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShowImage extends StatelessWidget {
  final dynamic imagelink;
  final BoxFit boxFit;
  final double? height;
  final double? width;

  const ShowImage({
    Key? key,
    required this.imagelink,
    this.boxFit = BoxFit.cover,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagelink == '' || imagelink == null) {
      return FancyShimmerImage(
        imageUrl: imagelink,
        boxFit: boxFit,
        errorWidget: myErrorImage,
        height: height ?? 300,
        width: width  ?? 300,
      );
    } else if (imagelink.runtimeType != String) {
      return Image.file(
        imagelink,
        fit: boxFit,
        height: height,
        width: width,
      );
    } else if (imagelink.toString().contains('http') &&
        imagelink.toString().contains('://') && !imagelink.toString().contains('.svg')) {
      return FancyShimmerImage(
        imageUrl: imagelink,
        boxFit: boxFit,
        errorWidget: myErrorImage,
        height: height ?? 300,
        width: width ?? 300,
      );
    } else if (imagelink.toString().contains('.svg') &&
        imagelink.toString().contains('assets')) {
      return SvgPicture.asset(
        imagelink,
        fit: boxFit,
        height: height,
        width: width,
      );
    } else if (imagelink.toString().contains('http') &&
        imagelink.toString().contains('://')&&
        imagelink.toString().contains('.svg')) {
      return SvgPicture.network(
        imagelink,
        fit: boxFit,
        height: height,
        width: width,
      );
    } else {
      return Image.asset(
        imagelink,
        fit: boxFit,
        height: height,
        width: width,
      );
    }
  }
}


Image myErrorImage = Image.network(
    'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png');