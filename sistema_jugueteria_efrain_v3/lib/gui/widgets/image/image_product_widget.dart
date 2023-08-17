import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/config/configuration_local.dart';

///Clase ImageProductWidget: Modela un widget para una imagen de producto.
class ImageProductWidget extends ConsumerStatefulWidget {

  final Product? product;
  final bool isTemporal;
  final ResourceLink? linkTemporal;
  final int index;
  final Function onRemoved;
  final Function onSelected;

  ///Constructor de ImageProductWidget
  const ImageProductWidget({super.key, this.product, required this.index, required this.onRemoved, required this.onSelected, this.isTemporal = false, this.linkTemporal});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ImageProductWidgetState();
  }

}

class _ImageProductWidgetState extends ConsumerState<ImageProductWidget> {
  
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
      //Obtiene la configuracion local
      final imagePath = ref.watch(configImagePathProvider);
      //Obtiene el archivo en cuestión.
      File fileImage = File("$imagePath/${widget.product!.getFileName(widget.index)}");

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
        //Remover
        Positioned(
          top: 165,
          left: 50,
          child: Container(
            decoration: StyleForm.getDecorationControlImage(),
            width: 100,
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: "Eliminar imagen",
                  onPressed: () async{
                    widget.onRemoved.call();
                    await file.delete();
                  }, 
                  icon: Icon(
                    MdiIcons.fromString("close-circle"), 
                    color: Colors.redAccent,
                  )
                ),
              ],
            ),
          )
        ),
      ],
    ));
  }

  ///ImageProductWidget: Construye el widget de imagen en base al link de imagen.
  Widget buildImageNetwork(BuildContext context){
    if (!_descargada){
      String link = widget.isTemporal ? widget.linkTemporal!.getLink() : widget.product!.getLinkImages()[widget.index].getLink();
      return FutureBuilder(
        future: Dio().get<Uint8List>(link, options: Options(responseType: ResponseType.bytes)),
        builder: (context, snap){
          Widget widgetImage;

          if (snap.hasData){

            Response<Uint8List>? rs = snap.data;
            if (rs!=null){
              _image = rs.data!;
              _descargada = true;
              
              return SizedBox(
                height: 200,
                width:  200,
                child: buildImageUint8List(),
              );
            }
            else{
              return const SizedBox(
                height: 200, 
                width: 200, 
                child: CircularProgressIndicator(color: Colors.redAccent,)
              );
            }
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
        child: buildImageUint8List(),
      );
    }
  }

  ///ImageProductWidget: Construye el widget de imagen en base a los datos obtenidos de internet.
  Widget buildImageUint8List(){
    return Stack(
      children: [
        Image.memory(_image, width: 200, height: 200,),
        //Remover
        Positioned(
          top: 165,
          left: 50,
          child: Container(
            decoration: StyleForm.getDecorationControlImage(),
            width: 100,
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: "Eliminar imagen",
                  onPressed: (){
                    widget.onRemoved.call();
                  }, 
                  icon: Icon(
                    MdiIcons.fromString("close-circle"), 
                    color: Colors.redAccent,
                  )
                ),
                IconButton(
                  tooltip: "Guardar imagen",
                  onPressed: () async{
                    //Obtiene la configuracion local
                    final imagePath = ref.watch(configImagePathProvider);
                    //Obtiene el archivo en cuestión.
                    File fileImage = File("$imagePath/${widget.product!.getFileName(widget.index)}");
                    await fileImage.writeAsBytes(_image);
                    setState(() {
                      
                    });
                  }, 
                  icon: Icon(
                    MdiIcons.fromString("download-circle"), 
                    color: Colors.blue,
                  )
                )
              ],
            ),
          )
        )
      ],
    );
  }

}