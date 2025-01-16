library secure_pin_entry;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecurePinEntry extends StatefulWidget {
  const SecurePinEntry({
    super.key,
    required this.length,
    required this.onComplete,
    this.width,
    this.obscureText = true,
    this.textStyle = const TextStyle(fontSize: 20),
    this.cursorColor = Colors.black,
    this.fillColor = Colors.transparent,
    this.showOutlineBorder = true,
    this.showInputBorder = true,
    this.borderColor = Colors.grey,
    this.borderFocusColor = Colors.grey,
    this.padding,
    this.borderRadius,
    this.hintText,
    this.hintStyle,
  });

  final double? width;
  final int length; // Number of PIN code fields
  final Function(String) onComplete; // Callback function when PIN entry is completed
  final bool obscureText; // Whether to obscure the PIN code
  final TextStyle textStyle; // Text style for PIN code fields
  final Color cursorColor; // Cursor color for PIN code fields
  final Color fillColor; // Fill color for PIN code fields
  final bool showInputBorder;
  final bool showOutlineBorder;
  final Color borderColor; // Border color for PIN code fields
  final Color borderFocusColor; // Border color for PIN code fields
  final EdgeInsets? padding;
  final double? borderRadius;
  final String? hintText; // Placeholder text for each PIN field
  final TextStyle? hintStyle; // Text style for the placeholder text

  @override
  SecurePinEntryState createState() => SecurePinEntryState();
}

class SecurePinEntryState extends State<SecurePinEntry> {
  late List<TextEditingController> controllers;
  late List<FocusNode> textFieldFocusNodes;
  late List<FocusNode> keyboardListenerFocusNodes;
  late List<bool> isFieldFocused; // List to keep track of field focus states

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.length, (index) => TextEditingController());
    textFieldFocusNodes = List.generate(widget.length, (index) => FocusNode());
    keyboardListenerFocusNodes = List.generate(widget.length, (index) => FocusNode());
    isFieldFocused = List.generate(widget.length, (index) => false);

    // Add listeners to focus nodes
    for (int i = 0; i < widget.length; i++) {
      textFieldFocusNodes[i].addListener(() {
        setState(() {
          isFieldFocused[i] = textFieldFocusNodes[i].hasFocus;
        });
      });
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in textFieldFocusNodes) {
      node.dispose();
    }
    for (var node in keyboardListenerFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void submitPin() {
    String pin = controllers.map((controller) => controller.text).join();
    widget.onComplete(pin); // Callback to parent widget with PIN value
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.length,
            (index) => SizedBox(
              width: widget.width ?? 50,
              child: KeyboardListener(
                focusNode: keyboardListenerFocusNodes[index],
                onKeyEvent: (KeyEvent event) {
                  if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
                    if (controllers[index].text.isEmpty && index > 0) {
                      textFieldFocusNodes[index - 1].requestFocus();
                      controllers[index - 1].clear();
                    }
                  }
                },
                child: TextField(
                  controller: controllers[index],
                  focusNode: textFieldFocusNodes[index],
                  maxLength: 1,
                  obscureText: widget.obscureText,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                    filled: true,
                    fillColor: widget.fillColor,
                    hintText: isFieldFocused[index] ? '' : widget.hintText,
                    hintStyle: widget.hintStyle,
                    focusedBorder: widget.showOutlineBorder
                        ? OutlineInputBorder(
                            borderSide: BorderSide(color: widget.borderFocusColor),
                            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                          )
                        : widget.showInputBorder
                            ? UnderlineInputBorder(
                                borderSide: BorderSide(color: widget.borderFocusColor),
                              )
                            : InputBorder.none,
                    enabledBorder: widget.showOutlineBorder
                        ? OutlineInputBorder(
                            borderSide: BorderSide(color: widget.borderColor),
                            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                          )
                        : widget.showInputBorder
                            ? UnderlineInputBorder(
                                borderSide: BorderSide(color: widget.borderColor),
                              )
                            : InputBorder.none,
                  ),
                  style: widget.textStyle,
                  cursorColor: widget.cursorColor,
                  onChanged: (String value) {
                    if (value.isNotEmpty && index < widget.length - 1) {
                      textFieldFocusNodes[index + 1].requestFocus();
                    }
                    if (index == widget.length - 1 && value.isNotEmpty) {
                      submitPin();
                    }
                  },
                ),
              ),
            ),
          ).map((e) => Padding(padding: widget.padding ?? const EdgeInsets.all(10), child: e)).toList(),
        ),
      ],
    );
  }
}
