// Copyright 2018 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//import 'package:fidl_fuchsia_cobalt/fidl.dart';
//import 'package:topaz.lib.keyboard.dart/keyboard_display.dart';
//import 'package:topaz.lib.shell/models/overlay_position_model.dart';

//export 'package:topaz.lib.keyboard.dart/keyboard_display.dart'
//    show KeyboardDisplay;

/// Handles connecting to ImeVisibilityService and showing/hiding the keyboard.
class KeyboardModel {

  /// The elevation at which the keyboard overlay is displayed.
  double keyboardElevation = 0.0;

//  KeyboardModel(
//    this._keyboardDisplay, {
//    this.keyboardElevation = 0.0,
//  })  : assert(_keyboardDisplay != null);

  /// Returns whether the keyboard is visible or hidden.
//  bool get keyboardVisible => _keyboardDisplay.keyboardVisible;
  bool get keyboardVisible => true;

  /// Shows or hides the keyboard.
//  set keyboardVisible(bool visible) =>
//      _keyboardDisplay.keyboardVisible = visible;

  set keyboardVisible(bool visible) {

  }
}
