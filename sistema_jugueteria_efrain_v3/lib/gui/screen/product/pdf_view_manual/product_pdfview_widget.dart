import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/container_style.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pdf_view/extract_text_from_pdf_provider.dart';

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
                        ResponseAPI response = await ref.read(extractTextFromPDFProvider.notifier).extractText(result.files.first.path!);
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
                    children: ref.watch(extractTextFromPDFProvider).map((e) => Container(
                      margin: const EdgeInsets.all(1),
                      padding: const EdgeInsets.all(1),
                      decoration: ContainerStyle.getContainerChild(),
                      height: 40,
                      child: ListTile(
                        title: Text(e, style: StyleForm.getTextStyleSubtitle(),),
                      ),
                    )).toList(),
                  ),
                )
            )
          ]
      )
    );
  }
}