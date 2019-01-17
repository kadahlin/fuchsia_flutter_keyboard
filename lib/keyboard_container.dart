// Copyright 2018 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'ime_keyboard.dart';
import 'keyboard_model.dart';

//import 'package:lib.app.dart/app.dart';
//import 'package:lib.widgets/application.dart';
//import 'package:lib.widgets/model.dart';

const double _borderWidth = 6.0;
const double _kKeyboardOverlayHeight = _borderWidth + (4 * 44.0);
const double _kKeyboardCornerRadius = 24.0;

/// Defines the UX of the keyboard drawer.
class KeyboardContainer extends StatelessWidget {
  const KeyboardContainer({this.model, this.elevation});

  final KeyboardModel model;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return _buildKeyboard(model);
  }

  Widget _buildKeyboard(KeyboardModel model) {
//    return AnimatedBuilder(
//      animation: model.overlayPositionModel,
//      builder: (BuildContext context, Widget child) {
//        double yShift = lerpDouble(
//          _kKeyboardOverlayHeight,
//          0.0,
//          model.overlayPositionModel.value,
//        );
//        yShift += model.overlayPositionModel.overlayDragModel.offset;
//        yShift = yShift.clamp(0.0, _kKeyboardOverlayHeight);
//        return Offstage(
//          offstage: yShift >= _kKeyboardOverlayHeight,
//          child: Align(
//            alignment: FractionalOffset.bottomCenter,
//            child: Transform(
//              transform: Matrix4.translationValues(
//                0.0,
//                yShift,
//                0.0,
//              ),
//              child: child,
//            ),
//          ),
//        );
//      },
//      child: SizedBox(
//        height: _kKeyboardOverlayHeight,
//        child: Material(
//          borderRadius: const BorderRadius.vertical(top: const Radius.circular(_kKeyboardCornerRadius)),
//          elevation: elevation ?? model.keyboardElevation,
//          child: ImeKeyboard(),
//        ),
//      ),
//    );
    final yShift = 0.0;
    return Offstage(
      offstage: yShift >= _kKeyboardOverlayHeight,
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Transform(
          transform: Matrix4.translationValues(
            0.0,
            yShift,
            0.0,
          ),
          child: SizedBox(
            height: _kKeyboardOverlayHeight,
            child: Material(
              borderRadius: const BorderRadius.vertical(top: const Radius.circular(_kKeyboardCornerRadius)),
              elevation: elevation ?? 0.0, //model.keyboardElevation,
              child: ImeKeyboard(),
            ),
          ),
        ),
      ),
    );
  }
}
