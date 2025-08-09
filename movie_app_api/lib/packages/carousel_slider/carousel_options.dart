import 'package:flutter/material.dart';

enum CenterPageEnlargeStrategy { scale, height, zoom }

class CarouselOptions {
  final double height;
  final bool autoPlay;
  final Curve autoPlayCurve;
  final Duration autoPlayAnimationDuration;
  final bool enableInfiniteScroll;
  final bool pageSnapping;
  final bool enlargeCenterPage;
  final double viewportFraction;
  final Axis scrollDirection;
  final CenterPageEnlargeStrategy enlargeStrategy;
  final double aspectRatio;

  CarouselOptions({
    this.height = 200.0,
    this.autoPlay = false,
    this.autoPlayCurve = Curves.linear,
    this.autoPlayAnimationDuration = const Duration(milliseconds: 1000),
    this.enableInfiniteScroll = true,
    this.pageSnapping = true,
    this.enlargeCenterPage = false,
    this.viewportFraction = 0.8,
    this.scrollDirection = Axis.horizontal,
    this.enlargeStrategy = CenterPageEnlargeStrategy.scale,
    this.aspectRatio = 16 / 9,
  });
}
