import 'package:flutter/material.dart';

///Clase StyleForm: Clase que modela los estilos para los campos de formularios utilizados.
class StyleForm {

  ///StyleForm: Devuelve el InputDecoration para un textfield.
  static InputDecoration getDecorationTextField(String label){
    return InputDecoration(
        label: Text(label),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),  
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 5),
          borderRadius: BorderRadius.circular(5)),
      );
  }


}