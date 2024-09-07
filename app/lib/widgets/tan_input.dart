import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TanInputController extends ChangeNotifier
    implements ValueListenable<String> {

  static const int tanLength = 6;
  final List<String> code = List.generate(tanLength, (index) => '');

  /// May return an incomplete tan. See [isComplete].
  @override
  String get value => code.join();

  bool get isComplete => code.every((element) => element.isNotEmpty);

  void updateValue(int index, String value) {
    if (index >= 0 && index < tanLength) {
      code[index] = value;
      notifyListeners();
    }
  }

  void clear() {
    for (int i = 0; i < tanLength; i++) {
      code[i] = '';
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
  static const int tanLength = TanInputController.tanLength;

  final List<FocusNode> _focusNodes =
      List.generate(tanLength, (index) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(tanLength, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      for (int i = 0; i < tanLength; i++) {
        _controllers[i].text = widget.controller.code[i];
      }

      widget.onChanged?.call(widget.controller.value);
    });
  }

  @override
  void dispose() {
    for (var notifier in [..._focusNodes, ..._controllers]) {
      notifier.dispose();
    }
    super.dispose();
  }

  void _handleInputChange(int index, String value) {
    widget.controller.updateValue(index, value);
    if (value.isNotEmpty) {
      if (index + 1 < tanLength) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(tanLength, (index) {
        return SizedBox(
          width: 40,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            onTap: () => _controllers[index].selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controllers[index].text.length),
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
              _handleInputChange(index, value);
            },
          ),
        );
      }),
    );
  }
}
