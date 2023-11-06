import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_container.dart';

import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/config/configuration_local.dart';

class ImageCustom extends ConsumerStatefulWidget {
  final String fileName;
  final ResourceLink resourceLink;
  final bool isReplaceable, isRemoved, isDownloaded, isSelected;
  final Function? onRemoved, onSelected;

  ///Constructor ImageCustom
  ///
  /// [fileName] Nombre del archivo.
  /// [resourceLink] Link del recurso (imagen).
  /// [isReplaceable] True para indicar que la imagen puede cambiar de valor.
  /// [isRemoved] True para indicar que la imagen puede ser removida externamente.
  /// [isSelected] True para indicar si la imagen puede ser seleccionada.
  /// [isDownloaded] True para indicar que la imagen puede ser descargada.
  /// [onRemoved] Funcion (opcional) que es utilizada para remover la imagen. Solo se utiliza si [isRemoved=true].
  /// [onSelected] Funcion (opcional) que es utilizada para seleccionar imagen. Solo se utiliza si [isSelected=true].
  const ImageCustom({
    super.key,
    required this.fileName, required this.resourceLink,
    this.isReplaceable=false,
    this.isRemoved=true, this.onRemoved,
    this.isDownloaded=true,
    this.isSelected=false,
    this.onSelected
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ImageCustomState();
  }
}

class _ImageCustomState extends ConsumerState<ImageCustom>{

  late bool isError;

  @override
  void initState() {
    super.initState();
    isError = false;
  }

  @override
  Widget build(BuildContext context) {
    //Obtiene la configuracion local
    final imagePath = ref.watch(configurationProvider).getValueImagePath();
    //Obtiene el archivo en cuestión.
    File fileImage = File("$imagePath/${widget.fileName}");

    return FutureBuilder<bool>(
      //comprueba si existe el archivo.
      future: fileImage.exists(),
      builder: (context, snap){
        if (snap.hasData){
          //Si existe el archivo, entonces crear widget en base a archivo.
          Widget image = (snap.data!)
            ? buildImageFile(context, fileImage)
            : buildImageNetwork(context, fileImage);

          return image;
        }
        else{
          if (snap.hasError){
            return buildWidgetError(context);
          }
          else{
            return buildCircularProgressIndicatorLoading(context);
          }
        }
      }
    );
  }

