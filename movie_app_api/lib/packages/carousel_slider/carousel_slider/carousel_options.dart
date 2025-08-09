import 'dart:async';
import 'package:flutter/material.dart';

import '../carousel_options.dart';

typedef Widget IndexedWidgetBuilder(
  BuildContext context,
  int index,
  int realIndex,
);

class CarouselSlider extends StatefulWidget {
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
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget.options.viewportFraction,
    );

    if (widget.options.autoPlay) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.options.autoPlayAnimationDuration, (_) {
      final totalPages = widget.itemCount ?? widget.items?.length ?? 0;
      if (totalPages == 0 || !_pageController.hasClients) return;

      setState(() {
        _currentPage = (_currentPage + 1) % totalPages;
      });

      _pageController.animateToPage(
        _currentPage,
        duration: widget.options.autoPlayAnimationDuration,
        curve: widget.options.autoPlayCurve,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.options.height;
    final double aspectRatio = widget.options.aspectRatio;

    final pageView = widget.useBuilder &&
            widget.itemBuilder != null &&
            widget.itemCount != null
        ? PageView.builder(
            controller: _pageController,
            scrollDirection: widget.options.scrollDirection,
            pageSnapping: widget.options.pageSnapping,
            itemCount: widget.itemCount,
            itemBuilder: (context, index) {
              return widget.itemBuilder!(context, index, index);
            },
          )
        : PageView(
            controller: _pageController,
            scrollDirection: widget.options.scrollDirection,
            pageSnapping: widget.options.pageSnapping,
            children: widget.items ?? [],
          );

    return Container(
      height: height,
      child: AspectRatio(aspectRatio: aspectRatio, child: pageView),
    );
  }
}
