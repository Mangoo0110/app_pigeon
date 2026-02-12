import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumTextfield extends StatefulWidget {
  final String initialText;
  final Function (String text) onChanged;
  final Function (String text) validationCheck;
  final VoidCallback onTap;
  final String hintText;
  final String labelText;
  final int? maxLines;
  final bool onlyInteger;
  final RegExp? numRegExp;
  final IconData? prefiexIcon;
  final Widget? suffixWidget;
  const NumTextfield({
    this.maxLines = 1,
    required this.onChanged,
    required this.initialText,
    this.hintText = '',
    this.labelText = '',
    required this.validationCheck,
    required this.onlyInteger,
    this.numRegExp,
    this.prefiexIcon,
    super.key, required this.onTap, this.suffixWidget
    });

  @override
  State<NumTextfield> createState() => _NumTextfieldState();
}

class _NumTextfieldState extends State<NumTextfield> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    _controller.text = widget.initialText;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TextFormField(
        onTap: () {
          _focusNode.requestFocus();

          setState(() {
            
          });
        },
        onTapOutside: (event){
          _focusNode.unfocus();
          setState(() {
            
          });
        },
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        controller: _controller,
        showCursor: _focusNode.hasFocus,
        decoration: InputDecoration(
          suffixIconConstraints: BoxConstraints(
            maxHeight: 30,
            maxWidth: constraints.maxWidth * 0.2,
          ),
          suffix: widget.suffixWidget,
          prefixIcon: widget.prefiexIcon == null ? null : Icon(widget.prefiexIcon),
          hintText: widget.hintText,
          labelText: widget.labelText,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: !widget.onlyInteger),
        inputFormatters: [
          if(widget.numRegExp != null) FilteringTextInputFormatter.allow(widget.numRegExp!),
        ],
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