import 'package:flutter/material.dart';

class StyleContainer {

  ///StyleContainer: Devuelve el estilo de decoración para un contenedor padre.
  static BoxDecoration getContainerRoot(){
    return BoxDecoration(color: Colors.grey.shade500.withOpacity(0.75), border: const BorderDirectional(
      start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      ));
  }

  ///StyleContainer: Devuelve el estilo de decoración para un contenedor padre.
  static BoxDecoration getContainerChild(){
    return BoxDecoration(color: Colors.white.withOpacity(0.85), border: const BorderDirectional(
      start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
    ));
  }

  ///StyleContainer: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de información o catálogo.
  static BoxDecoration getDecorationImage(){
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


  static BoxDecoration getDecoration(){
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

  ///StyleContainer: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de información o catálogo.
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

  ///StyleContainer: Devuelve el BoxDecoration para aplicar a los bordes de un contenedor de información o catálogo.
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


  ///StyleContainer: Estilo de texto para los contenedores root (raiz).
  static TextStyle getTextStyleRoot(){
    return const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600);
  }

  ///StyleContainer: Estilo de texto para los contenedores hijos.
  static TextStyle getTextStyleChildren(){
    return  const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600);
  }

  ///StyleContainer: Estilo de texto para los contenedores hijos.
  static TextStyle getTextStyleBold(){
    return  const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600);
  }
}