import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/drawer/drawer_login.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/main/mainbar_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pdf_view/pdf_view_controller_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/tabbedview/tabbedview_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/tabbedview/tabdata_provider.dart';
import 'package:tabbed_view/tabbed_view.dart';

class TabbedViewWidget extends ConsumerStatefulWidget {
  const TabbedViewWidget({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TabbedViewWidgetState();
  }
}

class _TabbedViewWidgetState extends ConsumerState<TabbedViewWidget> {

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    TabbedView tabbedView = TabbedView(
      controller: ref.watch(tabbedViewProvider),
      onTabSelection: (newTabIndex) {
        _updateStateCatalogPDF(newTabIndex);
      },
    );
    Widget w = TabbedViewTheme(
      data: TabbedViewThemeData.dark(),
      child: tabbedView
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 45,
        title: MainBarWidget(key: GlobalKey()),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: w
      ),
      endDrawer: const Drawer(
        child: DrawerLogin()
      ),
    );
  }

  ///TabbedViewWidget: Actualiza el estado (controladores) necesarios para la lectura de pdfs en ProductCatalogPDF.
  _updateStateCatalogPDF(int? newTabIndex){
    if (newTabIndex!=null){
      if (ref.read(tabProductCatalogPDFProvider)!=null)    {
        //Esto soluciona el problema del pdf.
          if (ref.read(tabbedViewProvider).getTabByIndex(newTabIndex)!=ref.read(tabProductCatalogPDFProvider)){
            ref.read(productSearchPDFPriceProvider.notifier).free();
            ref.read(pdfTextSearchResultProvider.notifier).free();
            ref.read(pdfViewControllerProvider.notifier).disposeController();
          }
          else{
            ref.read(pdfViewControllerProvider.notifier).initialize();
          }
      }  
    }
  }
}