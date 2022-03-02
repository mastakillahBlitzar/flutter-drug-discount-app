import 'dart:async';

import 'package:drug_discount_app/constants.dart';
import 'package:drug_discount_app/presentation/components/arrow_clipper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class CustomTooltip extends StatefulWidget {
  final Widget content;
  final Widget? contentOnHover;
  final String? message;
  final Color tooltipColor;

  const CustomTooltip(
      {Key? key,
      required this.content,
      this.message,
      this.contentOnHover,
      this.tooltipColor = Colors.white})
      : assert((message == null) != (contentOnHover == null),
            'Either `message` or `contentOnHover` must be specified'),
        super(key: key);

  static final List<_TooltipState> _openedTooltips = <_TooltipState>[];

  // Causes any current tooltips to be concealed. Only called for mouse hover enter
  // detections. Won't conceal the supplied tooltip.
  static void _concealOtherTooltips(_TooltipState current) {
    if (_openedTooltips.isNotEmpty) {
      // Avoid concurrent modification.
      final List<_TooltipState> openedTooltips = _openedTooltips.toList();
      for (final _TooltipState state in openedTooltips) {
        if (state == current) {
          continue;
        }
        state._concealTooltip();
      }
    }
  }

  // Causes the most recently concealed tooltip to be revealed. Only called for mouse
  // hover exit detections.
  static void _revealLastTooltip() {
    if (_openedTooltips.isNotEmpty) {
      _openedTooltips.last._revealTooltip();
    }
  }

  @override
  State<CustomTooltip> createState() => _TooltipState();
}

