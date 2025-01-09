import 'package:flutter/material.dart';

class FormContainer extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String hintText;
  final String labelText;

  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;
  final OutlineInputBorder? border;

  const FormContainer(
      {Key? key,
      this.controller,
      this.fieldKey,
      this.isPasswordField = false,
      required this.hintText,
      required this.labelText,
      this.onSaved,
      this.validator,
      this.onFieldSubmitted,
      this.inputType = TextInputType.text,
      this.border})
      : super(key: key);

  @override
  State<FormContainer> createState() => _FormContainerState();
}

class _FormContainerState extends State<FormContainer> {
  bool _obscureText = true; // Only used for password visibility toggle

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        key: widget.fieldKey,
        controller: widget.controller,
        obscureText: widget.isPasswordField! ? _obscureText : false,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.hintText,
          labelText: widget.labelText,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: widget.isPasswordField == true
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                )
              : null,
        ),
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        keyboardType: widget.inputType,
      ),
    );
  }
}
