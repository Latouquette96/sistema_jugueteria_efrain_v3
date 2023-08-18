import 'package:pluto_grid/pluto_grid.dart';

class PlutoConfiguration {

  ///PlutoConfiguration: Devuelve la configuración local de texto.
  static getPlutoGridLocaleText(){
    return const PlutoGridLocaleText.spanish(
        freezeColumnToStart: "Fijar al principio",
        freezeColumnToEnd: "Fijar al final",
        unfreezeColumn: "Desfijar"
    );
  }

  static getPlutoGridColumnFilterConfig(){

  }

}