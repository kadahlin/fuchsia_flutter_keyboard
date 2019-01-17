// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'keyboard.dart';

class ImeKeyboard extends StatelessWidget {

  void _onText(String text) {
    print(text);
  }

  void _onDelete() {
    print("onDelete");
  }

  void _onGo() {
    print("onGo");
  }

  void _onHide() {
    print("onHide");
  }

  @override
  Widget build(BuildContext context) {
    return Keyboard(
        onText: _onText, onDelete: _onDelete, onGo: _onGo, onHide: _onHide);
  }
}
