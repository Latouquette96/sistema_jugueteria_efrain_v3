import 'package:flutter/material.dart';

class StyleTextField {

  ///StyleTextField: Devuelve el InputDecoration para un textfield.
  static InputDecoration getDecoration(String label){
    return InputDecoration(
      label: Text(label, overflow: TextOverflow.clip,),
      labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      floatingLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 5),
          borderRadius: BorderRadius.circular(5)),
      contentPadding: const EdgeInsets.all(8),
    );
  }

  ///StyleForm: Devuelve el estilo para el texto.
  static TextStyle getTextStyleNormal(){
    return const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13, overflow: TextOverflow.ellipsis);
  }
}