class _TooltipState extends State<CustomTooltip>
    with SingleTickerProviderStateMixin {
  late bool _isConcealed;
  late bool _forceRemoval;
  static const Duration _fadeInDuration = Duration(milliseconds: 50);
  static const Duration _fadeOutDuration = Duration(milliseconds: 100);

  late double height;
  late EdgeInsetsGeometry padding;
  late EdgeInsetsGeometry margin;
  late Decoration decoration;
  late TextStyle textStyle;
  late double verticalOffset;
  late bool preferBelow;
  late AnimationController _controller;
  OverlayEntry? _entry;
  Timer? _dismissTimer;

  late bool _mouseIsConnected;
  late bool _visible;

  Duration hoverShowDuration = const Duration(milliseconds: 100);
  Color get _tooltipColor => widget.tooltipColor;

  Widget? get _tooltipMessage => widget.message != null
      ? Text.rich(
          TextSpan(text: widget.message),
          style: textStyle,
        )
      : widget.contentOnHover;

  @override
  void initState() {
    super.initState();
    _isConcealed = false;
    _forceRemoval = false;
    _mouseIsConnected = RendererBinding.instance!.mouseTracker.mouseIsConnected;
    _controller = AnimationController(
      duration: _fadeInDuration,
      reverseDuration: _fadeOutDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);
    // Listen to see when a mouse is added.
    RendererBinding.instance!.mouseTracker
        .addListener(_handleMouseTrackerChange);
    // Listen to global pointer events so that we can hide a tooltip immediately
    // if some other control is clicked on.
    GestureBinding.instance!.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

  void _handleStatusChanged(AnimationStatus status) {
    // If this tip is concealed, don't remove it, even if it is dismissed, so that we can
    // reveal it later, unless it has explicitly been hidden with _dismissTooltip.
    if (status == AnimationStatus.dismissed &&
        (_forceRemoval || !_isConcealed)) {
      _removeEntry();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visible = TooltipVisibility.of(context);
  }

  double _getDefaultFontSize() {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return 10.0;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        return 14.0;
    }
  }

  // Forces a rebuild if a mouse has been added or removed.
  void _handleMouseTrackerChange() {
    if (!mounted) {
      return;
    }
    final bool mouseIsConnected =
        RendererBinding.instance!.mouseTracker.mouseIsConnected;
    if (mouseIsConnected != _mouseIsConnected) {
      setState(() {
        _mouseIsConnected = mouseIsConnected;
      });
    }
  }

  void _concealTooltip() {
    if (_isConcealed || _forceRemoval) {
      // Already concealed, or it's being removed.
      return;
    }
    _isConcealed = true;
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (_entry != null) {
      _entry!.remove();
    }
    _controller.reverse();
  }

  void _handleMouseEnter() {
    _showTooltip();
  }

  void _handleMouseExit({bool immediately = false}) {
    // If the tip is currently covered, we can just remove it without waiting.
    _dismissTooltip(immediately: _isConcealed || immediately);
  }

  void _dismissTooltip({bool immediately = false}) {
    if (immediately) {
      _removeEntry();
      return;
    }
    // So it will be removed when it's done reversing, regardless of whether it is
    // still concealed or not.
    _forceRemoval = true;

    _dismissTimer ??= Timer(hoverShowDuration, _controller.reverse);
    //_removeEntry();
  }

  void _revealTooltip() {
    if (!_isConcealed) {
      // Already uncovered.
      return;
    }
    _isConcealed = false;
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (!_entry!.mounted) {
      final OverlayState overlayState = Overlay.of(
        context,
        debugRequiredFor: widget,
      )!;
      overlayState.insert(_entry!);
    }
    _controller.forward();
  }

  bool _showTooltip() {
    if (!_visible) return false;
    _forceRemoval = false;
    if (_isConcealed) {
      if (_mouseIsConnected) {
        CustomTooltip._concealOtherTooltips(this);
      }
      _revealTooltip();
      return true;
    }
    if (_entry != null) {
      // Stop trying to hide, if we were.
      _dismissTimer?.cancel();
      _dismissTimer = null;
      _controller.forward();
      return false; // Already visible.
    }
    _createNewEntry();
    _controller.forward();
    return true;
  }

  void _createNewEntry() {
    final OverlayState overlayState = Overlay.of(
      context,
      debugRequiredFor: widget,
    )!;

    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );

    const double bubblePointerWidth = 30;
    const double bubblePointerHeight = 6;

    // We create this widget outside of the overlay entry's builder to prevent
    // updated values from happening to leak into the overlay when the overlay
    // rebuilds.
    final Widget overlay = Directionality(
      textDirection: Directionality.of(context),
      child: _TooltipOverlay(
        richMessage: _tooltipMessage ?? const Text(""),
        height: height,
        padding: padding,
        margin: margin,
        onEnter: _mouseIsConnected ? (_) => _handleMouseEnter() : null,
        onExit: _mouseIsConnected ? (_) => _handleMouseExit() : null,
        decoration: decoration,
        textStyle: textStyle,
        animation: CurvedAnimation(
          parent: _controller,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.easeIn,
        ),
        target: target,
        verticalOffset: verticalOffset,
        preferBelow: preferBelow,
        tooltipColor: _tooltipColor,
        bubblePointerDimensions:
            const Offset(bubblePointerWidth, bubblePointerHeight),
      ),
    );
    _entry = OverlayEntry(builder: (BuildContext context) => overlay);
    _isConcealed = false;
    overlayState.insert(_entry!);
    if (_mouseIsConnected) {
      // Hovered tooltips shouldn't show more than one at once. For example, a chip with
      // a delete icon shouldn't show both the delete icon tooltip and the chip tooltip
      // at the same time.
      CustomTooltip._concealOtherTooltips(this);
    }
    assert(!CustomTooltip._openedTooltips.contains(this));
    CustomTooltip._openedTooltips.add(this);
  }

  void _removeEntry() {
    CustomTooltip._openedTooltips.remove(this);
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (!_isConcealed) {
      _entry?.remove();
    }
    _isConcealed = false;
    _entry = null;
    if (_mouseIsConnected) {
      CustomTooltip._revealLastTooltip();
    }
  }

  void _handlePointerEvent(PointerEvent event) {
    if (_entry == null) {
      return;
    }
    if (event is PointerUpEvent || event is PointerCancelEvent) {
      _handleMouseExit();
    } else if (event is PointerDownEvent) {
      _handleMouseExit(immediately: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final TextStyle defaultTextStyle;

    final BoxDecoration defaultDecoration;

    defaultTextStyle = theme.textTheme.bodyText2!.copyWith(
      color: Colors.black,
      fontSize: _getDefaultFontSize(),
    );
    defaultDecoration = BoxDecoration(
      color: _tooltipColor,
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 8),
          blurRadius: 6,
          color: kPrimaryColor.withOpacity(0.22),
        ),
      ],
    );

    height = 20;
    padding = const EdgeInsets.all(10);
    margin = const EdgeInsets.all(12);
    verticalOffset = 24;
    preferBelow = true;

    decoration = defaultDecoration;
    textStyle = defaultTextStyle;

    Widget result = widget.content;
    if (_visible && _mouseIsConnected) {
      result = MouseRegion(
        onEnter: (_) => _handleMouseEnter(),
        onExit: (_) => _handleMouseExit(),
        child: result,
      );
    }

    return result;
  }
}

