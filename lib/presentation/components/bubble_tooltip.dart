import 'package:drug_discount_app/presentation/components/arrow_clipper.dart';
import 'package:flutter/material.dart';

class BubbleTooltip extends StatefulWidget {
  final String message;
  final Widget child;

  const BubbleTooltip({Key? key, required this.message, required this.child})
      : super(key: key);

  @override
  _BubbleTooltipState createState() => _BubbleTooltipState();
}

class _BubbleTooltipState extends State<BubbleTooltip>
    with SingleTickerProviderStateMixin {
  final color = Colors.black.withAlpha(120);
  late GlobalKey globalKey;
  late Offset _offset;
  late Size _size;
  late OverlayEntry overlayEntry;

  late AnimationController _controller;

  @override
  void initState() {
    globalKey = LabeledGlobalKey(widget.message);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 20),
    );
    super.initState();
  }

  void getWidgetDetails() {
    final renderBox = globalKey.currentContext?.findRenderObject() as RenderBox;
    _size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    _offset = offset;
  }

  OverlayEntry _makeOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: _offset.dy + 40,
        left: _offset.dx - 25,
        width: _size.width + 50,
        child: ScaleTransition(
          scale: Tween<double>(begin: .5, end: .9).animate(_controller),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: ClipPath(
                  clipper: ArrowClip(),
                  child: Container(
                    height: 10,
                    width: 15,
                    decoration: BoxDecoration(
                      color: color,
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    widget.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  padding: const EdgeInsets.all(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: globalKey,
      child: widget.child,
      onTap: () {},
      onHover: (value) {
        if (value) {
          getWidgetDetails();
          overlayEntry = _makeOverlay();
          _controller.forward();
          Overlay.of(context)?.insert(overlayEntry);
        } else {
          _controller.reverse();
          overlayEntry.remove();
        }
      },
    );
  }
}
