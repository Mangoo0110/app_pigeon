
import 'package:example/src/core/utils/extensions/textstyle_ext.dart';
import 'package:flutter/material.dart';
class NoBorderTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final Function (String text) onChanged;
  final Function (String text) validationCheck;
  final String hintText;
  final String labelText;
  final int? maxLines;
  final Widget? prefiexIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  const NoBorderTextfield({
    this.maxLines = 1,
    required this.onChanged,
    this.controller,
    required this.hintText,
    required this.labelText,
    required this.validationCheck,
    this.prefiexIcon,
    this.suffixIcon,
    this.readOnly = false,
    super.key, 
    });

  @override
  State<NoBorderTextfield> createState() => _NoBorderTextfieldState();
}

class _NoBorderTextfieldState extends State<NoBorderTextfield> {
  final FocusNode _focusNode = FocusNode(); 
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TextFormField(
        onTapOutside: (event){
          _focusNode.unfocus();
        },
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        controller: widget.controller,
        style: TextStyle().regular,
        
        decoration: InputDecoration(
          
          prefixIcon: widget.prefiexIcon,
          suffixIcon: widget.suffixIcon,
          contentPadding: EdgeInsets.symmetric(vertical: 6),
          alignLabelWithHint: false,
          hintText: widget.hintText,
          //label: Text(labelText),
          //labelStyle: AppTextStyle().normalSize(context: context),
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
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