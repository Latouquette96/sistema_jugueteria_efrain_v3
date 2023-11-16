import 'package:flutter/material.dart';

///Clase StyleExpansionTile: Clase que modela los estilos de texto para un ExpansionTile.
class StyleExpansionTile {

  static final List<Color> _listExpanded = [
    Colors.grey.shade200,
    Colors.brown.shade50.withOpacity(0.85),
    Colors.brown.shade100,
  ];

  static final List<Color> _listBaseColor = [
    Colors.brown.shade100,
    Colors.brown.shade100,
    Colors.brown.shade100
  ];

  ///StyleExpansionTile: Devuelve el color del bloque expandido. Si [index<0], entonces devuelve el primer color (para root), si [index>5] entonces se emplea el ultimo color.
  static Color getExpandedColor(int index){
    if (index<0){
      return _listExpanded.first;
    }
    else{
      if (index<_listExpanded.length){
        return _listExpanded[index];
      }
      else{
        return _listExpanded.last;
      }
    }
  }

  ///StyleExpansionTile: Devuelve el color del bloque base. Si [index<0], entonces devuelve el primer color (para root), si [index>5] entonces se emplea el ultimo color.
  static Color getBaseColor(int index){
    if (index<0){
      return _listBaseColor.first;
    }
    else{
      if (index<_listBaseColor.length){
        return _listBaseColor[index];
      }
      else{
        return _listBaseColor.last;
      }
    }
  }

  ///TextStyleCustom: Devuelve el TextStyle a emplear en el titulo de un expansion tile.
  static TextStyle getStyleTitleExpansionTile(){
    return  TextStyle(color: Colors.brown.shade800, fontSize: 15, fontWeight: FontWeight.w600);
  }

  ///TextStyleCustom: Devuelve el TextStyle a emplear en el subtitulo de un expansion tile.
  static TextStyle getStyleSubtitleExpansionTile(){
    return  TextStyle(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w500);
  }
}