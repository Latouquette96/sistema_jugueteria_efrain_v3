import 'package:flutter/material.dart';

///Clase StyleExpansionTile: Clase que modela los estilos de texto para un ExpansionTile.
class StyleExpansionTile {

  ///TextStyleCustom: Devuelve el TextStyle a emplear en el titulo de un expansion tile.
  static TextStyle getStyleTitleExpansionTile(){
    return const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w600);
  }

  ///TextStyleCustom: Devuelve el TextStyle a emplear en el subtitulo de un expansion tile.
  static TextStyle getStyleSubtitleExpansionTile(){
    return  TextStyle(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w500);
  }
}