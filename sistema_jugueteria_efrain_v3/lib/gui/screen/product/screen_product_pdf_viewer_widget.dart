import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/catalog/product_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/catalog/product_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/pdf_view/product_pdfview_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';

class ScreenProductPDFViewerWidget extends ConsumerStatefulWidget {
  const ScreenProductPDFViewerWidget({super.key});

  @override
  ConsumerState<ScreenProductPDFViewerWidget> createState() {
    return _ScreenProductPDFViewerWidgetState();
  }

}

class _ScreenProductPDFViewerWidgetState extends ConsumerState<ScreenProductPDFViewerWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [SizedBox(width: 36,child: Icon(MdiIcons.fromString("domain"),),), const Expanded(child: Text("Catálogo de Productos"))],
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16),
        actionsIconTheme: const IconThemeData(color: Colors.yellow, opacity: 0.75),
        actions: [
          IconButton(
            onPressed: (){
              
            },
            icon: Icon(MdiIcons.fromString("plus-circle")),
            tooltip: "Insertar un nuevo producto.",
          ),
          IconButton(
            onPressed: (){
              
            },
            icon: Icon(MdiIcons.fromString("reload")),
            tooltip: "Recargar catálogo.",
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(child: Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            decoration: const BoxDecoration(color: Colors.white, border: BorderDirectional(
              start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
              top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
              end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
              bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
            )),
            child: const ProductCatalogWidget(),
          )),
          Visibility(
              visible: ref.watch(productProvider) != null,
              child: const SizedBox(
                width: 400,
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: ProductInformationWidget())
                ],
              ))
          ),
          Visibility(
              visible: ref.watch(productSearchPriceProvider) != null,
              child: const SizedBox(
                width: 600,
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: ProductPDFViewWidget())
                ],
              ))
            )
        ],
      ),
    );
  }
  
}