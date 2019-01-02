import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformProgressIndicator extends StatefulWidget {
  final double size;
  final double strokeWidth;
  PlatformProgressIndicator({
    this.size = 36,
    this.strokeWidth = 4.0,
  });

  @override
  State<StatefulWidget> createState() {
    return PlatformProgressIndicatorState();
  }
}

class PlatformProgressIndicatorState extends State<PlatformProgressIndicator> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoActivityIndicator(radius: widget.size / 2)
          : CircularProgressIndicator(
              strokeWidth: widget.strokeWidth,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
    );
  }
}
