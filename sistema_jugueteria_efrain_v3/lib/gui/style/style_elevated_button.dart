import 'package:flutter/material.dart';

class StyleElevatedButton {


  ///StyleElevatedButton: Devuelve el estilo para el boton.
  static ButtonStyle getStyleElevatedButtom(){
    return ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        disabledBackgroundColor: Colors.grey
    );
  }

  ///StyleElevatedButton: Devuelve el estilo para el boton.
  static ButtonStyle getStyleLogin(){
    return ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade100,
        foregroundColor: Colors.blue.shade900,
        disabledBackgroundColor: Colors.grey.shade300,
        disabledForegroundColor: Colors.black26,
    );
  }

  ///StyleElevatedButton: Devuelve el estilo para el boton.
  static ButtonStyle getStyleLoginCancel(){
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.redAccent,
      disabledBackgroundColor: Colors.grey.shade300,
      disabledForegroundColor: Colors.black26,
    );
  }
}