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

  ///StyleForm: Devuelve el estilo para el boton.
  static ButtonStyle getStyleElevatedButtom(){
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey,
      disabledBackgroundColor: Colors.grey
    );
  }

  ///StyleForm: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de información o catálogo.
  static BoxDecoration getDecorationPanel(){
    return const BoxDecoration(color: Colors.white, border: BorderDirectional(
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

  ///StyleForm: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de información o catálogo.
  static BoxDecoration getDecorationFormControl(){
    const border =  BorderSide(color: Color.fromARGB(255, 220, 218, 218), width: 1);

    return BoxDecoration(
        gradient: LinearGradient(colors: [Colors.grey.shade200, Colors.grey.shade300, Colors.grey.shade200]),
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
        gradient: const LinearGradient(colors: [Color.fromARGB(255, 199, 219, 242), Color.fromARGB(255, 166, 187, 223), Color.fromARGB(255, 189, 206, 246)]),
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