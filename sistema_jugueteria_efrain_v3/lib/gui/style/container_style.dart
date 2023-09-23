import 'package:flutter/material.dart';

class ContainerStyle {

  ///ContainerStyle: Devuelve el estilo de decoración para un contenedor padre.
  static BoxDecoration getContainerRoot(){
    return BoxDecoration(color: Colors.grey.shade500.withOpacity(0.75), border: const BorderDirectional(
      start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      ));
  }

  ///ContainerStyle: Devuelve el estilo de decoración para un contenedor padre.
  static BoxDecoration getContainerChild(){
    return BoxDecoration(color: Colors.white.withOpacity(0.85), border: const BorderDirectional(
      start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
    ));
  }
}