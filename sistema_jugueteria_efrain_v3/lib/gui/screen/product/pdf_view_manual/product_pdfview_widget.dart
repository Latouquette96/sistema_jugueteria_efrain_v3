import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/container_style.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/container/expansion_tile_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/extract_data/data_fragment.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/extract_text/extract_text_pdf_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';

///Clase ProductPDFViewWidget: Permite mostrar y actualizar la información de un producto.
class ProductPDFViewWidget extends ConsumerStatefulWidget {
  const ProductPDFViewWidget({super.key});
  
  @override
  ConsumerState<ProductPDFViewWidget> createState() {
    return _ProductPDFViewWidgetState();
  }
}

class _ProductPDFViewWidgetState extends ConsumerState<ProductPDFViewWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 750,
      margin: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      decoration: ContainerStyle.getContainerRoot(),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Encabezado principal.
            Stack(
              children: [
                const HeaderInformationWidget(
                  titleHeader: "Visor PDF",
                  tooltipClose: "Cerrar visor PDF.",
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    tooltip: "Abrir PDF almacenado en el sistema.",
                    icon: Icon(MdiIcons.fromString("folder"), color: Colors.white, size: 24,),
                    onPressed: () async{
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        dialogTitle: "Abrir archivo...",
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );

                      if (result != null) {
                        //Si se abre un nuevo documento, se libera el producto en busqueda.
                        ResponseAPI response = await ref.read(extractTextFromPDFProvider.notifier).extractText(result.files.first.path!, ref.read(productCatalogProvider));
                        if (mounted){
                          ElegantNotificationCustom.showNotificationAPI(context, response);
                        }
                        setState(() {

                        });
                      } 
                      else {
                        // User canceled the picker
                      }
                    },
                  )
                ),
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: ref.watch(extractTextFromPDFProvider).map((e) => _getWidgetDataFragment(context, e),).toList(),
                  ),
                )
            )
          ]
      )
    );
  }

  Widget _getWidgetDataFragment(BuildContext context, DataFragment dataFragment){

    return Container(
      margin: const EdgeInsets.all(5),
      child: ExpansionTileContainerWidget(
          expanded: false,
          title: dataFragment.getFragment(),
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              child: Text("Coincidencia con código de barra", style: StyleForm.getTextStyleListTileTitle(),),
            ),
            (dataFragment.getMatchBarcode().isEmpty)
                ? const Text("Sin resultados")
                : SizedBox(
              height: dataFragment.getMatchBarcode().length < 4 ? dataFragment.getMatchBarcode().length*75 : 250,
              child: ListView(
                children: dataFragment.getMatchBarcode().map((e){
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 2.5, 0, 2.5),
                    color: Colors.black12,
                    child: ListTile(
                      title: Text(e.getTitle()),
                      trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios_rounded)),
                    ),
                  );
                }).toList(),
              ),
            ),
            Text("Coincidencia con título", style: StyleForm.getTextStyleListTileTitle(),),
            (dataFragment.getMatchTitle().isEmpty)
                ? const Text("Sin resultados")
                : SizedBox(
              height: dataFragment.getMatchTitle().length < 4 ? dataFragment.getMatchTitle().length*75 : 250,
              child: ListView(
                children: dataFragment.getMatchTitle().map((e){
                  return Container(
                    color: Colors.black12,
                    margin: const EdgeInsets.fromLTRB(0, 2.5, 0, 2.5),
                    child: ListTile(
                      title: Text(e.getTitle()),
                      trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios_rounded)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ]
      ),
    );
  }
}