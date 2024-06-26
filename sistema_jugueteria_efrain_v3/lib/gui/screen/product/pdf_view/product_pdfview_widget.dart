import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_text_field.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pdf_view/pdf_view_controller_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///Clase ProductPDFViewWidget: Permite mostrar y actualizar la información de un producto.
class ProductPDFViewWidget extends ConsumerStatefulWidget {
  const ProductPDFViewWidget({super.key});
  
  @override
  ConsumerState<ProductPDFViewWidget> createState() {
    return _ProductPDFViewWidgetState();
  }
}

class _ProductPDFViewWidgetState extends ConsumerState<ProductPDFViewWidget> {
  
  late final PdfViewerController? _pdfViewerController;
  late File? _file;
  late bool _isFileWeb;
  late ResourceLink _linkPDF = ResourceLink("https://www.argentina.gob.ar/sites/default/files/informe_litio_-_octubre_2021.pdf", mode: ResourceLinkMode.documentPDF);

  @override
  void initState() {
    _isFileWeb = false;
    _file = null;
    _pdfViewerController = ref.read(pdfViewControllerProvider);
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

    Widget widgetPDF;

    if (_isFileWeb==false && _file==null){
      widgetPDF = Text("Seleccione un archivo PDF del sistema o copia el link de un archivo en internet.", style: StyleContainer.getTextStyleChildren());
    }
    else{
      if (_isFileWeb || _file==null){
        widgetPDF = SfPdfViewer.network(
          _linkPDF.getLink(),
          controller: _pdfViewerController,
          currentSearchTextHighlightColor: Colors.blue.withOpacity(0.5),
          otherSearchTextHighlightColor: Colors.blueAccent.withOpacity(0.3),
        );
      }
      else{
        widgetPDF = SfPdfViewer.file(
          _file!,
          controller: _pdfViewerController,
          currentSearchTextHighlightColor: Colors.blue.withOpacity(0.5),
          otherSearchTextHighlightColor: Colors.blueAccent.withOpacity(0.3),
        );
      }
    }


    return Container(
      width: 600,
      margin: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      decoration: StyleContainer.getContainerRoot(),
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
                        _isFileWeb = false;
                        setState(() {});
                      } 
                      else {
                        // User canceled the picker
                      }
                    },
                  )
                ),
                Positioned(
                  right: 30,
                  child: IconButton(
                    tooltip: "Abrir PDF por enlace de archivo en internet",
                    icon: Icon(MdiIcons.fromString("web")), color: Colors.white,
                    onPressed: () async{
                      ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
                      String? copiedtext = (cdata!=null) ? cdata.text : null;

                      if (copiedtext!=null){
                        _linkPDF = ResourceLink(copiedtext, mode: ResourceLinkMode.documentPDF);
                        _isFileWeb = true;
                        setState(() {});
                      }
                    },
                  )
                )
              ],
            ),
            Expanded(
              child: widgetPDF
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
                        if (ref.read(pdfTextSearchResultProvider)!=null){
                          ref.read(pdfTextSearchResultProvider)!.previousInstance();
                          setState((){});
                        }
                      },
                    )
                  ),
                  Expanded(child: 
                    (ref.read(pdfTextSearchResultProvider)!=null)
                    ? Center(child: Text("${ref.watch(pdfTextSearchResultProvider)!.currentInstanceIndex}/${ref.watch(pdfTextSearchResultProvider)!.totalInstanceCount}", style: StyleTextField.getTextStyleNormal(),))
                    : Center(child: Text("Sin resultados", style: StyleTextField.getTextStyleNormal()),)
                  ),
                  Expanded(child: 
                    IconButton(
                      tooltip: "Ir a resultado siguiente",
                      icon: Icon(Icons.arrow_circle_right, color: Colors.blueGrey.shade100),
                      onPressed: (){ 
                        if (ref.read(pdfTextSearchResultProvider)!=null){
                          ref.read(pdfTextSearchResultProvider.notifier).next();
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