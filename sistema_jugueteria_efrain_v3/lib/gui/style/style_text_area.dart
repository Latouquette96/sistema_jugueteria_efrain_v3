import 'package:flutter/material.dart';

class StyleTextArea {

  ///StyleTextArea: Devuelve el InputDecoration para un textarea.
  static InputDecoration getDecoration(String label){
    return InputDecoration(
        label: Text(label),
        labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        floatingLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 5),
            borderRadius: BorderRadius.circular(5)),
        contentPadding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
        focusColor: Colors.black,
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black54, width: 2),
            borderRadius: BorderRadius.circular(5)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(5)
        )
    );
  }

  ///StyleTextArea: Devuelve el estilo para el texto.
  static TextStyle getTextStyle(){
    return const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 13);
  }
}