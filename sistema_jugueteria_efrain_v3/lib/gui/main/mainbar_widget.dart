import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/config/screen_configuration.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/screen_distributor_catalog.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/import_mysql/screen_import_mysql_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/screen_pdf_viewer_extract_text_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/screen_product_pdf_viewer_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/screen_product_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/statistics/statistics_screen.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pdf_view/pdf_view_controller_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/tabbedview/tabbedview_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/tabbedview/tabdata_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

@immutable
class MainBarWidget extends ConsumerWidget {
  const MainBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlutoMenuBar(
      height: 30,
      mode: PlutoMenuBarMode.hover,
      itemStyle: const PlutoMenuItemStyle(
        iconColor: Colors.blue,
        unselectedColor: Colors.blueGrey,
        activatedColor: Colors.blue,
        selectedTopMenuIconColor: Colors.yellow,
        textStyle: TextStyle(color: Colors.white, fontSize: 14),
      ),
      backgroundColor: Colors.black,
      menus: [
        PlutoMenuItem(
          title: "Archivo",
          children: [
            PlutoMenuItem.checkbox(
              icon: MdiIcons.fromString("cog"),
              title: "Configuraciones",
              initialCheckValue: ref.watch(tabConfigurationProvider)!=null,
              enable: ref.watch(tabConfigurationProvider)!=null,
              onChanged: (bool? isSelected){
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(tabbedViewProvider.notifier).insertTab(
                        label: "Configuraciones",
                        widget: const ScreenConfiguration(),
                        icon: MdiIcons.fromString("cog"),
                        tabProvider: tabConfigurationProvider
                    );
                  }
                  else{
                    ref.read(tabbedViewProvider.notifier).removeTab(tabConfigurationProvider);
                  }
                }
              }
            ),
            PlutoMenuItem.checkbox(
                title: "Estadisticas Generales",
                initialCheckValue: ref.watch(tabStatistics)!=null,
                enable: ref.watch(tabStatistics)!=null,
                onChanged: (bool? isSelected){
                  if (isSelected!=null){
                    if (isSelected){
                      ref.read(tabbedViewProvider.notifier).insertTab(label: "Estadisticas Generales", widget: const ScreenStatistics(), icon: MdiIcons.fromString("database"), tabProvider: tabStatistics);
                    }
                    else{
                      ref.read(tabbedViewProvider.notifier).removeTab(tabStatistics);
                    }
                  }
                }
            ),
            PlutoMenuItem.checkbox(
              title: "Importar datos (Sistema v2)",
              initialCheckValue: ref.watch(tabImportMySQLCatalog)!=null,
              enable: ref.watch(tabImportMySQLCatalog)!=null,
              onChanged: (bool? isSelected){
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(tabbedViewProvider.notifier).insertTab(label: "Importar datos (Sistema v2)", widget: const ScreenImportProductWidget(), icon: MdiIcons.fromString("download"), tabProvider: tabImportMySQLCatalog);
                  }
                  else{
                    ref.read(tabbedViewProvider.notifier).removeTab(tabImportMySQLCatalog);
                  }
                }
              }
            ),
          ]
        
        ),
        PlutoMenuItem(title: "Producto",
          children: [
            PlutoMenuItem.checkbox(
              title: "Catálogo de productos",
              initialCheckValue: ref.watch(tabProductCatalogProvider)!=null,
              enable: ref.watch(tabProductCatalogProvider)!=null,
              onChanged: (bool? isSelected) {
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(tabbedViewProvider.notifier).insertTab(
                        label:"Catalogo productos",
                        widget: const ScreenProductCatalog(),
                        icon: MdiIcons.fromString("domain"),
                        tabProvider: tabProductCatalogProvider
                    );
                  }
                  else{
                    ref.read(tabbedViewProvider.notifier).removeTab(tabProductCatalogProvider);
                  }
                }
              },
            ),
            PlutoMenuItem.checkbox(
              title: "Catalogo de productos - Visor PDF",
              initialCheckValue: ref.watch(tabProductCatalogPDFProvider)!=null,
              enable: ref.watch(tabProductCatalogPDFProvider)!=null,
              onChanged: (bool? isSelected) {
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(pdfViewControllerProvider.notifier).load(PdfViewerController());
                    ref.read(pdfTextSearchResultProvider.notifier).free();
                    
                    ref.read(tabbedViewProvider.notifier).insertTab(
                        label:"Catalogo de productos - Visor PDF",
                        widget: const ScreenProductPDFViewerWidget(),
                        icon: MdiIcons.fromString("file-pdf-box"),
                        tabProvider: tabProductCatalogPDFProvider
                    );
                  }
                  else{
                    ref.read(tabbedViewProvider.notifier).removeTab(tabProductCatalogPDFProvider);
                  }
                }
              },
            ),
            PlutoMenuItem.checkbox(
              title: "Catalogo de productos - Buscador de productos en PDF",
              initialCheckValue: ref.watch(tabProductCatalogPDFManualProvider)!=null,
              enable: ref.watch(tabProductCatalogPDFManualProvider)!=null,
              onChanged: (bool? isSelected) {
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(pdfViewControllerProvider.notifier).load(PdfViewerController());
                    ref.read(pdfTextSearchResultProvider.notifier).free();

                    ref.read(tabbedViewProvider.notifier).insertTab(
                        label:"Catalogo de productos - Buscador de productos en PDF",
                        widget: const ScreenPDFViewerExtractTextWidget(),
                        icon: MdiIcons.fromString("file-pdf-box"),
                        tabProvider: tabProductCatalogPDFManualProvider
                    );
                  }
                  else{
                    ref.read(tabbedViewProvider.notifier).removeTab(tabProductCatalogPDFManualProvider);
                  }
                }
              },
            ),
          ]
        ),
        PlutoMenuItem(
          title: "Distribuidora",
          children: [
            PlutoMenuItem.checkbox(
              title: "Catálogo de distribuidoras",
              initialCheckValue: ref.watch(tabDistributorCatalogProvider)!=null,
              enable: ref.watch(tabDistributorCatalogProvider)!=null,
              onChanged: (bool? isSelected) {
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(tabbedViewProvider.notifier).insertTab(
                        label: "Catalogo distribuidoras",
                        widget: const ScreenDistributorCatalog(),
                        icon: MdiIcons.fromString("domain"),
                        tabProvider: tabDistributorCatalogProvider);
                  }
                  else{
                    ref.read(tabbedViewProvider.notifier).removeTab(tabDistributorCatalogProvider);
                  }
                }
              },
            )
          ]
        )
      ]
    );
  }
  
}