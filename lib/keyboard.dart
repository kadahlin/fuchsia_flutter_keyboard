// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'keys.dart';

const Color _borderColor = const Color(0xFFE8EAED);
const Color _backgroundColor = const Color(0xFFFFFFFF);
const Color _contentColor = const Color(0xFF202124);
const TextStyle _defaultTextStyle = const TextStyle(
  color: _contentColor,
  fontFamily: 'GoogleSans',
  fontSize: 16.0,
);

const int _keyboardLayoutIndexLowerCase = 0;
const int _keyboardLayoutIndexUpperCase = 1;
const int _keyboardLayoutIndexSymbolsOne = 2;
const int _keyboardLayoutIndexSymbolsTwo = 3;

/// Used to calculate inner corner radius of border.
///
/// This is used because a border in Flutter cannot have curved corners if it
/// is not 'uniform', so we use a widget with padding to simulate the border
/// instead.
const double _cornerFactor = 1.4;

const double _specialTextSize = 14.0;

/// Padding used to pad the horizontal sides of the keyboard.
const double _sidePadding = 12.0;

/// Default flex size of most keys on the keyboard.
const int _defaultFlexSize = 2;

/// Small flex size used on the side of specific rows.
const int _smallFlexSize = 1;

/// Flex size used for the spacebar.
const int _spaceFlexSize = 10;

/// Default horizontal alignment for most keys on the keyboard.
const double _defaultAlign = 0.5;

const Map<String, List<String>> _keyMap = {
  'q': ['q', 'Q', '1', '~'],
  'w': ['w', 'W', '2', '•'],
  'e': ['e', 'E', '3', '√'],
  'r': ['r', 'R', '4', 'π'],
  't': ['t', 'T', '5', 'ø'],
  'y': ['y', 'Y', '6', '¶'],
  'u': ['u', 'U', '7', '∆'],
  'i': ['i', 'I', '8', '£'],
  'o': ['o', 'O', '9', '¢'],
  'p': ['p', 'P', '0', '¥'],
  'a': ['a', 'A', '@', 'ˆ'],
  's': ['s', 'S', '#', 'º'],
  'd': ['d', 'D', '\$', '='],
  'f': ['f', 'F', '&', '{'],
  'g': ['g', 'G', '+', '}'],
  'h': ['h', 'H', '(', '\\'],
  'j': ['j', 'J', ')', '%'],
  'k': ['k', 'K', '/', '©'],
  'l': ['l', 'L', '*', '®'],
  'z': ['z', 'Z', '"', '™'],
  'x': ['x', 'X', '\'', 'æ'],
  'c': ['c', 'C', ':', '['],
  'v': ['v', 'V', ';', ']'],
  'b': ['b', 'B', '%', '∑'],
  'n': ['n', 'N', '|', '†'],
  'm': ['m', 'M', '`', 'ß'],
  '!': ['!', '!', '!', 'ƒ'],
  '?': ['?', '?', '?', 'Ω'],
};

/// Displays a keyboard.
class Keyboard extends StatefulWidget {
  /// Called when a key is tapped on the keyboard.
  final OnText onText;

  /// Called when a suggestion is tapped on the keyboard.
  final OnText onSuggestion;

  /// Called when 'Delete' is tapped on the keyboard.
  final VoidCallback onDelete;

  /// Called when 'Go' is tapped on the keyboard.
  final VoidCallback onGo;

  /// Called when 'Hide' is tapped on the keyboard.
  final VoidCallback onHide;

  /// Constructor.
  const Keyboard(
      {Key key,
        this.onText,
        this.onSuggestion,
        this.onDelete,
        this.onGo,
        this.onHide})
      : super(key: key);

  @override
  KeyboardState createState() => KeyboardState();
}

/// Displays the current keyboard for [Keyboard].
///
/// [_keyboards] is the list of available keyboards created while
/// [_currentKeyboard] is the index of the keyboard currently being displayed.
///
class KeyboardState extends State<Keyboard> {
  int _currentKeyboard;
  final Map<int, Widget> _keyboards = {};

