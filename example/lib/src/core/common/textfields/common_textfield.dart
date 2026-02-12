import 'package:flutter/material.dart';

import '../../utils/debug/debug_service.dart';


class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final Function(String text) onChanged;
  final Function(String text) validationCheck;
  final String hintText;
  final String labelText;
  final int? maxLines;
  final VoidCallback onSubmit;
  
  const CustomTextfield({
    required this.maxLines,
    required this.onChanged,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.validationCheck,
    super.key, required this.onSubmit,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {

  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:
          (context, constraints) => TextFormField(
            onTapOutside: (event) {
              _focusNode.unfocus();
            },
            focusNode: _focusNode,
            maxLines: widget.maxLines,
            controller: widget.controller,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.center,
            onFieldSubmitted: (value) {
              UIDebugger(). dekhao("onsubmit text field ${widget.controller.text}");
              widget.onSubmit();
            },
            
            scrollController: _scrollController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              
              // floatingLabelBehavior: FloatingLabelBehavior.auto,
              // alignLabelWithHint: false,
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              hintText: widget.hintText,
              label: Text(widget.labelText),
              labelStyle: Theme.of(context).textTheme.titleMedium,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
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
