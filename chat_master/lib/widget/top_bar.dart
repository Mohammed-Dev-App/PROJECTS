import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  String _barTitle;
  Widget? primaryAction;
  Widget? secondaryAction;
  double? fontsize;
  TopBar(
    this._barTitle, {
    super.key,
    this.fontsize = 32,
    this.primaryAction,
    this.secondaryAction,
  });
  late double _deviceHieght;
  late double _deviceWidth;
  @override
  Widget build(BuildContext context) {
    _deviceHieght = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Container(
      height: _deviceHieght * 0.10,
      width: _deviceWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondaryAction != null) secondaryAction!,
          _titlBar(),
          if (primaryAction != null) primaryAction!,
        ],
      ),
    );
  }

  Widget _titlBar() {
    return Text(
      _barTitle,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontsize,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
