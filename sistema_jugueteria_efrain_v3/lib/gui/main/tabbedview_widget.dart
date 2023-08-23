import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/main/mainbar_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pdf_view/pdf_view_controller_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/tabbedview/tabbedview_provider.dart';
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
        if (newTabIndex!=null){
          //Esto soluciona el problema del pdf.
          if (ref.read(tabbedViewProvider).getTabByIndex(newTabIndex).value!=TabEnum.productPDFViewer){
            ref.read(productSearchPDFPriceProvider.notifier).free();
            ref.read(pdfTextSearchResultProvider.notifier).free();
            ref.read(pdfViewControllerProvider.notifier).disposeController();
          }
          else{
            ref.read(pdfViewControllerProvider.notifier).initialize();
          }
        }
      },
    );
    Widget w = TabbedViewTheme(
      data: TabbedViewThemeData.dark(),
      child: tabbedView
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 30,
        title: MainBarWidget(key: GlobalKey()),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: w
      )
    );
  }

}