enum _Slot {
  bubble,
  arrow,
}

class _TooltipPositionDelegate extends MultiChildLayoutDelegate {
  /// Creates a delegate for computing the layout of a tooltip.
  ///
  /// The arguments must not be null.
  _TooltipPositionDelegate({
    required this.bubblePointerDimensions,
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
  })  : assert(target != null),
        assert(verticalOffset != null),
        assert(preferBelow != null);

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system.
  final Offset target;

  /// The amount of vertical distance between the target and the displayed
  /// tooltip.
  final double verticalOffset;

  /// Whether the tooltip is displayed below its widget by default.
  ///
  /// If there is insufficient space to display the tooltip in the preferred
  /// direction, the tooltip will be displayed in the opposite direction.
  final bool preferBelow;

  final Offset bubblePointerDimensions;

  @override
  bool shouldRelayout(_TooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow;
  }

  @override
  void performLayout(Size size) {
    Size leaderSize = Size.zero;

    if (hasChild(_Slot.bubble)) {
      leaderSize = layoutChild(_Slot.bubble, BoxConstraints.loose(size));
      positionChild(
          _Slot.bubble,
          positionDependentBox(
            size: size,
            childSize: leaderSize,
            target: target,
            preferBelow: preferBelow,
            verticalOffset: verticalOffset,
          ));
    }

    if (hasChild(_Slot.arrow)) {
      layoutChild(_Slot.arrow, BoxConstraints.loose(size));
      positionChild(
          _Slot.arrow,
          Offset(target.dx - bubblePointerDimensions.dx / 2,
              target.dy + verticalOffset + bubblePointerDimensions.dy));
    }
  }
}

class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    Key? key,
    required this.height,
    required this.richMessage,
    this.padding,
    this.margin,
    this.decoration,
    this.textStyle,
    required this.animation,
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
    this.onEnter,
    this.onExit,
    required this.tooltipColor,
    required this.bubblePointerDimensions,
  }) : super(key: key);

  final Widget richMessage;
  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final Animation<double> animation;
  final Offset target;
  final double verticalOffset;
  final bool preferBelow;
  final Color tooltipColor;
  final Offset bubblePointerDimensions;
  final PointerEnterEventListener? onEnter;
  final PointerExitEventListener? onExit;

  @override
  Widget build(BuildContext context) {
    Widget result = IgnorePointer(
        child: FadeTransition(
      opacity: animation,
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyText2!,
              child: Container(
                decoration: decoration,
                padding: padding,
                margin: margin,
                child: Center(
                    widthFactor: 1.0, heightFactor: 1.0, child: richMessage),
              ),
            ),
          ),
        ],
      ),
    ));
    if (onEnter != null || onExit != null) {
      result = MouseRegion(
        onEnter: onEnter,
        onExit: onExit,
        child: result,
      );
    }
    Widget arrow = ClipPath(
      clipper: ArrowClip(),
      child: IgnorePointer(
        child: FadeTransition(
          opacity: animation,
          child: Container(
            height: bubblePointerDimensions.dy,
            width: bubblePointerDimensions.dx,
            decoration: BoxDecoration(
              color: tooltipColor,
            ),
          ),
        ),
      ),
    );
    return Positioned.fill(
      child: CustomMultiChildLayout(
        delegate: _TooltipPositionDelegate(
          bubblePointerDimensions: bubblePointerDimensions,
          target: target,
          verticalOffset: verticalOffset,
          preferBelow: preferBelow,
        ),
        children: [
          LayoutId(id: _Slot.bubble, child: result),
          LayoutId(id: _Slot.arrow, child: arrow),
        ],
      ),
    );
  }
}
