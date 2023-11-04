import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/text_style_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/config/configuration_local.dart';

///Clase ExpansionTileContainerWidget: Modela un ExpansionTileCard con un estilo personalizado.
class ExpansionTileContainerWidget extends ConsumerStatefulWidget {

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool isRow;
  final bool expanded;
  final bool? descriptionShow;
  final Function()? functionLeading;
  final IconData? iconLeading;

  ///Constructor de ExpansionTileContainerWidget
  ///
  /// [title] Titulo del contenedor (parte siempre visible).
  /// [subtitle] (opcional) Subtitulo del contenedor (siempre visible si se define).
  /// [children] Lista de Widgets.
  /// [expanded] True para mostrar expandido el contenedo, en caso contrario False.
  /// [descriptionShow] (Opcional) si es null, por defecto respetará la opción de mostrar/ocultar ayuda de configuraciones.
  /// [functionLeading] (opcional) Se utiliza para agregar un boton que realice una determinada tarea.
  /// [iconLeading] (opcional) Permite definir el icono del boton de funcion.
  const ExpansionTileContainerWidget({super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.isRow=false,
    this.expanded = true,
    this.descriptionShow,
    this.functionLeading,
    this.iconLeading
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ExpansionTileContainerWidgetState();
  }
}

class _ExpansionTileContainerWidgetState extends ConsumerState<ExpansionTileContainerWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Text? subtitle;

    if ((widget.descriptionShow!=null && widget.descriptionShow==true) || (ref.watch(configurationProvider).isShowInfoExpansionTile())) {
      if (widget.subtitle!=null){
        subtitle = Text(widget.subtitle!, style: StyleExpansionTile.getStyleSubtitleExpansionTile());
      }
    }

    return ExpansionTileCard(
      borderRadius: BorderRadius.circular(5),
      expandedTextColor: Colors.black,
      expandedColor: Colors.grey.shade200,
      baseColor: Colors.blueGrey.shade100,
      initiallyExpanded: widget.expanded,
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      title: Center(child: Text(widget.title, style: StyleExpansionTile.getStyleTitleExpansionTile())),
      subtitle: subtitle,
      leading: (widget.functionLeading!=null)
          ? IconButton(
              icon: Icon(widget.iconLeading ?? Icons.play_arrow),
              onPressed: (){
                widget.functionLeading!.call();
              },
            )
          : null,
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          child:
            widget.isRow
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.children,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.children,
              ),
        )
      ],
    );
  }

}