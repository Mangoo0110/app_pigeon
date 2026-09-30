import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class NameTextfield extends StatefulWidget {
  final bool readOnly;
  final String initialText;
  final Widget? prefiexIcon;
  final Widget? suffixIcon;
  final Function(String text) onChanged;
  final Color? fillColor;
  final String? Function(String text) validationCheck;
  final String hintText;
  final String labelText;
  final int? maxLines;
  final bool autofocus;
  const NameTextfield({
    this.readOnly = false,
    this.maxLines = 1,
    this.prefiexIcon,
    this.suffixIcon,
    required this.onChanged,
    this.hintText = "",
    this.labelText = "Name",
    this.initialText = "",
    required this.validationCheck,
    this.fillColor,
    this.autofocus = false,
    super.key,
  });

  @override
  State<NameTextfield> createState() => _NameTextfieldState();
}

class _NameTextfieldState extends State<NameTextfield> {
  final TextEditingController _controller = TextEditingController();
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState> ();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    _controller.text = widget.initialText;
    super.initState();
    if (widget.autofocus) {
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    debugPrint("Disposing name textfield");
    _focusNode.unfocus();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TextFormField(
        cursorColor: AppColors.light().primaryColor,
        onTapOutside: (event) {
          _focusNode.unfocus();
        },
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        controller: _controller,
        decoration: InputDecoration(
          fillColor: widget.fillColor,
          prefixIcon: widget.prefiexIcon,
          suffixIcon: widget.suffixIcon,
          hintText: widget.hintText,
          hintMaxLines: 1,
          labelText: widget.labelText,
        ),
        onChanged: (value) {
          widget.onChanged(value);
        },
        validator: (value) {
          return widget.validationCheck(value!);
        },
      ),
    );
  }
}
