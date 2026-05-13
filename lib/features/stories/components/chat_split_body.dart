import "dart:ui";

import "package:dth_v4/features/stories/components/reel_backdrop_media.dart";
import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/stories/components/chat_panel.dart";
import "package:dth_v4/features/tickets/tickets.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

/// Reel + chat with an explicit split height. Scrolling the chat list at the
/// top grows the sheet (shrinks the reel) until [maxSheetFraction]; dragging
/// on the reel or grab strip does the same. Uses [ScrollPhysics] so list
/// scroll deltas resize the split instead of getting stuck on the video.
class ChatSplitBody extends StatefulWidget {
  const ChatSplitBody({
    super.key,
    required this.imageUrl,
    this.videoUrl,
    this.videoType,
    required this.topPad,
    required this.bottomPad,
    required this.composerController,
    required this.onBack,
    required this.onCloseChat,
    required this.readMoreTap,
    required this.liked,
    required this.likeCount,
    required this.onLikeTap,
    this.initialSheetFraction = 0.4,
    this.maxSheetFraction = 0.5,

    /// When true, skip [ReelBackdropMedia] in the reel strip — parent already paints it.
    this.excludeBackdrop = false,
  });

  final String imageUrl;
  final String? videoUrl;
  final String? videoType;
  final double topPad;
  final double bottomPad;
  final TextEditingController composerController;
  final VoidCallback onBack;

  /// Called after a deliberate swipe-down dismiss (animated sheet off-screen).
  final VoidCallback onCloseChat;
  final TapGestureRecognizer readMoreTap;
  final double initialSheetFraction;
  final double maxSheetFraction;
  final bool excludeBackdrop;
  final bool liked;
  final int likeCount;
  final VoidCallback onLikeTap;

  @override
  State<ChatSplitBody> createState() => _ChatSplitBodyState();
}

