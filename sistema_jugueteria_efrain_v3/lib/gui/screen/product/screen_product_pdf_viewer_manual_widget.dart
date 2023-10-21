import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/pdf_view_manual/product_pdfview_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/product_prices/product_prices_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';

class ScreenProductPDFViewerManualWidget extends ConsumerStatefulWidget {
  const ScreenProductPDFViewerManualWidget({super.key});

  @override
  ConsumerState<ScreenProductPDFViewerManualWidget> createState() {
    return _ScreenProductPDFViewerWidgetState();
  }

}

class _ScreenProductPDFViewerWidgetState extends ConsumerState<ScreenProductPDFViewerManualWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        title: Row(
          children: [SizedBox(width: 36,child: Icon(MdiIcons.fromString("domain"),),), const Expanded(child: Text("Catálogo de Productos - Lector PDF"))],
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16),
        actionsIconTheme: const IconThemeData(color: Colors.yellow, opacity: 0.75),
      ),
      body: Row(
        children: [
          const Visibility(
              visible: true,
              child: SizedBox(
                width: 750,
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: ProductPDFViewWidget())
                ],
              ))
          ),
          Visibility(
            visible: ref.watch(productExtractTextProvider)!=null,
            child: Container(
              width: 375,
              child: ProductPricesCatalogWidget(
                  providerProduct: productExtractTextProvider,
                  providerPriceDistributor: productPricesExtractTextPDFProvider
              )
            )
          )
        ],
      ),
    );
  }
  
}