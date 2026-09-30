import 'package:flutter/material.dart';

class UnderlineTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String text) onChanged;
  final Function(String text) validationCheck;
  final String hintText;
  final String labelText;
  final int? maxLines;
  final Widget? prefiexIcon;
  const UnderlineTextfield({
    this.maxLines = 1,
    required this.onChanged,
    this.controller,
    required this.hintText,
    required this.labelText,
    required this.validationCheck,
    this.prefiexIcon,
    super.key,
  });

  @override
  State<UnderlineTextfield> createState() => _UnderlineTextfieldState();
}

class _UnderlineTextfieldState extends State<UnderlineTextfield> {
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TextFormField(
        onTapOutside: (event) {
          _focusNode.unfocus();
        },
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        controller: widget.controller,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          prefixIcon: widget.prefiexIcon,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          alignLabelWithHint: false,
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          hintText: widget.hintText,
          //label: Text(labelText),
          //labelStyle: AppTextStyle().normalSize(context: context),
          hintStyle: const TextStyle(color: Colors.grey),
          // border: InputBorder.none,
          // focusedBorder: InputBorder.none,
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
