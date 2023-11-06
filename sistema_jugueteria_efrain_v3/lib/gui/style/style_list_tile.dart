import 'package:flutter/material.dart';

class StyleListTile {

  ///StyleListTile: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de listtile
  static BoxDecoration getDecorationItem(){
    const border =  BorderSide(color: Colors.grey, width: 1);

    return BoxDecoration(
      gradient: LinearGradient(colors: [Colors.grey.shade200, Colors.grey.shade100, Colors.grey.shade200]),
      border: const BorderDirectional(
        start: border,
        top: border,
        end: border,
        bottom: border,
      ),
      borderRadius: BorderRadius.circular(5),
    );
  }

  ///StyleListTile: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de información o catálogo.
  static BoxDecoration getDecorationContainer(){
    const border =  BorderSide(color: Color.fromARGB(255, 98, 98, 98), width: 1);

    return BoxDecoration(
      gradient: LinearGradient(colors: [Colors.blue.shade100, Colors.grey.shade100, Colors.grey.shade100]),
      border: const BorderDirectional(
        start: border,
        top: border,
        end: border,
        bottom: border,
      ),
      borderRadius: BorderRadius.circular(5),
    );
  }

  static TextStyle getTextStyleTitle(){
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black.withOpacity(0.75),
      fontSize: 16,
    );
  }

  static TextStyle getTextStyleSubtitle(){
    return TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black.withOpacity(0.65),
        fontSize: 14
    );
  }
}