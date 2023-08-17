import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/drawer/drawer_header_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/mixin_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/image/image_product_widget.dart';
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
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _getWidgetHeader(context),
        _getWidgetImages(context),
        _getWidgetOptions(context)
      ],
    );
  }

  ///DrawerSharing: Devuelve el widget de encabezado
  Widget _getWidgetHeader(BuildContext context){
    return DrawerHeaderCustom(
      title: "Compartir Productos",
      description: "Para los productos previamente seleccionados, se puede descargar las imagenes en la carpeta de imágenes (ver configuraciones) y generar una descripción para copiar y pegar en cualquier red social.",
      width: 400,
      height: 150,
    );
  }

  ///DrawerSharing: Devuelve el contenedor de imagenes
  Widget _getWidgetImages(BuildContext context){
    List<Widget> list = [];

    //Para cada producto seleccionado...
    for (Product product in ref.watch(productSharingProvider)){
      for (int i=0; i<product.getLinkImages().length; i++){
        list.add(ImageProductWidget(index: i, product: product, onRemoved: (){}, onSelected: (){}));
      }
    }

    return Container(
      height: 250,
      margin: getMarginInformationForms(),
      padding: getPaddingInformationForms(),
      decoration: StyleForm.getDecorationFormControl(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Carousel de Imágenes del producto", style: StyleForm.getStyleTextTitle(),),
          Visibility(
            visible: list.isNotEmpty,
            child: SizedBox(
              height: 200,
              child: SingleChildScrollView(
                controller: ScrollController(),
                scrollDirection: Axis.horizontal,
                child: Row(children: list,))
            ),
          ),
        ],
      )
    );
  }

  ///DrawerSharing: Devuelve el widget de opciones.
  Widget _getWidgetOptions(BuildContext context){
    List<Widget> listButtons = [];

    listButtons.add(
      Container(
        margin: getMarginInformationForms(),
        padding: getPaddingInformationForms(),
        decoration: StyleForm.getDecorationFormControl(),
        child: ListTile(

          title: Center(child: Text("Opciones de descripción", style: StyleForm.getStyleTextTitle()),),
          subtitle: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(2.5),
                child: FlutterSwitch(
                  activeText: "Descripción completa",
                  inactiveText: "Descripción básica",
                  activeColor: Colors.blueAccent,
                  activeTextColor: Colors.white,
                  inactiveTextColor: Colors.white,
                  width: 200,
                  height: 35,
                  valueFontSize: 12.0,
                  toggleSize: 20.0,
                  borderRadius: 10,
                  value: ref.watch(productDescriptionComplete),
                  showOnOff: true,
                  onToggle: (bool val) {
                    ref.read(productDescriptionComplete.notifier).toggle();
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(2.5),
                child: FlutterSwitch(
                  activeText: "Precio del producto oculto",
                  inactiveText: "Precio del producto visible",
                  activeColor: Colors.blueAccent,
                  activeTextColor: Colors.white,
                  inactiveTextColor: Colors.white,
                  width: 200,
                  height: 35,
                  valueFontSize: 12.0,
                  toggleSize: 20.0,
                  borderRadius: 10,
                  value: ref.watch(productPriceVisible),
                  showOnOff: true,
                  onToggle: (bool val) {
                    ref.read(productPriceVisible.notifier).toggle();
                  },
                ),
              ),
            ],
          )
      ))
    );

    listButtons.add(
      Container(
        margin: getMarginInformationForms(),
        padding: getPaddingInformationForms(),
        decoration: StyleForm.getDecorationFormControl(),
        child: ListTile(
          title: Center(child: Text("Compartir...", style: StyleForm.getStyleTextTitle(),)),
          subtitle: Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(2.5),
                  child: ElevatedButton(
                    style: StyleForm.getStyleElevatedButtom(),
                    onPressed: () async{
                      //Pega en el portapapeles el contenido.
                      await Clipboard.setData(ClipboardData(text: ref.read(descriptionProductSharingProvider)));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.paste),
                        Expanded(child: Text("Copiar texto al portapapeles"))
                      ],
                    )
                  )
              ),
              Container(
                  margin: const EdgeInsets.all(2.5),
                  child: ElevatedButton(
                    style: StyleForm.getStyleElevatedButtom(),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.close),
                        Expanded(child: Text("Cerrar"))
                      ],
                    )
                  )
              )
            ],
          )
      ))
    );

    return Column(
      children: listButtons,
    );
  }
}