class _ChatSplitBodyState extends State<ChatSplitBody>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<double> _extentN;
  final ScrollController _listScroll = ScrollController();
  _LinkedSheetScrollPhysics? _linkedPhysics;
  double? _physicsViewportH;
  double _closePullAccum = 0;
  late final AnimationController _dismissCtrl;
  VoidCallback? _dismissTick;

  /// Pull past min in one gesture before release commits dismiss (~12% screen).
  static const double _closeDistanceFraction = 0.12;

  /// Downward fling at min commits dismiss (logical px/s).
  static const double _closeVelocityThreshold = 700;

  @override
  void initState() {
    super.initState();
    final minS = widget.initialSheetFraction.clamp(0.05, 0.95);
    _extentN = ValueNotifier(minS);
    _dismissCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureLinkedPhysics();
  }

  void _ensureLinkedPhysics() {
    final h = MediaQuery.sizeOf(context).height;
    if (_physicsViewportH == h && _linkedPhysics != null) return;
    _physicsViewportH = h;
    final minS = widget.initialSheetFraction.clamp(0.05, 0.95);
    final maxS = widget.maxSheetFraction.clamp(minS + 0.01, 0.95);
    _linkedPhysics = _LinkedSheetScrollPhysics(
      parent: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      viewportHeight: h,
      minSheet: minS,
      maxSheet: maxS,
      extent: () {
        final a = widget.initialSheetFraction.clamp(0.05, 0.95);
        final b = widget.maxSheetFraction.clamp(a + 0.01, 0.95);
        return _extentN.value.clamp(a, b);
      },
      onExtentDeltaFromScrollPixels: (signedPixels) {
        if (_dismissCtrl.isAnimating) return;
        final a = widget.initialSheetFraction.clamp(0.05, 0.95);
        final b = widget.maxSheetFraction.clamp(a + 0.01, 0.95);
        final hh = _physicsViewportH ?? h;
        final next = (_extentN.value + signedPixels / hh).clamp(a, b);
        if (next != _extentN.value) _extentN.value = next;
        if (next > a + 0.02) _closePullAccum = 0;
      },
      onDragPastMinAtTop: (px) {
        if (_dismissCtrl.isAnimating) return;
        _nudgeClosePullFromScroll(px);
      },
    );
  }

  @override
  void didUpdateWidget(covariant ChatSplitBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSheetFraction != widget.initialSheetFraction ||
        oldWidget.maxSheetFraction != widget.maxSheetFraction) {
      _linkedPhysics = null;
      _physicsViewportH = null;
    }
  }

  @override
  void dispose() {
    if (_dismissTick != null) {
      _dismissCtrl.removeListener(_dismissTick!);
    }
    _dismissCtrl.dispose();
    _extentN.dispose();
    _listScroll.dispose();
    super.dispose();
  }

  void _resetClosePull() {
    _closePullAccum = 0;
  }

  void _nudgeClosePullFromScroll(double downwardPixels) {
    if (downwardPixels <= 0 || !mounted || _dismissCtrl.isAnimating) return;
    final minS = widget.initialSheetFraction.clamp(0.05, 0.95);
    if (_extentN.value > minS + 0.02) {
      _closePullAccum = 0;
      return;
    }
    _closePullAccum += downwardPixels;
  }

  double _closeDistancePx(double viewportH) {
    return (viewportH * _closeDistanceFraction).clamp(100.0, 220.0);
  }

  void _tryCommitDismiss({double? primaryVelocity, required double viewportH}) {
    if (!mounted || _dismissCtrl.isAnimating) return;
    final minS = widget.initialSheetFraction.clamp(0.05, 0.95);
    if (_extentN.value > minS + 0.02) {
      _resetClosePull();
      return;
    }
    final distOk = _closePullAccum >= _closeDistancePx(viewportH);
    // Positive velocity = finger moving down when released.
    final velOk =
        primaryVelocity != null && primaryVelocity > _closeVelocityThreshold;
    if (!distOk && !velOk) {
      _resetClosePull();
      return;
    }
    _resetClosePull();
    _runDismissAnimation();
  }

  void _runDismissAnimation() {
    if (!mounted || _dismissCtrl.isAnimating) return;
    final start = _extentN.value;
    if (start <= 0.001) {
      widget.onCloseChat();
      return;
    }
    _dismissCtrl.duration = const Duration(milliseconds: 340);
    _dismissCtrl.reset();
    final curved = CurvedAnimation(
      parent: _dismissCtrl,
      curve: Curves.easeInCubic,
    );
    void tick() {
      if (!mounted) return;
      _extentN.value = start * (1 - curved.value);
    }

    _dismissTick = tick;
    _dismissCtrl.addListener(tick);
    _dismissCtrl.forward().whenComplete(() {
      if (_dismissTick != null) {
        _dismissCtrl.removeListener(_dismissTick!);
        _dismissTick = null;
      }
      curved.dispose();
      if (mounted) widget.onCloseChat();
    });
  }

  void _applyVerticalDragDy(double dy, double viewportH) {
    if (_dismissCtrl.isAnimating) return;
    final minS = widget.initialSheetFraction.clamp(0.05, 0.95);
    final maxS = widget.maxSheetFraction.clamp(minS + 0.01, 0.95);
    final before = _extentN.value;
    final d = -dy / viewportH;
    final next = (before + d).clamp(minS, maxS);
    if (next != before) {
      _closePullAccum = 0;
      _extentN.value = next;
    } else if (before <= minS + 0.002 && dy > 0) {
      _nudgeClosePullFromScroll(dy);
    }
  }

  void _onVerticalDragEnd(DragEndDetails details, double viewportH) {
    _tryCommitDismiss(
      primaryVelocity: details.primaryVelocity,
      viewportH: viewportH,
    );
    _resetClosePull();
  }

  @override
  Widget build(BuildContext context) {
    _ensureLinkedPhysics();
    final h = MediaQuery.sizeOf(context).height;
    final physics = _linkedPhysics!;

    return ListenableBuilder(
      listenable: _extentN,
      builder: (context, _) {
        final minS = widget.initialSheetFraction.clamp(0.05, 0.95);
        final maxS = widget.maxSheetFraction.clamp(minS + 0.01, 0.95);
        final extent = _extentN.value.clamp(minS, maxS);
        final reelH = h * (1 - extent);
        final sheetH = h * extent;

        return SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: reelH,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: (d) =>
                      _applyVerticalDragDy(d.primaryDelta ?? 0, h),
                  onVerticalDragEnd: (d) => _onVerticalDragEnd(d, h),
                  onVerticalDragCancel: _resetClosePull,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (!widget.excludeBackdrop)
                        ReelBackdropMedia(
                          posterUrl: widget.imageUrl,
                          videoUrl: widget.videoUrl,
                          videoType: widget.videoType,
                        ),
                      const ColoredBox(color: Color(0x22000000)),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: reelH,
                height: sheetH,
                child: Material(
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragUpdate: (d) =>
                            _applyVerticalDragDy(d.primaryDelta ?? 0, h),
                        onVerticalDragEnd: (d) => _onVerticalDragEnd(d, h),
                        onVerticalDragCancel: _resetClosePull,
                        child: SizedBox(
                          height: 28,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: 0.4,
                                minHeight: 4,
                                backgroundColor: AppColors.white,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (n) {
                            if (n is ScrollEndNotification) {
                              _tryCommitDismiss(
                                primaryVelocity: n.dragDetails?.primaryVelocity,
                                viewportH: h,
                              );
                              _resetClosePull();
                            }
                            return false;
                          },
                          child: ChatPanel(
                            scrollController: _listScroll,
                            scrollPhysics: physics,
                            bottomPad: widget.bottomPad,
                            composerController: widget.composerController,
                            readMoreTap: widget.readMoreTap,
                            liked: widget.liked,
                            likeCount: widget.likeCount,
                            onLikeTap: widget.onLikeTap,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: widget.topPad + 8,
                left: 12,
                child: CircleBlurIconButton(
                  onTap: widget.onBack,
                  child: SvgPicture.asset(
                    SvgAssets.backArrow,
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: widget.topPad + 48,
                bottom: sheetH + 8,
                child: Center(
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        color: Colors.black.withValues(alpha: 0.5),
                        child: const Icon(
                          Icons.pause_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Routes vertical scroll into sheet extent while the list is pinned at the
/// top (grow sheet on drag-up) or has room to shrink the sheet (drag-down).
///
/// [ScrollPosition.applyUserOffset]: `setPixels(pixels - physics(..., delta))`.
class _LinkedSheetScrollPhysics extends ScrollPhysics {
  // ignore: prefer_const_constructors_in_immutables — closures + non-const parent.
  _LinkedSheetScrollPhysics({
    required super.parent,
    required this.viewportHeight,
    required this.minSheet,
    required this.maxSheet,
    required this.extent,
    required this.onExtentDeltaFromScrollPixels,
    required this.onDragPastMinAtTop,
  });

  final double viewportHeight;
  final double minSheet;
  final double maxSheet;
  final double Function() extent;

  /// Added to sheet extent: `pixels / viewportHeight` (positive grows sheet).
  final void Function(double signedPixels) onExtentDeltaFromScrollPixels;

  /// Downward scroll delta (px) when the sheet is already at [minSheet].
  final void Function(double downwardPixels) onDragPastMinAtTop;

  @override
  _LinkedSheetScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _LinkedSheetScrollPhysics(
      parent: parent!.applyTo(ancestor),
      viewportHeight: viewportHeight,
      minSheet: minSheet,
      maxSheet: maxSheet,
      extent: extent,
      onExtentDeltaFromScrollPixels: onExtentDeltaFromScrollPixels,
      onDragPastMinAtTop: onDragPastMinAtTop,
    );
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    final e = extent();
    if (e < maxSheet || e > minSheet) return true;
    return parent!.shouldAcceptUserOffset(position);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    assert(offset != 0.0);
    final e = extent();
    final atTop = position.pixels <= position.minScrollExtent + 1.0;

    if (atTop) {
      // Drag up (negative delta) → grow sheet until max.
      if (offset < 0) {
        final avail = -offset;
        final roomPx = (maxSheet - e) * viewportHeight;
        if (roomPx > 1e-3) {
          final intoSheet = avail < roomPx ? avail : roomPx;
          onExtentDeltaFromScrollPixels(intoSheet);
          final remainder = offset + intoSheet;
          if (remainder.abs() < 1e-6) {
            return 0;
          }
          return parent!.applyPhysicsToUserOffset(position, remainder);
        }
      }
      // Drag down (positive delta) → shrink sheet until min.
      else if (offset > 0) {
        final avail = offset;
        final roomPx = (e - minSheet) * viewportHeight;
        if (roomPx > 1e-3) {
          final intoSheet = avail < roomPx ? avail : roomPx;
          onExtentDeltaFromScrollPixels(-intoSheet);
          final remainder = offset - intoSheet;
          if (remainder.abs() < 1e-6) {
            return 0;
          }
          final eAfter = extent();
          if (eAfter <= minSheet + 1e-5) {
            onDragPastMinAtTop(remainder);
            return 0;
          }
          return parent!.applyPhysicsToUserOffset(position, remainder);
        } else {
          onDragPastMinAtTop(avail);
          return 0;
        }
      }
    }

    return parent!.applyPhysicsToUserOffset(position, offset);
  }
}
