import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_expansion_tile.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/config/configuration_local.dart';

///Clase ExpansionTileContainerWidget: Modela un ExpansionTileCard con un estilo personalizado.
class ExpansionTileContainerWidget extends ConsumerStatefulWidget {

  final String? title;
  final String? subtitle;
  final List<Widget> children;
  final bool isRow;
  final bool expanded;
  final bool? descriptionShow;
  final Function()? functionLeading;
  final IconData? iconLeading;
  final double borderRadius;
  final Widget? trailing;
  final int childrenLevel;

  ///Constructor de ExpansionTileContainerWidget
  ///
  /// [title] Titulo del contenedor (parte siempre visible).
  /// [subtitle] (opcional) Subtitulo del contenedor (siempre visible si se define).
  /// [children] Lista de Widgets.
  /// [expanded] True para mostrar expandido el contenedo, en caso contrario False.
  /// [descriptionShow] (Opcional) si es null, por defecto respetará la opción de mostrar/ocultar ayuda de configuraciones.
  /// [functionLeading] (opcional) Se utiliza para agregar un boton que realice una determinada tarea.
  /// [iconLeading] (opcional) Permite definir el icono del boton de funcion.
  /// [borderRadius] (opcional) Permite definir el radio del borde (circular).
  /// [trailing] (opcional) Permite poner botones del lado derecho.
  /// [childrenLevel] Permite definir el nivel de altura del hijo, siendo 0 un expansion_tile padre, 1 un hijo de dicho padre, 2 un hijo del hijo del padre, y así sucesivamente.
  const ExpansionTileContainerWidget({super.key,
    this.title,
    this.subtitle,
    required this.children,
    this.isRow=false,
    this.expanded = true,
    this.descriptionShow,
    this.functionLeading,
    this.iconLeading,
    this.borderRadius = 5,
    this.trailing,
    this.childrenLevel = 0
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
      borderRadius: BorderRadius.circular(widget.borderRadius),
      expandedTextColor: Colors.black,
      expandedColor: StyleExpansionTile.getExpandedColor(widget.childrenLevel),
      baseColor: StyleExpansionTile.getBaseColor(widget.childrenLevel),
      initiallyExpanded: widget.expanded,
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      title: (widget.trailing!=null)
          ? widget.trailing!
          : Center(child: Text(widget.title ?? "Sin definir título", style: StyleExpansionTile.getStyleTitleExpansionTile())),
      subtitle: subtitle,
      leading: (widget.functionLeading!=null)
          ? IconButton(
              icon: Icon(widget.iconLeading ?? Icons.play_arrow),
              onPressed: (){
                widget.functionLeading!.call();
              },
            )
          : (widget.iconLeading==null) ? null : Icon(widget.iconLeading),
      shadowColor: Colors.black,
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