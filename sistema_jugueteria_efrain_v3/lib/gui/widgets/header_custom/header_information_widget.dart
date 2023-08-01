import 'package:flutter/material.dart';

///Clase HeaderInformationWidget: Permite modelar un encabezado de widget de información.
class HeaderInformationWidget extends StatelessWidget {

  //Atributos de instancia
  late final String _titleHeader, _tooltipClose;
  late final Function _onClose;

  ///Constructor del HeaderInformationWidget.
  HeaderInformationWidget({super.key, required String titleHeader, required String tooltipClose, required Function onClose}){
    _titleHeader = titleHeader;
    _tooltipClose = tooltipClose;
    _onClose = onClose;
  }

  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0.5, 0, 5),
              padding: const EdgeInsets.all(10),
              color: const Color.fromARGB(255, 44, 43, 43),
              height: 40,
              child: Text(_titleHeader, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
            ))
          ],
        ),
        Positioned(
          left: 0,
          top: 0,
          child: IconButton(
            tooltip: _tooltipClose,
            icon: const Icon(Icons.close_rounded, color: Colors.redAccent,), 
            onPressed: (){ 
              _onClose.call();
            })
          )
      ],
    );
  }
  

}