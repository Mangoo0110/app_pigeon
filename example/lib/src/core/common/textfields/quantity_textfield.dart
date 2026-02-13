import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function (String text) onChanged;
  final Function (String text) validationCheck;
  final String hintText;
  final String labelText;
  final int? maxLines;
  final bool onlyInteger;
  final RegExp numRegExp;
  const QuantityTextField({
    required this.maxLines,
    required this.onChanged,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.validationCheck,
    required this.onlyInteger,
    required this.numRegExp,
    super.key
    });

  @override
  State<QuantityTextField> createState() => _QuantityTextFieldState();
}

class _QuantityTextFieldState extends State<QuantityTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) => TextFormField(
        //autofocus: true,
        onTap: () {
          _focusNode.requestFocus();
          setState(() {
            
          });
        },
        onTapOutside: (event){
          _focusNode.unfocus();
          setState(() {
            if(widget.controller.text == '') {
              widget.controller.text = '0';
            }
          });
        },        
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        controller: widget.controller,
        showCursor: _focusNode.hasFocus,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          hintText: widget.hintText,
          label: Text(widget.labelText),
          labelStyle: Theme.of(context).textTheme.titleMedium,
          hintStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black38,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          )
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: !widget.onlyInteger),
        inputFormatters: [
          FilteringTextInputFormatter.allow(widget.numRegExp),
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