  ///ImageCustom: Construye el widget de imagen a partir de un archivo.
  Widget buildImageFile(BuildContext context, File file){
    return SizedBox(
        width: 175,
        height: 175,
        child: Stack(
          children: [
            Image.file(file, width: 175, height: 175,),
            //Remover
            Visibility(
              visible: widget.isRemoved || widget.isReplaceable,
              child: Positioned(
                  top: 165,
                  left: 50,
                  child: Container(
                    decoration: StyleContainer.getDecorationImage(),
                    width: 100,
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                            visible: widget.isRemoved,
                            child: IconButton(
                                tooltip: "Eliminar imagen",
                                onPressed: () async{
                                  widget.onRemoved!.call();
                                  await file.delete();
                                },
                                icon: Icon(MdiIcons.fromString("close-circle"), color: Colors.redAccent)
                            )
                        ),
                        Visibility(
                            visible: widget.isReplaceable,
                            child: IconButton(
                                tooltip: "Reemplazar imagen",
                                onPressed: () async{
                                  ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);

                                  if (cdata!=null){
                                    String link = cdata.text!;
                                    await file.delete();
                                    widget.resourceLink.updateLink(link);
                                    setState(() {});
                                  }
                                },
                                icon: Icon(MdiIcons.fromString("image-refresh"), color: Colors.blue)
                            )
                        ),
                      ],
                    ),
                  )
              ),
            ),
          ],
        ));
  }

  ///ImageCustom: Construye el widget de imagen en base al link de imagen.
  Widget buildImageNetwork(BuildContext context, File file){
    String link = widget.resourceLink.getLink();
    isError = false;
    bool showOptions = widget.isReplaceable || widget.isRemoved || widget.isDownloaded;
    int cantOptions = (widget.isRemoved?1:0) + (widget.isReplaceable?1:0) + (widget.isDownloaded?1:0);

    return Stack(
      children: [
        Image.network(
          link,
          width: 175, height: 175,
          errorBuilder: (context, object, stack){
            isError = true;
            return Container(
              height: 175,
              width:  175,
              padding: const EdgeInsets.all(10),
              decoration: StyleContainer.getDecorationImage(),
              child: Center(child:
              Column(
                children: [
                  Icon(MdiIcons.fromString("image-broken-variant")),
                  const Text("Error: Imagen no recuperada", style: TextStyle(color: Colors.redAccent, fontSize: 14, fontStyle: FontStyle.italic),)
                ],
              )),
            );
          },
        ),
        Visibility(
          visible: showOptions,
          child: Positioned(
              top: 165,
              left: (175-cantOptions*50)/2,
              child: Container(
                decoration: StyleContainer.getDecorationImage(),
                width: cantOptions*50,
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: widget.isRemoved,
                        child: IconButton(
                            tooltip: "Eliminar imagen",
                            onPressed: () async{
                              widget.onRemoved!.call();
                            },
                            icon: Icon(MdiIcons.fromString("close-circle"), color: Colors.redAccent)
                        )
                    ),
                    Visibility(
                        visible: widget.isReplaceable,
                        child: IconButton(
                            tooltip: "Reemplazar imagen",
                            onPressed: () async {
                              ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);

                              if (cdata!=null){
                                String link = cdata.text!;
                                widget.resourceLink.updateLink(link);
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              MdiIcons.fromString("image-refresh"),
                              color: Colors.blue,
                            )
                        )
                    ),
                    Visibility(
                        visible: widget.isDownloaded,
                        child: IconButton(
                            tooltip: "Descargar imagen",
                            onPressed: () async {
                              if (isError){
                                return;
                              }
                              Response<Uint8List> response = await Dio().get<Uint8List>(link, options: Options(responseType: ResponseType.bytes));
                              if (response.data!=null){
                                await file.writeAsBytes(response.data!);
                              }
                              setState((){});
                            },
                            icon: Icon(
                              MdiIcons.fromString("download-circle"),
                              color: Colors.greenAccent,
                            )
                        )
                    )
                  ],
                ),
              )
          ),
        )
      ],
    );
  }

  ///ImageCustom: Construye un CircularProgressIndicator de error.
  Widget buildCircularProgressIndicatorLoading(BuildContext context){
    return Container(
      height: 200,
      width:  200,
      padding: const EdgeInsets.all(10),
      child: const CircularProgressIndicator(color: Colors.blue,),
    );
  }

  ///ImageCustom: Construye un Widget de error.
  Widget buildWidgetError(BuildContext context){
    return Stack(
      children: [
        Container(
          height: 200,
          width:  200,
          padding: const EdgeInsets.all(10),
          child: Center(child:
          Column(
            children: [
              Icon(MdiIcons.fromString("image-broken-variant")),
              const Text("Error: Imagen no recuperada", style: TextStyle(color: Colors.redAccent, fontSize: 14, fontStyle: FontStyle.italic),)
            ],
          )),
        ),
        Positioned(
            top: 165,
            left: 50,
            child: Container(
              decoration: StyleContainer.getDecorationImage(),
              width: 100,
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                      visible: widget.isRemoved,
                      child: IconButton(
                          tooltip: "Eliminar imagen",
                          onPressed: () async{
                            widget.onRemoved!.call();
                          },
                          icon: Icon(MdiIcons.fromString("close-circle"), color: Colors.redAccent)
                      )
                  ),
                  Visibility(
                      visible: widget.isReplaceable,
                      child: IconButton(
                          tooltip: "Reemplazar imagen",
                          onPressed: () async {
                            ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);

                            if (cdata!=null){
                              String link = cdata.text!;
                              widget.resourceLink.updateLink(link);
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            MdiIcons.fromString("image-refresh"),
                            color: Colors.blue,
                          )
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