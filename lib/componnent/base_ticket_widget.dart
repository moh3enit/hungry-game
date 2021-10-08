import 'package:flutter/material.dart';

class BaseTicketWidget extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final Color color;
  final bool isCornerRounded;

  BaseTicketWidget(
      {@required this.width,
        @required this.height,
        @required this.child,
        this.color = Colors.white,
        this.isCornerRounded = false});

  @override
  _BaseTicketWidgetState createState() => _BaseTicketWidgetState();
}
class _BaseTicketWidgetState extends State<BaseTicketWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: AnimatedContainer(
        duration: Duration(seconds: 3),
        width: widget.width,
        height: widget.height,
        child: widget.child,
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: widget.isCornerRounded
                ? BorderRadius.circular(20.0)
                : BorderRadius.circular(0.0)),
      ),
    );
  }
}