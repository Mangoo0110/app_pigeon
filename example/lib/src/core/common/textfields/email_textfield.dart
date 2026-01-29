
import 'package:flutter/material.dart';

import '../../constants/assets.dart';
import 'textfield_prefix_icon.dart';



class EmailTextfield extends StatefulWidget {
  final String initialText;
  final Function (String text) onChanged;
  final String? Function (String text) validationCheck;
  final String hintText;
  final String labelText;
  final int? maxLines;
  final bool showPrefixIcon;
  const EmailTextfield({
    this.maxLines = 1,
    required this.onChanged,
    this.hintText = "example@gmail.com",
    this.labelText = "Email",
    this.initialText = "",
    required this.validationCheck,
    this.showPrefixIcon = true,
    super.key
    });

  @override
  State<EmailTextfield> createState() => _EmailTextfieldState();
}

class _EmailTextfieldState extends State<EmailTextfield> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState> ();

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
      builder: (context, constraints) => Form(
        key: _formKey,
        child: TextFormField(
          onTap: () {
            _focusNode.requestFocus();
          },
          onTapOutside: (event){
            _focusNode.unfocus();
          },
          focusNode: _focusNode,
          maxLines: widget.maxLines,
          controller: _controller,
          style: Theme.of(context).textTheme.bodyMedium,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            errorMaxLines: 1,
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            hintText: widget.hintText,
            labelText: widget.labelText,
            prefixIcon: widget.showPrefixIcon ? TextfieldPrefixIcon(assetName: Assets.email) : null,
          ),
          
          onChanged: (value) {
            widget.onChanged(value);
            _formKey.currentState!.validate();
          },
          validator: (value) {
            return widget.validationCheck(value!);
          },
        ),
      ),
    );
  }
}