  @override
  void initState() {
    super.initState();
    _onSelectKeyboard(_keyboardLayoutIndexLowerCase);
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(
      6.0,
      6.0,
      6.0,
      0.0,
    ),
    decoration: BoxDecoration(
        color: _borderColor,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.0))),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.0 / _cornerFactor)),
        color: _backgroundColor,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: _sidePadding),
          child: _keyboards.containsKey(_currentKeyboard)
              ? _keyboards[_currentKeyboard]
              : Offstage(),
        ),
      ),
    ),
  );

  Widget _buildKeyboard(int keyboard) {
    final widgetMapping = _keyMap.map<String, Widget>((key, value) => MapEntry(
        key,
        (value != null && value.length >= keyboard)
            ? _createTextKey(value.elementAt(keyboard), width: _defaultFlexSize)
            : _createSpacerKey(width: _defaultFlexSize)));

    Widget getTextKey(String key) => widgetMapping.putIfAbsent(
        key, () => _createSpacerKey(width: _defaultFlexSize));

    Widget getLeftShift() {
      switch (keyboard) {
        case _keyboardLayoutIndexSymbolsOne:
          return _changeKeyboardKey(_keyboardLayoutIndexSymbolsTwo);
        case _keyboardLayoutIndexSymbolsTwo:
          return _changeKeyboardKey(_keyboardLayoutIndexSymbolsOne);
        default:
          return _createIconKey(
            Icons.keyboard_capslock,
                () => _onSelectKeyboard(keyboard == _keyboardLayoutIndexUpperCase
                ? _keyboardLayoutIndexLowerCase
                : _keyboardLayoutIndexUpperCase),
          );
      }
    }

    Widget getRightShift() => (keyboard == _keyboardLayoutIndexSymbolsTwo ||
        keyboard == _keyboardLayoutIndexSymbolsOne)
        ? _createSpacerKey(width: _defaultFlexSize)
        : getLeftShift();

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Row(children: [
        getTextKey('q'),
        getTextKey('w'),
        getTextKey('e'),
        getTextKey('r'),
        getTextKey('t'),
        getTextKey('y'),
        getTextKey('u'),
        getTextKey('i'),
        getTextKey('o'),
        getTextKey('p'),
        _createIconKey(Icons.keyboard_backspace, _onDeletePressed),
      ]),
      Row(children: [
        _createSpacerKey(width: _smallFlexSize),
        getTextKey('a'),
        getTextKey('s'),
        getTextKey('d'),
        getTextKey('f'),
        getTextKey('g'),
        getTextKey('h'),
        getTextKey('j'),
        getTextKey('k'),
        getTextKey('l'),
        _createIconKey(Icons.check, _onGoPressed, type: IconKeyType.bordered),
        _createSpacerKey(width: _smallFlexSize),
      ]),
      Row(children: [
        getLeftShift(),
        getTextKey('z'),
        getTextKey('x'),
        getTextKey('c'),
        getTextKey('v'),
        getTextKey('b'),
        getTextKey('n'),
        getTextKey('m'),
        getTextKey('!'),
        getTextKey('?'),
        getRightShift(),
      ]),
      Row(children: [
        _changeKeyboardKey(() {
          return (keyboard == _keyboardLayoutIndexSymbolsOne ||
              keyboard == _keyboardLayoutIndexSymbolsTwo)
              ? _keyboardLayoutIndexLowerCase
              : _keyboardLayoutIndexSymbolsOne;
        }()),
        _createTextKey('_'),
        _createTextKey('-'),
        _createSpacebarKey(width: _spaceFlexSize),
        _createTextKey(','),
        _createTextKey('.'),
        _createIconKey(
          Icons.keyboard_arrow_down,
          _onHidePressed,
          type: IconKeyType.dark,
        ),
      ]),
    ]);
  }

  Widget _changeKeyboardKey(int changeKeyboardTo) {
    String getText() {
      switch (changeKeyboardTo) {
        case _keyboardLayoutIndexSymbolsOne:
          return '123';
        case _keyboardLayoutIndexSymbolsTwo:
          return '=\\<';
        default:
          return 'ABC';
      }
    }

    return _createTextKey(
      getText(),
      isActionText: true,
      action: () => _onSelectKeyboard(changeKeyboardTo),
    );
  }

  Widget _createSpacerKey({@required int width}) => SpacerKey(flex: width);

  Widget _createTextKey(
      String text, {
        int width = _defaultFlexSize,
        VoidCallback action,
        double align = _defaultAlign,
        bool isActionText = false,
      }) {
    assert(!isActionText || action != null,
    'If isActionText == true, an action must be set.');
    return TextKey(
      text,
      style: isActionText
          ? _defaultTextStyle.copyWith(
          fontSize: _specialTextSize, fontWeight: FontWeight.bold)
          : _defaultTextStyle,
      height: 44.0,
      horizontalAlign: align,
      verticalAlign: _defaultAlign,
      flex: width,
      onText: isActionText ? (_) => action() : _onText,
    );
  }

  Widget _createIconKey(
      IconData iconData,
      VoidCallback action, {
        int width = _defaultFlexSize,
        IconKeyType type = IconKeyType.normal,
      }) {
    return IconKey(
      iconData: iconData,
      onKeyPressed: action,
      height: 44.0,
      iconColor: type == IconKeyType.dark ? _backgroundColor : _contentColor,
      accentColor: _contentColor,
      flex: width,
      type: type,
    );
  }

  Widget _createSpacebarKey({@required int width}) => SpaceBarKey(
    accentColor: _contentColor,
    flex: width,
    height: 44.0,
    onTap: _onSpacePressed,
  );

  void _onSelectKeyboard(int keyboard) {
    if (!_keyboards.containsKey(keyboard))
      _keyboards[keyboard] = _buildKeyboard(keyboard);
    setState(() => _currentKeyboard = keyboard);
  }

  void _onText(String text) => widget.onText?.call(text);

  void _onSpacePressed() => _onText(' ');

  void _onGoPressed() => widget.onGo?.call();

  void _onDeletePressed() => widget.onDelete?.call();

  void _onHidePressed() => widget.onHide?.call();
}
