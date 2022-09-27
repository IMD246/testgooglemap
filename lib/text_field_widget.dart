import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    Key? key,
    required this.onSubmitted,
    required this.onChanged,
    required this.onDeleted,
    this.padding = 8,
    this.boxDecorationColor = Colors.white,
    this.borderRadius = 8,
    this.hintText = "Tìm kiếm",
    this.focusColorInput = Colors.red,
    this.suffixIconColor = Colors.black,
    this.autocorrect = false,
    this.enableSuggestions = false,
    this.borderRadiusBoxDecoration = 8.0,
    this.textField = "",
    this.isShowSearchButton = true,
    this.textInputAction = TextInputAction.search,
    this.textInputType = TextInputType.text,
    this.maxLength,
    this.labelText,
    this.enableRTLHintText = false,
    this.cursorColor = Colors.blue,
    this.enalbleRTLText = false,
    this.errorText,
  }) : super(key: key);
  final Function(String)? onSubmitted;
  final Function(String) onChanged;
  final Function() onDeleted;
  final double padding;
  final Color boxDecorationColor;
  final Color focusColorInput;
  final double borderRadius;
  final String hintText;
  final Color suffixIconColor;
  final bool enableSuggestions;
  final bool autocorrect;
  final double borderRadiusBoxDecoration;
  final String textField;
  final bool isShowSearchButton;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final int? maxLength;
  final String? labelText;
  final bool enableRTLHintText;
  final Color cursorColor;
  final bool enalbleRTLText;
  final String? errorText;
  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController.text = widget.textField;
    textEditingController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.padding),
        child: Container(
          decoration: BoxDecoration(
            color: widget.boxDecorationColor,
            borderRadius: BorderRadius.circular(
              widget.borderRadiusBoxDecoration,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              controller: textEditingController,
              textAlign: TextAlign.start,
              textInputAction: widget.textInputAction,
              enableSuggestions: widget.enableSuggestions,
              autocorrect: widget.autocorrect,
              keyboardType: widget.textInputType,
              maxLength: widget.maxLength,
              textDirection: widget.enalbleRTLText
                  ? ui.TextDirection.rtl
                  : ui.TextDirection.ltr,
              style: const TextStyle(
                decoration: TextDecoration.none,
              ),
              onSubmitted: widget.onSubmitted,
              onChanged: (value) {
                widget.onChanged(value);
              },
              cursorColor: widget.cursorColor,
              decoration: InputDecoration(
                focusColor: widget.focusColorInput,
                hintText: widget.hintText,
                errorText: widget.errorText,
                labelText: widget.labelText,
                labelStyle: const TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.red,
                ),
                hintTextDirection: widget.enableRTLHintText
                    ? ui.TextDirection.rtl
                    : ui.TextDirection.ltr,
                suffixIcon: textEditingController.text.isEmpty
                    ? Visibility(
                        visible: widget.isShowSearchButton,
                        child: Icon(
                          Icons.search,
                          color: widget.suffixIconColor,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          widget.onDeleted();
                          setState(() {
                            textEditingController.clear();
                          });
                        },
                        icon: const Icon(Icons.clear),
                        color: widget.suffixIconColor,
                      ),
                focusedErrorBorder: InputBorder.none,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
