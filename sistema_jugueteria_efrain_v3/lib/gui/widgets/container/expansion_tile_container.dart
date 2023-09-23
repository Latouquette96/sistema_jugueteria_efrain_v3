import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';

///Clase ExpansionTileContainerWidget: Modela un ExpansionTileCard con un estilo personalizado.
class ExpansionTileContainerWidget extends ConsumerStatefulWidget {

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool isRow;

  ///Constructor de ExpansionTileContainerWidget
  ///
  /// [title] Titulo del contenedor (parte siempre visible).
  /// [subtitle] (opcional) Subtitulo del contenedor (siempre visible si se define).
  /// [children] Lista de Widgets.
  const ExpansionTileContainerWidget({super.key, required this.title, this.subtitle, required this.children, this.isRow=false });

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
    return ExpansionTileCard(
      expandedTextColor: Colors.black,
      expandedColor: Colors.blueGrey.shade50,
      baseColor: Colors.blueGrey.shade100,
      initiallyExpanded: true,
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      title: Center(child: Text(widget.title, style: StyleForm.getTextStyleTitle())),
      subtitle: widget.subtitle!=null ? Text(widget.subtitle!, style: const TextStyle(fontSize: 13)) : null,
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