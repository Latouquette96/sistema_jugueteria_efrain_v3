import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';

///Clase ImageProductWidget: Modela un widget para una imagen de producto.
class ImageProductWidget extends StatefulWidget {

  final Product? product;
  final bool isTemporal;
  final ResourceLink? linkTemporal;
  final int index;
  final Function onRemoved;
  final Function onSelected;

  ///Constructor de ImageProductWidget
  const ImageProductWidget({super.key, this.product, required this.index, required this.onRemoved, required this.onSelected, this.isTemporal = false, this.linkTemporal});
  
  @override
  State<StatefulWidget> createState() {
    return _ImageProductWidgetState();
  }

}

class _ImageProductWidgetState extends State<ImageProductWidget> {
  
  //Atributos de instancia
  late final Uint8List _image;
  late bool _descargada;

  @override
  void initState() {
    super.initState();
    _descargada = false;
  }

  @override
  Widget build(BuildContext context) {
    //Si es la imagen de un producto nuevo
    if (widget.isTemporal){
      //sino, crear widget en base a 
      return buildImageNetwork(context);
    }
    else{
      //Obtiene el archivo en cuestión.
    File fileImage = File(widget.product!.getFileName(widget.index));

    return FutureBuilder<bool>(
      //comprueba si existe el archivo.
      future: fileImage.exists(), 
      builder: (context, snap){
        if (snap.hasData){
          //Si existe el archivo, entonces crear widget en base a archivo.
          if (snap.data!){
            return buildImageFile(context, fileImage);
          }
          else{
            //sino, crear widget en base a 
            return buildImageNetwork(context);
          }
        }
        else{
          if (snap.hasError){
            return const CircularProgressIndicator(color: Colors.red,);
          }
          else{
            return const CircularProgressIndicator(color: Colors.blue,);
          }
        }
      }
    ); 
    }
  }

  ///ImageProductWidget: Construye el widget de imagen en base de un archivo existente.
  Widget buildImageFile(BuildContext context, File file){
    
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
      children: [
        Image.file(file, width: 200, height: 200,),
        //Remover
        IconButton(
          onPressed: () async {
            widget.onRemoved.call();
            await file.delete();
          }, 
          icon: Icon(MdiIcons.fromString("remove"))
        )
      ],
    ));
  }

  ///ImageProductWidget: Construye el widget de imagen en base al link de imagen.
  Widget buildImageNetwork(BuildContext context){
    if (!_descargada){
      String link = widget.isTemporal ? widget.linkTemporal!.getLink() : widget.product!.getLinkImages()[widget.index].getLink();
      return FutureBuilder<Response>(
        future: http.get(Uri.parse(link)), 
        builder: (context, snap){
          Widget widgetImage;

          if (snap.hasData){
            _image = Uint8List.fromList(snap.data!.bodyBytes);
            _descargada = true;

            return SizedBox(
              height: 200,
              width:  200,
              child: buildImageUint8List(_image),
            );
          }
          else{
            if (snap.hasError){
              widgetImage = const CircularProgressIndicator(color: Colors.red,);
              return SizedBox(
                height: 200,
                width:  200,
                child: widgetImage,
              );
            }
            else{
              widgetImage = const CircularProgressIndicator(color: Colors.blue,);
              return SizedBox(
              height: 200,
              width:  200,
              child: widgetImage,
          );
            }
          }

        }
      );
    }
    else{
      return SizedBox(
        height: 200,
        width:  200,
        child: buildImageUint8List(_image),
      );
    }
  }


  Widget buildImageUint8List(Uint8List uint8list){
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Image.memory(uint8list, width: 200, height: 200,),
          //Remover
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              onPressed: (){
                widget.onRemoved.call();
              }, 
              icon: Icon(MdiIcons.fromString("close-circle"))
            )
          )
        ],
      ),
    );
  }

}