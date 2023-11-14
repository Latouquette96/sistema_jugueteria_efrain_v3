import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/pdf_view_manual/filtered_product_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/pdf_view_manual/pdfview_extract_text_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/product_prices/product_prices_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/extract_text/extract_text_pdf_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pdf_view/pdf_view_controller_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_product.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';

class ScreenPDFViewerExtractTextWidget extends ConsumerStatefulWidget {
  const ScreenPDFViewerExtractTextWidget({super.key});

  @override
  ConsumerState<ScreenPDFViewerExtractTextWidget> createState() {
    return _ScreenProductPDFViewerWidgetState();
  }

}

class _ScreenProductPDFViewerWidgetState extends ConsumerState<ScreenPDFViewerExtractTextWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        title: Row(
          children: [SizedBox(width: 36,child: Icon(MdiIcons.fromString("domain"),),), const Expanded(child: Text("Catálogo de Productos - Buscador de productos en PDF"))],
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16),
        actionsIconTheme: const IconThemeData(color: Colors.yellow, opacity: 0.75),
      ),
      body: Row(
        children: [
          Visibility(
              visible: ref.watch(pdfExtractTextViewControllerProvider)!=null,
              child: const Expanded(
                child: PDFViewExtractTextWidget(),
              )
          ),
          Visibility(
              visible: ref.watch(extractTextFromPDFProvider).isNotEmpty,
              child: const SizedBox(
                width: 400,
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: FilteredProductCatalogWidget())
                ],
              ))
          ),
          Visibility(
            visible: ref.watch(productExtractTextProvider)!=null,
            child: SizedBox(
              width: 375,
              child: ProductPricesCatalogWidget(
                  providerProduct: productExtractTextProvider,
                  providerPriceDistributor: productPricesExtractTextPDFProvider,
                  providerStateManager: StateManagerProduct.getInstanceProductPDFAdvanced(),
              )
            )
          )
        ],
      ),
    );
  }
  
}