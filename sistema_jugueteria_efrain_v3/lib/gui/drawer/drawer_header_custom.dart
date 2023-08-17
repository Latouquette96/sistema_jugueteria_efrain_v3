import 'package:flutter/material.dart';

///DrawerHeaderCustom: Construeye un drawer de un formato predeterminado.
class DrawerHeaderCustom extends StatelessWidget {
  //Atributos de instancia
  late final String _title, _description;
  late final double _width, _height;

  ///Constructor de DrawerHeaderCustom
  DrawerHeaderCustom({super.key, required String title, required String description, required double width, required double height}){
    _title = title;
    _description = description;
    _height = height;
    _width = width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.grey.shade800, Colors.grey.shade700, Colors.grey.shade800])
      ),
      child: Center(child: Column(
        children: [
          Text(_title, style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),),
          Text(_description, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 13),
          )
        ],
      ),),
    );
  }

}