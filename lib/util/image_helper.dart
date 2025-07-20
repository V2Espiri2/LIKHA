import 'package:flutter/material.dart';

Widget buildSafeImage(
  String path, {
  double? height,
  double? width,
  BoxFit fit = BoxFit.cover,
}) {
  return Image.asset(
    path,
    height: height,
    width: width ?? double.infinity,
    fit: fit,
    errorBuilder: (context, error, stackTrace) => Container(
      height: height,
      width: width ?? double.infinity,
      color: Colors.grey[700],
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image, color: Colors.white, size: 40),
    ),
  );
}
