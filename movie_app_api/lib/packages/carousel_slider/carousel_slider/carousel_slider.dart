library carousel_slider;

import 'package:flutter/material.dart';

import '../carousel_options.dart';

typedef Widget IndexedWidgetBuilder(
  BuildContext context,
  int index,
  int realIndex,
);

class CarouselSlider extends StatelessWidget {
  final List<Widget>? items;
  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;
  final CarouselOptions options;
  final bool useBuilder;

  const CarouselSlider({Key? key, required this.items, required this.options})
      : itemBuilder = null,
        itemCount = null,
        useBuilder = false,
        super(key: key);

  const CarouselSlider.builder({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    required this.options,
  })  : items = null,
        useBuilder = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = options.height;
    final double aspectRatio = options.aspectRatio;

    final Widget pageView =
        useBuilder && itemBuilder != null && itemCount != null
            ? PageView.builder(
                scrollDirection: options.scrollDirection,
                pageSnapping: options.pageSnapping,
                controller: PageController(
                  viewportFraction: options.viewportFraction,
                ),
                itemCount: itemCount,
                itemBuilder: (context, index) =>
                    itemBuilder!(context, index, index),
              )
            : PageView(
                scrollDirection: options.scrollDirection,
                pageSnapping: options.pageSnapping,
                controller: PageController(
                  viewportFraction: options.viewportFraction,
                ),
                children: items ?? [],
              );

    return Container(
      height: height,
      child: AspectRatio(aspectRatio: aspectRatio, child: pageView),
    );
  }
}
