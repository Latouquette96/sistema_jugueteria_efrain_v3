import 'package:flutter/material.dart';

///Clase HeaderInformationWidget: Permite modelar un encabezado de widget de información.
class HeaderInformationWidget extends StatelessWidget {

  //Atributos de instancia
  final String titleHeader;
  final String? tooltipClose;
  final Function? onClose;
  final Function? onNew;
  final Function? onSave;
  final Function? onDelete;

  ///Constructor del HeaderInformationWidget.
  const HeaderInformationWidget({super.key, required this.titleHeader, this.tooltipClose, this.onClose, this.onSave, this.onNew, this.onDelete});

  
  @override
  Widget build(BuildContext context) {
    double right = 0;

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
            right: right,
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

    if (onSave!=null) right = right + 30;

    listButtons.add(
        Visibility(
            visible: onNew!=null,
            child: Positioned(
                right: right,
                top: 0,
                child: IconButton(
                    tooltip: "Nuevo elemento.",
                    icon: const Icon(Icons.add_circle, color: Colors.yellow,),
                    onPressed: (){
                      onNew!.call();
                    }
                )
            )
        )
    );

    if (onNew!=null) right = right + 30;

    listButtons.add(
        Visibility(
            visible: onDelete!=null,
            child: Positioned(
                right: right,
                top: 0,
                child: IconButton(
                    tooltip: "Eliminar elemento",
                    icon: const Icon(Icons.delete, color: Colors.red,),
                    onPressed: (){
                      onDelete!.call();
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