import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/pdf_view/product_pdfview_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/pdf_view/product_price_pdfview_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/product_prices/product_prices_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_container.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_product.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';


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
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        title: Row(
          children: [SizedBox(width: 36,child: Icon(MdiIcons.fromString("domain"),),), const Expanded(child: Text("Catálogo de Productos - Lector PDF"))],
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16),
        actionsIconTheme: const IconThemeData(color: Colors.yellow, opacity: 0.75),
        actions: [
          IconButton(
            onPressed: (){
              StateManagerProduct.getInstanceProductPDF().toggleShowFilter();
              setState(() {});
            },
            icon: Icon(
              MdiIcons.fromString("filter"),
              color:  StateManagerProduct.getInstanceProductPDF().isShowFilter() ? Colors.yellow : Colors.grey,
            ),
            tooltip: "Mostrar/ocultar filtro",
          ),
          IconButton(
            onPressed: () async{
              //Cierra las pantallas abiertas.
              if (ref.read(productSearchPDFPriceProvider)!=null) ref.read(productSearchPDFPriceProvider.notifier).free();
              //Refrezca el catálogo de productos.
              await StateManagerProduct.getInstanceProductPDF().refresh(ref.read(urlAPIProvider));
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
            decoration: StyleContainer.getContainerRoot(),
            child: const ProductPricePDFViewCatalogWidget(),
          )),
          const Visibility(
              visible: true,
              child: SizedBox(
                width: 600,
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: ProductPDFViewWidget())
                ],
              ))
          ),
          Visibility(
              visible: ref.watch(productSearchPDFPriceProvider) != null,
              child: SizedBox(
                width: 375,
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: ProductPricesCatalogWidget(
                    providerProduct: productSearchPDFPriceProvider, 
                    providerPriceDistributor: productPricesPDFByIDProvider, 
                    providerStateManager: StateManagerProduct.getInstanceProductPDF(),
                  ))
                ],
              ))
          ),
        ],
      ),
    );
  }
  
}