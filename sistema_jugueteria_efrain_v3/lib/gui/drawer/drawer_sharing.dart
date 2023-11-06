import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/drawer/drawer_header_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/mixin_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_list_tile.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/container/expansion_tile_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/image/image_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_sharing_provider.dart';

///Clase DrawerSharing: Widget que permite visualizar y exportar los productos modificados localmente y que no pudieron ser exportados
///cuando se realizarón los cambios.
class DrawerSharing extends ConsumerStatefulWidget{

  const DrawerSharing({super.key});

  @override
  ConsumerState<DrawerSharing> createState() {
    return _DrawerSharingState();
  }
}

class _DrawerSharingState extends ConsumerState<DrawerSharing> with ContainerParameters{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getWidgetHeader(context),
        Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ExpansionTileContainerWidget(
                    iconLeading: Icons.image,
                    borderRadius: 0,
                    title: "Carrousel de imágenes",
                    children: [_getWidgetImages(context)]
                ),
                const SizedBox(height: 5,),
                ExpansionTileContainerWidget(
                    borderRadius: 0,
                    iconLeading: Icons.paste,
                    functionLeading: () async {
                      //Pega en el portapapeles el contenido.
                      await Clipboard.setData(ClipboardData(text: ref.read(descriptionProductSharingProvider)));
                    },
                    title: "Ajustes de la descripción",
                    children: [_getWidgetOptions(context)]
                )
              ],
            )
        )
      ],
    );
  }

  ///DrawerSharing: Devuelve el widget de encabezado
  Widget _getWidgetHeader(BuildContext context){
    return DrawerHeaderCustom(
      title: "Compartir Productos",
      description: "Para los productos previamente seleccionados, se puede descargar las imagenes en la carpeta de imágenes (ver configuraciones) y generar una descripción para copiar y pegar en cualquier red social.",
      width: 400,
      height: 125,
    );
  }

  ///DrawerSharing: Devuelve el contenedor de imagenes
  Widget _getWidgetImages(BuildContext context){
    List<Widget> list = [];

    //Para cada producto seleccionado...
    for (Product product in ref.watch(productSharingProvider)){
      for (int i=0; i<product.getLinkImages().length; i++){
        list.add(ImageCustom(
          fileName: product.getFileName(i),
          resourceLink: product.getLinkImages()[i],
          isDownloaded: true,
          isRemoved: false,
          isReplaceable: false,
        ));
      }
    }

    return SizedBox(
      height: 220,
      child: Visibility(
          visible: list.isNotEmpty,
          child: ListView(
            controller: ScrollController(),
            scrollDirection: Axis.horizontal,
            children: list,
          )
      )
    );
  }

  ///DrawerSharing: Devuelve el widget de opciones.
  Widget _getWidgetOptions(BuildContext context){

    String toggleDescription = (ref.watch(productDescriptionComplete))
      ? "Descripción completa."
      : "Descripción básica.";

    String togglePrice = (ref.watch(productPriceVisible))
        ? "Precio oculta."
        : "Precio visible.";

    return Column(
      children: [
        ListTile(
          title: Text("Mostrar la descripción de los productos", style: StyleListTile.getTextStyleTitle()),
          subtitle: Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              children: [
                FlutterSwitch(
                  activeText: "",
                  inactiveText: "",
                  activeColor: Colors.black.withOpacity(0.65),
                  activeTextColor: Colors.white,
                  inactiveTextColor: Colors.white,
                  width: 50,
                  height: 25,
                  toggleSize: 22.5,
                  borderRadius: 20,
                  value: ref.watch(productDescriptionComplete),
                  showOnOff: true,
                  onToggle: (bool val) {
                    ref.read(productDescriptionComplete.notifier).toggle();
                  },
                ),
                const SizedBox(width: 5,),
                Expanded(child: Text(toggleDescription, style: StyleListTile.getTextStyleSubtitle(),))
              ],
            ),
          ),
        ),
        ListTile(
          title: Text("Mostrar la descripción de los productos", style: StyleListTile.getTextStyleTitle()),
          subtitle: Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              children: [
                FlutterSwitch(
                  activeText: "",
                  inactiveText: "",
                  activeColor: Colors.black.withOpacity(0.65),
                  activeTextColor: Colors.white,
                  inactiveTextColor: Colors.white,
                  width: 50,
                  height: 25,
                  toggleSize: 22.5,
                  borderRadius: 20,
                  value: ref.watch(productPriceVisible),
                  showOnOff: true,
                  onToggle: (bool val) {
                    ref.read(productPriceVisible.notifier).toggle();
                  },
                ),
                const SizedBox(width: 5,),
                Expanded(child: Text(togglePrice, style: StyleListTile.getTextStyleSubtitle(),))
              ],
            ),
          ),
        )
      ],
    );
  }
}