import "package:flutter/material.dart";

extension ContextX on BuildContext {
  ///The parts of the display that
  ///are partially obscured by system UI, typically by
  ///the hardware display "notches" or the system status bar.

  ///If you consumed this padding
  /// (e.g. by building a widget that envelops or accounts for this padding in
  /// its layout in such a way that children are no
  /// longer exposed to this padding),
  ///  you should remove this padding for
  /// subsequent descendants in the widget tree
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// width of device
  double get getDeviceWidth => MediaQuery.of(this).size.width;

  bool get isIpad => MediaQuery.of(this).size.width >= 600;

  /// Responsive device breakpoints
  bool get isSmallPhone => MediaQuery.of(this).size.width <= 375;
  bool get isPhone => MediaQuery.of(this).size.width < 600;
  bool get isTablet =>
      MediaQuery.of(this).size.width >= 600 &&
      MediaQuery.of(this).size.width < 900;
  bool get isDesktop => MediaQuery.of(this).size.width >= 900;

  /// Get responsive grid cross axis count based on screen width
  int getResponsiveGridCount({int maxColumns = 4}) {
    final width = MediaQuery.of(this).size.width;
    if (width < 375) return 2; // Small phones
    if (width < 600) return 2; // Regular phones
    if (width < 900) return 3; // Tablets
    return maxColumns; // Large tablets/Desktop
  }

  /// Get responsive aspect ratio for grid items
  double getResponsiveAspectRatio({
    double smallPhoneRatio = 0.7,
    double phoneRatio = 0.7,
    double tabletRatio = 0.85,
    double desktopRatio = 1.0,
  }) {
    final width = MediaQuery.of(this).size.width;
    if (width <= 375) return smallPhoneRatio; // Small phones
    if (width < 600) return phoneRatio; // Phones
    if (width < 900) return tabletRatio; // Tablets
    return desktopRatio; // Desktop/Large tablets
  }

  /// Get responsive height based on screen size
  double getResponsiveHeight({
    double? smallPhoneHeight,
    required double phoneHeight,
    double? tabletHeight,
    double? desktopHeight,
  }) {
    final width = MediaQuery.of(this).size.width;
    if (width <= 375) return smallPhoneHeight ?? (phoneHeight * 0.7);
    if (width < 600) return phoneHeight;
    if (width < 900) return tabletHeight ?? (phoneHeight * 1.3);
    return desktopHeight ?? (phoneHeight * 1.5);
  }

  /// width with after safe area padding removal
  double get getDeviceWidthWithoutNotchPadding =>
      MediaQuery.of(this).size.width - padding.left - padding.right;

  /// height of device
  double get getDeviceHeight => MediaQuery.of(this).size.height;

  /// Empty state image or svg height
  double get emptyStateHeight => getDeviceHeight / 4;

  /// Empty state image or svg height for bottomsheet
  double get emptyStateBottomSheetHeight => emptyStateHeight / 2;

  /// height with after safe area padding removal
  double get getDeviceHeightWithoutNotchPadding =>
      MediaQuery.of(this).size.width - padding.top - padding.bottom;

  /// height with after safe area padding removal
  double get getDeviceBottomPadding => MediaQuery.of(this).viewInsets.bottom;

  /// width of device
  bool isDeviceWidthGreaterThan(double size) =>
      MediaQuery.of(this).size.width > size;

  /// height of device
  bool isDeviceHeightGreaterThan(double size) =>
      MediaQuery.of(this).size.height > size;

  /// width of device - without the values of the parts of the device
  /// that is obstructed by system UI
  double get getDeviceWidthNoPadding =>
      MediaQuery.of(this).size.width - padding.horizontal;

  /// height of device - without the values of the parts of the device
  /// that is obstructed by system UI
  double get getDeviceHeightNoPadding =>
      MediaQuery.of(this).size.height - padding.vertical;

  /// this is an extention to help get device width
  /// passing the argument [subtract] reduce the width
  /// by that value.
  double deviceWidth({double? subtract}) {
    double width = MediaQuery.of(this).size.width;
    // reduce the width by the value user passed
    if (subtract != null) {
      width -= subtract;
    }
    return width;
  }

  /// this is an extention to help get device height
  /// passing the argument ``subtract`` reduce the width
  /// by that value.
  double deviceHeight({double? subtract}) {
    double height = MediaQuery.of(this).size.height;
    // reduce the width by the value user passed
    if (subtract != null) {
      height -= subtract;
    }
    return height;
  }

  /// this is an extention to help get device height
  /// in percentage
  double deviceHeightPercentage({required double percentage}) {
    final double height = MediaQuery.of(this).size.height;

    // calculate the height percentage
    return height * (percentage / 100);
  }

  /// this is an extention to help get device width
  /// in percentage
  double deviceWidthPercentage({required double percentage}) {
    final double width = MediaQuery.of(this).size.width;

    // calculate the width percentage
    return width * (percentage / 100);
  }
}
