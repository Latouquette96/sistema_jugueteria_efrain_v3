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
  final Function? onCustom;
  final IconButton? onButton;
  final IconData? iconCustom;
  final String? tooltipCustom;
  final bool Function()? isButtonVisible;

  ///Constructor del HeaderInformationWidget.
  const HeaderInformationWidget(
      {
        super.key,
        required this.titleHeader,
        this.tooltipClose,
        this.onClose,
        this.onSave,
        this.onNew,
        this.onDelete,
        this.onCustom,
        this.iconCustom,
        this.tooltipCustom,
        this.onButton,
        this.isButtonVisible,
      }
  );

  
  @override
  Widget build(BuildContext context) {
    double right = 0;

    List<Widget> listButtons = [];

    if (onClose!=null){
      listButtons.add(Positioned(
              left: 0,
              top: 0,
              child: IconButton(
                  tooltip: tooltipClose,
                  icon: const Icon(Icons.close_rounded, color: Colors.redAccent,),
                  onPressed: (){
                    onClose!.call();
                  }
              )
          ));
      right = right + 30;
    }

    if (onSave!=null){
      listButtons.add(
          Positioned(
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
      );
      right = right + 30;
    }

    if (onNew!=null){
      listButtons.add(Positioned(
          right: right,
          top: 0,
          child: IconButton(
              tooltip: "Nuevo elemento.",
              icon: const Icon(Icons.add_circle, color: Colors.yellow,),
              onPressed: (){
                onNew!.call();
              }
          )
      ));
      right = right + 30;
    }

    if (onDelete!=null){
      listButtons.add(Positioned(
          right: right,
          top: 0,
          child: IconButton(
              tooltip: "Eliminar elemento",
              icon: const Icon(Icons.delete, color: Colors.red,),
              onPressed: (){
                onDelete!.call();
              }
          )
      ));
      right = right + 30;
    }

    if (onCustom!=null && iconCustom!=null){
      listButtons.add(Positioned(
          right: right,
          top: 0,
          child: IconButton(
              tooltip: tooltipCustom,
              icon: Icon(iconCustom ?? Icons.error, color: Colors.greenAccent,),
              onPressed: (){
                onCustom!.call();
              }
          )
      ));
      right = right + 30;
    }

    if (onButton!=null && isButtonVisible!=null){
      listButtons.add(
          Visibility(
              visible: isButtonVisible!.call(),
              child: Positioned(
                right: right,
                child: onButton!
              )
          )
      );
      right = right + 30;
    }

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
              height: 45,
              child: Text(titleHeader, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
            ))
          ],
        ),
        ...listButtons
      ],
    );
  }
  

}