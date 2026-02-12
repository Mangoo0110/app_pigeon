import 'package:flutter/material.dart';


class DescriptionTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final Function (String text) onChanged;
  final String hintText;
  final String? labelText;
  final int? maxLines;
  final bool? alignLabelWithHint;
  final FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.never;
  DescriptionTextfield({
    required this.maxLines,
    required this.onChanged,
    this.controller,
    required this.hintText,
    this.labelText,
    this.alignLabelWithHint,
    super.key
    });
  final FocusNode _focusNode = FocusNode(); 

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TextFormField(
        onTapOutside: (event){
          _focusNode.unfocus();
        },
        focusNode: _focusNode,
        maxLines: maxLines,
        controller: controller,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          floatingLabelBehavior: floatingLabelBehavior,
          alignLabelWithHint: alignLabelWithHint,
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          hintText: hintText,
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.titleMedium,
          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
              ),
              borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          onChanged(value);
        },
      ),
    );
  }
}