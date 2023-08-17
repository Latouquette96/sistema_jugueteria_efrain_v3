import 'package:flutter/material.dart';

mixin ContainerParameters { 

  final EdgeInsets _marginForms = const EdgeInsets.all(8.0);
  final EdgeInsets _paddingForms = const EdgeInsets.all(8.0);

  ///ContainerParameters: Devuelve el margen empleado en contenedor de información de formulario
  EdgeInsets getMarginInformationForms(){
    return _marginForms;
  }

  ///ContainerParameters: Devuelve el padding empleado en contenedor de información de formulario
  EdgeInsets getPaddingInformationForms(){
    return _paddingForms;
  }
}