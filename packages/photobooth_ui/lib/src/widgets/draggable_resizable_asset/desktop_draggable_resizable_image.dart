import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _cornerDiameter = 15.0;

/// {@template desktop_draggable_resizable_image}
/// A widget which allows a user to drag and resize the provided [image].
/// {@endtemplate}
class DesktopDraggableResizableImage extends StatefulWidget {
  /// {@macro draggable_resizable_asset}
  DesktopDraggableResizableImage({
    Key? key,
    required this.image,
    required this.height,
    this.onUpdate,
  }) : super(key: key);

  /// Image that will be draggable and resizable
  final Uint8List image;

  /// Height image
  final double height;

  /// Drag/Resize value setter.
  final ValueSetter<DragUpdate>? onUpdate;

  @override
  _DesktopDraggableResizableImageState createState() =>
      _DesktopDraggableResizableImageState();
}

class _DesktopDraggableResizableImageState
    extends State<DesktopDraggableResizableImage> {
  late double height;
  late double width;
  late double minHeight;
  late double maxHeight;

  double? top;
  double? left;
  Size? initialSize;

  @override
  void initState() {
    super.initState();
    maxHeight = widget.height.toDouble();
    minHeight = maxHeight * 0.05;
    height = maxHeight * 0.25;
    width = height;
  }

  double _getNewHeight(double value) {
    if (value >= maxHeight) return maxHeight;
    if (value <= minHeight) return minHeight;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        initialSize ??= Size(constraints.maxWidth, constraints.maxHeight);
        left = left ??= constraints.maxWidth / 2 - (width / 2);
        top = top ??= constraints.maxHeight / 2 - (height / 2);

        final widthFactor = constraints.maxWidth / initialSize!.width;
        final heightFactor = constraints.maxHeight / initialSize!.height;

        final normalizedWidth = width * widthFactor;
        final normalizedHeight = height * heightFactor;

        final normalizedLeft = left! * widthFactor;
        final normalizedTop = top! * heightFactor;

        widget.onUpdate?.call(
          DragUpdate(
            position: Offset(normalizedLeft, normalizedTop),
            size: Size(normalizedWidth, normalizedHeight),
          ),
        );

        return Stack(
          children: <Widget>[
            //Image
            Positioned(
              top: normalizedTop,
              left: normalizedLeft,
              child: _DraggablePoint(
                key: const Key('draggableResizableAsset_image_draggablePoint'),
                onDrag: (dx, dy) {
                  setState(() {
                    top = top! + (dy / heightFactor);
                    left = left! + (dx / widthFactor);
                  });
                  widget.onUpdate?.call(
                    DragUpdate(
                      position: Offset(normalizedLeft, normalizedTop),
                      size: Size(normalizedWidth, normalizedHeight),
                    ),
                  );
                },
                child: Container(
                  height: normalizedHeight,
                  width: normalizedWidth,
                  child: Image.memory(
                    widget.image,
                    height: normalizedHeight,
                    width: normalizedWidth,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
            // Top Left Corner
            Positioned(
              top: normalizedTop - _cornerDiameter / 2,
              left: normalizedLeft - _cornerDiameter / 2,
              child: _ResizePoint(
                key: const Key('draggableResizableAsset_topLeft_resizePoint'),
                onDrag: (dx, dy) {
                  final mid = (dx + dy) / 2;
                  final tempNewHeight = (height - 2 * mid).abs();
                  final tempNewWidth = (width - 2 * mid).abs();

                  if (tempNewHeight >= maxHeight ||
                      tempNewHeight <= minHeight) {
                    return;
                  }

                  setState(() {
                    height = _getNewHeight(tempNewHeight);
                    width = tempNewWidth;
                    top = top! + mid;
                    left = left! + mid;
                  });

                  widget.onUpdate?.call(
                    DragUpdate(
                      position: Offset(normalizedLeft, normalizedTop),
                      size: Size(normalizedWidth, normalizedHeight),
                    ),
                  );
                },
              ),
            ),

            // Top Right corner
            Positioned(
              top: normalizedTop - _cornerDiameter / 2,
              left: normalizedLeft + normalizedWidth - _cornerDiameter / 2,
              child: _ResizePoint(
                key: const Key('draggableResizableAsset_topRight_resizePoint'),
                onDrag: (dx, dy) {
                  final mid = (dx + (dy * -1)) / 2;
                  final tempNewHeight = height + 2 * mid;
                  final tempNewWidth = width + 2 * mid;

                  if (tempNewHeight >= maxHeight ||
                      tempNewHeight <= minHeight) {
                    return;
                  }

                  setState(() {
                    height = _getNewHeight(tempNewHeight);
                    width = tempNewWidth;
                    top = top! - mid;
                    left = left! - mid;
                  });

                  widget.onUpdate?.call(
                    DragUpdate(
                      position: Offset(normalizedLeft, normalizedTop),
                      size: Size(normalizedWidth, normalizedHeight),
                    ),
                  );
                },
              ),
            ),

            // Bottom right corner
            Positioned(
              top: normalizedTop + normalizedHeight - _cornerDiameter / 2,
              left: normalizedLeft + normalizedWidth - _cornerDiameter / 2,
              child: _ResizePoint(
                key: const Key(
                  'draggableResizableAsset_bottomRight_resizePoint',
                ),
                onDrag: (dx, dy) {
                  final mid = (dx + dy) / 2;
                  final tempNewHeight = height + 2 * mid;
                  final tempNewWidth = width + 2 * mid;

                  if (tempNewHeight >= maxHeight ||
                      tempNewHeight <= minHeight) {
                    return;
                  }

                  setState(() {
                    height = _getNewHeight(tempNewHeight);
                    width = tempNewWidth;
                    top = top! - mid;
                    left = left! - mid;
                  });

                  widget.onUpdate?.call(
                    DragUpdate(
                      position: Offset(normalizedLeft, normalizedTop),
                      size: Size(normalizedWidth, normalizedHeight),
                    ),
                  );
                },
              ),
            ),

            // Bottom left corner
            Positioned(
              top: normalizedTop + normalizedHeight - _cornerDiameter / 2,
              left: normalizedLeft - _cornerDiameter / 2,
              child: _ResizePoint(
                key: const Key(
                  'draggableResizableAsset_bottomLeft_resizePoint',
                ),
                onDrag: (dx, dy) {
                  final mid = ((dx * -1) + dy) / 2;
                  final tempNewHeight = height + 2 * mid;
                  final tempNewWidth = width + 2 * mid;

                  if (tempNewHeight >= maxHeight ||
                      tempNewHeight <= minHeight) {
                    return;
                  }

                  setState(() {
                    height = _getNewHeight(tempNewHeight);
                    width = tempNewWidth;
                    top = top! - mid;
                    left = left! - mid;
                  });

                  widget.onUpdate?.call(
                    DragUpdate(
                      position: Offset(normalizedLeft, normalizedTop),
                      size: Size(normalizedWidth, normalizedHeight),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ResizePoint extends StatelessWidget {
  const _ResizePoint({Key? key, required this.onDrag}) : super(key: key);

  final void Function(double, double) onDrag;

  @override
  Widget build(BuildContext context) {
    return _DraggablePoint(
      onDrag: onDrag,
      child: Container(
        width: _cornerDiameter,
        height: _cornerDiameter,
        decoration: BoxDecoration(
          border: Border.all(color: PhotoboothColors.blue, width: 2),
          shape: BoxShape.circle,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: PhotoboothColors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _DraggablePoint extends StatefulWidget {
  const _DraggablePoint({Key? key, required this.child, required this.onDrag})
      : super(key: key);

  final Widget child;
  final void Function(double, double) onDrag;

  @override
  _DraggablePointState createState() => _DraggablePointState();
}

class _DraggablePointState extends State<_DraggablePoint> {
  late double initX;
  late double initY;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        initX = details.globalPosition.dx;
        initY = details.globalPosition.dy;
      },
      onPanUpdate: (details) {
        final dx = details.globalPosition.dx - initX;
        final dy = details.globalPosition.dy - initY;
        initX = details.globalPosition.dx;
        initY = details.globalPosition.dy;
        widget.onDrag(dx, dy);
      },
      child: widget.child,
    );
  }
}