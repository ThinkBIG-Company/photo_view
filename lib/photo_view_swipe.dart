import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewSwipe extends StatefulWidget {
  final ImageProvider imageProvider;
  final Color? dragBgColor;
  final double? dragDistance;

  // Standard photo_view
  final LoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final Decoration? backgroundDecoration;
  final bool gaplessPlayback;
  final PhotoViewHeroAttributes? heroAttributes;
  final ValueChanged<PhotoViewScaleState>? scaleStateChangedCallback;
  final bool enableRotation;
  final PhotoViewControllerBase? controller;
  final dynamic maxScale;
  final dynamic minScale;
  final dynamic initialScale;
  final Alignment? basePosition;
  final ScaleStateCycle? scaleStateCycle;
  final PhotoViewImageTapUpCallback? onTapUp;
  final PhotoViewImageTapDownCallback? onTapDown;
  final Size? customSize;
  final HitTestBehavior? gestureDetectorBehavior;
  final bool? tightMode;
  final FilterQuality? filterQuality;

  final Widget? child;
  final Size? childSize;

  PhotoViewSwipe(
      {Key? key,
      required this.imageProvider,
      this.dragBgColor = Colors.black, // default Colors.black.withOpacity(0.5)
      this.dragDistance = 160, // default 160

      // Standard photo_view
      this.loadingBuilder,
      this.errorBuilder,
      this.backgroundDecoration,
      this.gaplessPlayback = false,
      this.heroAttributes,
      this.scaleStateChangedCallback,
      this.enableRotation = false,
      this.controller,
      this.maxScale,
      this.minScale,
      this.initialScale,
      this.basePosition,
      this.scaleStateCycle,
      this.onTapUp,
      this.onTapDown,
      this.customSize,
      this.gestureDetectorBehavior,
      this.tightMode,
      this.filterQuality})
      : child = null,
        childSize = null,
        super(key: key);

  @override
  _PhotoViewSwipeState createState() => _PhotoViewSwipeState();
}

class _PhotoViewSwipeState extends State<PhotoViewSwipe> {
  Offset _position = const Offset(0.0, 0.0);
  bool _isZoomed = false;
  late PhotoViewScaleStateController scaleStateController;

  @override
  void initState() {
    scaleStateController = PhotoViewScaleStateController();
    scaleStateController.outputScaleStateStream.listen((event) {
      setState(() {
        _isZoomed = event != PhotoViewScaleState.zoomedOut &&
            event != PhotoViewScaleState.initial;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    scaleStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dragBgColor,
      body: Stack(
        children: [
          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: GestureDetector(
              onVerticalDragUpdate: !_isZoomed
                  ? (details) {
                      setState(() => _position =
                          Offset(0.0, _position.dy + details.delta.dy));
                    }
                  : null,
              onVerticalDragEnd: !_isZoomed
                  ? (details) {
                      double pixelsPerSecond = _position.dy.abs();
                      if (pixelsPerSecond > widget.dragDistance!) {
                        Navigator.pop(context);
                      } else {
                        setState(() => _position = Offset(0.0, 0.0));
                      }
                    }
                  : null,
              child: Container(
                decoration: _position.dy == 0.0
                    ? (widget.backgroundDecoration ??
                        const BoxDecoration(color: Colors.black))
                    : null,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: PhotoView(
                  imageProvider: widget.imageProvider,
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.transparent),
                  scaleStateController: scaleStateController,
                  loadingBuilder: widget.loadingBuilder,
                  errorBuilder: widget.errorBuilder,
                  gaplessPlayback: widget.gaplessPlayback,
                  heroAttributes: widget.heroAttributes,
                  scaleStateChangedCallback: widget.scaleStateChangedCallback,
                  enableRotation: widget.enableRotation,
                  controller: widget.controller,
                  maxScale: widget.maxScale,
                  minScale: widget.minScale,
                  initialScale: widget.initialScale,
                  basePosition: widget.basePosition,
                  scaleStateCycle: widget.scaleStateCycle,
                  onTapUp: widget.onTapUp,
                  onTapDown: widget.onTapDown,
                  customSize: widget.customSize,
                  gestureDetectorBehavior: widget.gestureDetectorBehavior,
                  tightMode: widget.tightMode,
                  filterQuality: widget.filterQuality,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
