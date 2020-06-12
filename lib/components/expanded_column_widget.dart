import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ExpandedColumnWidget extends StatelessWidget {
  final Widget widget;
  final int flex;
  final ItemType itemType;

  ExpandedColumnWidget(
      {@required this.flex, @required this.widget, @required this.itemType});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: (itemType == ItemType.top)
            ? EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                bottom: 20.0,
              )
            : (itemType == ItemType.middle)
                ? EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 20.0,
                    bottom: 20.0,
                  )
                : EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    top: 20.0,
                  ),
        child: Neumorphic(
          style: NeumorphicStyle(
            shadowDarkColor: Colors.black87,
            shadowLightColor: Colors.white70,
            depth: 1.5,
            color: Colors.grey[850],
            boxShape: NeumorphicBoxShape.roundRect(
              (itemType == ItemType.top)
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    )
                  : (itemType == ItemType.middle)
                      ? BorderRadius.circular(15.0)
                      : BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
            ),
          ),
          child: Container(
            child: widget,
          ),
        ),
      ),
    );
  }
}

enum ItemType {
  top,
  middle,
  bottom,
}
