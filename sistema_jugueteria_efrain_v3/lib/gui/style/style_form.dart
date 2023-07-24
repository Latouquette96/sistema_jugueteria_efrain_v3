import 'package:flutter/material.dart';

///Clase StyleForm: Clase que modela los estilos para los campos de formularios utilizados.
class StyleForm {

  ///StyleForm: Devuelve el InputDecoration para un textfield.
  static InputDecoration getDecorationTextField(String label){
    return InputDecoration(
        label: Text(label),
        labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),  
        floatingLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 5),
          borderRadius: BorderRadius.circular(5)),
        contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0)
      );
  }

  ///StyleForm: Devuelve el estilo para el texto.
  static TextStyle getStyleTextField(){
    return const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);
  }
}