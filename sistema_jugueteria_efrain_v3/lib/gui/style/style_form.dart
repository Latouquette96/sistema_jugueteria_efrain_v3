import 'package:flutter/material.dart';

///Clase StyleForm: Clase que modela los estilos para los campos de formularios utilizados.
class StyleForm {

  ///StyleForm: Devuelve el InputDecoration para un textfield.
  static InputDecoration getDecorationTextField(String label){
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

  ///StyleForm: Devuelve el InputDecoration para un textarea.
  static InputDecoration getDecorationTextArea(String label){
    return InputDecoration(
        label: Text(label),
        labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),  
        floatingLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 5),
          borderRadius: BorderRadius.circular(5)),
        contentPadding: const EdgeInsets.fromLTRB(8, 15, 8, 8)
      );
  }

  ///StyleForm: Devuelve el estilo para el texto.
  static TextStyle getStyleTextField(){
    return const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13, overflow: TextOverflow.ellipsis);
  }

  ///StyleForm: Devuelve el estilo para el texto.
  static TextStyle getStyleTextTitle(){
    return const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);
  }

  ///StyleForm: Devuelve el estilo para el texto.
  static TextStyle getStyleDropdownField(){
    return const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13);
  }

  ///StyleForm: Devuelve el estilo para el texto.
  static TextStyle getStyleTextArea(){
    return const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 13);
  }

  ///StyleForm: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de información o catálogo.
  static BoxDecoration getDecorationPanel(){
    return BoxDecoration(
      gradient: LinearGradient(colors: [Colors.blueGrey.shade300, Colors.blueGrey.shade200, Colors.blueGrey.shade300]), 
      border: const BorderDirectional(
        start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      ));
  }

  ///StyleForm: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de información o catálogo.
  static BoxDecoration getDecorationFormControlImage(){
    return BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.black38, Colors.black26, Colors.black38]),
        border: const BorderDirectional(
          start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
          top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
          end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
          bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        ),
        borderRadius: BorderRadius.circular(5),
      );
  }

  static TextStyle getTextStyleTitle(){
    return TextStyle(color: Colors.blue.shade900, fontSize: 16, fontWeight: FontWeight.w600);
  }

  static TextStyle getTextStyleListTileTitle(){
    return const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600);
  }

  static TextStyle getTextStyleListTileSubtitle(){
    return const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400);
  }

  static BoxDecoration getDecorationContainer(){
    return BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blueGrey.shade300, Colors.blueGrey.shade200, Colors.blueGrey.shade300]), 
        border: const BorderDirectional(
          start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
          top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
          end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
          bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        )
      );
  }

  ///StyleForm: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de información o catálogo.
  static BoxDecoration getDecorationFormControl(){
    const border =  BorderSide(color: Colors.black26, width: 2);

    return BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blueGrey.shade50, Colors.grey.shade50, Colors.blueGrey.shade50]),
        border: const BorderDirectional(
          start: border,
          top: border,
          end: border,
          bottom: border,
        ),
        borderRadius: BorderRadius.circular(5),
      );
  }

   ///StyleForm: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de listtile
  static BoxDecoration getDecorationListItem(){
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

  ///StyleForm: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de información o catálogo.
  static BoxDecoration getDecorationControlImage(){
    const border =  BorderSide(color: Color.fromARGB(255, 220, 218, 218), width: 1);

    return BoxDecoration(
        color: Colors.white70,
        border: const BorderDirectional(
          start: border,
          top: border,
          end: border,
          bottom: border,
        ),
        borderRadius: BorderRadius.circular(5),
      );
  }

  ///StyleForm: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de información o catálogo.
  static BoxDecoration getDecorationListTileItem(){
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
}