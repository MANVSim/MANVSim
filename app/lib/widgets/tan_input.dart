import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TanInputController extends ChangeNotifier {
  static const int TAN_LENGTH = 6;
  final List<String> _code = List.generate(TAN_LENGTH, (index) => '');

  String get tan {
    if (_code.every((element) => element.isNotEmpty)) {
      return _code.join();
    } else {
      return "";
    }
  }

  String get incompleteTan => _code.join();

  void updateValue(int index, String value) {
    if (index < TAN_LENGTH) {
      _code[index] = value;
      notifyListeners();
    }
  }

  void clear() {
    for (int i = 0; i < TAN_LENGTH; i++) {
      _code[i] = '';
    }
    notifyListeners();
  }
}

class TanInputField extends StatefulWidget {
  final TanInputController controller;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;

  const TanInputField({
    super.key,
    required this.controller,
    this.decoration,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => TanInputFieldState();
}

class TanInputFieldState extends State<TanInputField> {
  static const int TAN_LENGTH = 6;

  final List<FocusNode> _focusNodes = List.generate(TAN_LENGTH, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(widget.controller.incompleteTan);
      }
    });
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }

    for (var controller in _controllers) {
      controller.dispose();
    }

    widget.controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(TAN_LENGTH, (index) {
        return SizedBox(
          width: 40,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              TextInputFormatter.withFunction((oldValue, newValue) {
                return newValue.copyWith(
                  text: newValue.text.toUpperCase(),
                  selection: newValue.selection,
                );
              }),
              FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z]')),
            ],
            decoration: widget.decoration?.copyWith(
              border: widget.decoration?.border ?? const OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                widget.controller.updateValue(index, value);
                if (index + 1 < TAN_LENGTH) {
                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                } else {
                  FocusScope.of(context).unfocus();
                }
              }
            },
          ),
        );
      }),
    );
  }
}