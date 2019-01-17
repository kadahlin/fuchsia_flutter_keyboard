// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

abstract class _KeyboardKey extends StatelessWidget {
  const _KeyboardKey({
    @required this.height,
    @required this.onTap,
    this.onLongPress,
    this.flex = 2,
    Key key,
  }) : super(key: key);

  /// The size of the key relative to its siblings.
  final int flex;

  /// The height of the key.
  final double height;

  /// Called when the key is pressed.
  final Function onTap;

  /// Called when the key is long-pressed.
  final VoidCallback onLongPress;
}

/// Called when a key is pressed.
typedef OnText = void Function(String text);

/// A spacer that is inserted into the keyboard to provide empty space
/// between other keys in the keyboard.
///
/// The [SpacerKey] is expected to have a [Row] as a parent.
///
/// Note: No state is required but necessary in order to subclass [_KeyboardKey].
class SpacerKey extends _KeyboardKey {
  const SpacerKey({
    GlobalKey key,
    int flex,
  }) : super(key: key, height: 0.0, flex: flex, onTap: null);

  @override
  Widget build(BuildContext context) => Spacer(flex: flex, key: key);
}

/// A key that is represented by a string.
///
/// The [TextKey] is expected to have a [Row] as a parent and an ancestor
/// [Material] widget
class TextKey extends _KeyboardKey {
  const TextKey(
      this.text, {
        @required double height,
        GlobalKey key,
        OnText onText,
        this.style,
        this.verticalAlign = 0.5,
        this.horizontalAlign = 0.5,
        int flex,
      }) : super(key: key, height: height, flex: flex, onTap: onText);

  /// The text to display.
  final String text;

  /// The style of the text.
  final TextStyle style;

  /// The vertical alignment the text should have within its container.
  final double verticalAlign;

  /// The horizontal alignment the text should have within its container.
  final double horizontalAlign;

  @override
  Widget build(BuildContext context) {
    debugCheckHasMaterial(context);
    _debugCheckHasRow(context);
    return Expanded(
      flex: flex,
      child: InkWell(
        child: Container(
          height: height,
          child: Align(
            alignment: FractionalOffset(horizontalAlign, verticalAlign),
            child: Text(text, style: style),
          ),
        ),
        onTap: () => onTap?.call(text),
        onLongPress: onLongPress,
      ),
    );
  }
}

enum IconKeyType {
  normal,
  bordered,
  dark,
}

/// A key that is represented by an icon.
///
/// The [IconKey] is expected to have a [Row] as a parent and an ancestor
/// [Material] widget
class IconKey extends _KeyboardKey {
  const IconKey({
    @required this.iconData,
    @required this.iconColor,
    @required double height,
    this.type = IconKeyType.normal,
    this.accentColor = Colors.transparent,
    VoidCallback onKeyPressed,
    int flex,
    Key key,
  }) : super(height: height, flex: flex, key: key, onTap: onKeyPressed);

  static const double _padding = 4.0;

  static const double _borderWidth = 2.0;

  /// The [IconData] of the key
  final IconData iconData;

  final IconKeyType type;

  /// The color filter to apply to the icon in the key.
  final Color iconColor;

  /// The color filter to the background or border if [type] is
  /// not [IconKeyType.normal].
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    debugCheckHasMaterial(context);
    _debugCheckHasRow(context);

    final shape = CircleBorder(
        side: type == IconKeyType.bordered
            ? BorderSide(color: accentColor, width: _borderWidth)
            : BorderSide.none);
    final backgroundColor =
    type == IconKeyType.dark ? accentColor : Colors.transparent;
    final padding = type == IconKeyType.dark ? _padding : 0.0;

    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.all(padding),
        height: height,
        child: Container(
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: shape,
          ),
          child: InkWell(
            customBorder: type == IconKeyType.normal ? null : shape,
            child: Icon(iconData, color: iconColor),
            onTap: onTap ?? () {},
            onLongPress: onLongPress,
          ),
        ),
      ),
    );
  }
}

/// A key that is representative of the space bar.
///
/// The [SpaceBarKey] is expected to have a [Row] as a parent and an ancestor
/// [Material] widget
class SpaceBarKey extends _KeyboardKey {
  const SpaceBarKey({
    @required this.accentColor,
    @required double height,
    VoidCallback onTap,
    int flex,
    Key key,
  }) : super(key: key, height: height, flex: flex, onTap: onTap);

  /// The color filter to apply to the icon in the key.
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    debugCheckHasMaterial(context);
    _debugCheckHasRow(context);
    return Expanded(
      flex: flex,
      child: InkWell(
        child: Container(
          height: height,
          child: FractionallySizedBox(
            widthFactor: 0.9,
            heightFactor: 0.2,
            child: Container(
              decoration: ShapeDecoration(
                color: accentColor,
                shape: StadiumBorder(side: BorderSide.none),
              ),
            ),
          ),
        ),
        onTap: onTap ?? () {},
        onLongPress: onLongPress,
      ),
    );
  }
}

bool _debugCheckHasRow(BuildContext context) {
  assert(
  context.widget is Row || context.ancestorWidgetOfExactType(Row) != null,
  '${context.widget.runtimeType} widgets require a Row widget ancestor.');
  return true;
}
