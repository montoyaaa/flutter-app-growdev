import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BuildInput extends StatefulWidget {
  final FloatingActionButtonLocation? fabLocation;
  final NotchedShape? shape;
  final String? label;
  final String? Function(String?)? validator; // <=== (String?)?
  final void Function(String?)? onSaved;
  final IconData? icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final obscureText;

  const BuildInput({
    Key? key,
    this.fabLocation,
    this.shape,
    this.label,
    this.validator,
    this.onSaved,
    this.icon,
    this.controller,
    this.keyboardType,
    this.formatters,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _BuildInput createState() => _BuildInput();
}

class _BuildInput extends State<BuildInput> {
  void initState() {
    super.initState();
  }

  var showPass = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText && !showPass,
      validator: widget.validator,
      onSaved: widget.onSaved,
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
        fillColor: Colors.blueGrey[600],
        filled: true,
        labelText: widget.label,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  showPass ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    showPass = !showPass;
                  });
                },
              )
            : Icon(
                widget.icon,
                color: Colors.black54,
              ),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      cursorWidth: 3,
      cursorRadius: Radius.circular(10),
      keyboardType: widget.keyboardType ?? TextInputType.text,
      inputFormatters: widget.formatters,
    );
  }
}
