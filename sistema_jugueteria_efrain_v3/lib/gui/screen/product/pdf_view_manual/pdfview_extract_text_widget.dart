import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/container_style.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/extract_text/extract_text_pdf_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pdf_view/pdf_view_controller_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///Clase PDFViewExtractTextWidget: Permite mostrar y actualizar la información de un producto.
class PDFViewExtractTextWidget extends ConsumerStatefulWidget {
  const PDFViewExtractTextWidget({super.key});

  @override
  ConsumerState<PDFViewExtractTextWidget> createState() {
    return _PDFViewExtractTextWidgetState();
  }
}

class _PDFViewExtractTextWidgetState extends ConsumerState<PDFViewExtractTextWidget> {

  late final PdfViewerController? _pdfViewerController;
  late File? _file;

  @override
  void initState() {
    _file = null;
    _pdfViewerController = ref.read(pdfExtractTextViewControllerProvider);
    super.initState();
  }

  @override
  didChangeDependencies(){
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //ref.read(pdfViewControllerProvider.notifier).disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        width: 600,
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
                            _file = File(result.files.first.path!);

                            //Si se abre un nuevo documento, se libera el producto en busqueda.
                            ResponseAPI response = await ref.read(extractTextFromPDFProvider.notifier).extractText(result.files.first.path!, ref.read(productCatalogProvider));
                            if (mounted){
                              ElegantNotificationCustom.showNotificationAPI(context, response);
                            }
                            setState(() {});
                          }
                          else {
                            // User canceled the picker
                          }
                        },
                      )
                  ),
                ],
              ),
              (_file==null)
              ? Expanded(
                  child: Container(
                    decoration: ContainerStyle.getContainerChild(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Center(child: Text("Seleccione un archivo PDF", style: StyleForm.getTextStyleListTileTitle(),),))
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: SfPdfViewer.file(
                    _file!,
                    controller: _pdfViewerController,
                    currentSearchTextHighlightColor: Colors.blue.withOpacity(0.5),
                    otherSearchTextHighlightColor: Colors.blueAccent.withOpacity(0.3),
                  )
              ),
              Container(
                color: Colors.black54,
                height: 50,
                child: Row(
                  children: [
                    Expanded(child:
                    IconButton(
                      tooltip: "Ir a resultado anterior",
                      icon: Icon(Icons.arrow_circle_left, color: Colors.blueGrey.shade100),
                      onPressed: (){
                        if (ref.read(pdfExtractTextTextSearchResultProvider)!=null){
                          ref.read(pdfExtractTextTextSearchResultProvider)!.previousInstance();
                          setState((){});
                        }
                      },
                    )
                    ),
                    Expanded(child:
                    (ref.read(pdfExtractTextTextSearchResultProvider)!=null)
                        ? Center(child: Text("${ref.watch(pdfExtractTextTextSearchResultProvider)!.currentInstanceIndex}/${ref.watch(pdfExtractTextTextSearchResultProvider)!.totalInstanceCount}", style: StyleForm.getStyleTextField(),))
                        : Center(child: Text("Sin resultados", style: StyleForm.getStyleTextField()),)
                    ),
                    Expanded(child:
                    IconButton(
                      tooltip: "Ir a resultado siguiente",
                      icon: Icon(Icons.arrow_circle_right, color: Colors.blueGrey.shade100),
                      onPressed: (){
                        if (ref.read(pdfExtractTextTextSearchResultProvider)!=null){
                          ref.read(pdfExtractTextTextSearchResultProvider.notifier).next();
                          setState(() {});
                        }
                      },
                    )
                    )
                  ],
                ),
              )
            ]
        )
    );
  }
}