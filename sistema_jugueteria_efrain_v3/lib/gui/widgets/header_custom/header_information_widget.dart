import 'package:flutter/material.dart';

///Clase HeaderInformationWidget: Permite modelar un encabezado de widget de información.
class HeaderInformationWidget extends StatelessWidget {

  //Atributos de instancia
  final String titleHeader, tooltipClose;
  final Function? onClose;
  final Function? onNew;
  final Function? onSave;

  ///Constructor del HeaderInformationWidget.
  const HeaderInformationWidget({super.key, required this.titleHeader, required this.tooltipClose, this.onClose, this.onSave, this.onNew});

  
  @override
  Widget build(BuildContext context) {
    List<Widget> listButtons = [];
    listButtons.add(
        Visibility(
            visible: onClose!=null,
            child: Positioned(
                left: 0,
                top: 0,
                child: IconButton(
                    tooltip: tooltipClose,
                    icon: const Icon(Icons.close_rounded, color: Colors.redAccent,),
                    onPressed: (){
                      onClose!.call();
                    }
                )
            )
        )
    );

    listButtons.add(
        Visibility(
          visible: onSave!=null,
          child: Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              tooltip: "Guardar información.",
              icon: const Icon(Icons.save, color: Colors.yellow,),
              onPressed: (){
                onSave!.call();
              }
            )
          )
        )
    );

    listButtons.add(
        Visibility(
            visible: onNew!=null,
            child: Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                    tooltip: "Nuevo elemento.",
                    icon: const Icon(Icons.add_circle, color: Colors.blueGrey,),
                    onPressed: (){
                      onNew!.call();
                    }
                )
            )
        )
    );

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
              child: Text(titleHeader, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
            ))
          ],
        ),
        ...listButtons
      ],
    );
  }
  

}