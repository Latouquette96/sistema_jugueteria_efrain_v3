import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/config/screen_configuration.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/screen_distributor_billing.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/screen_distributor_catalog.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/screen_product_pdf_viewer_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/screen_product_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/config/services_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pdf_view/pdf_view_controller_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/tabbedview/tabbedview_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/tabbedview/tabdata_provider.dart';

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
            PlutoMenuItem(
              icon: MdiIcons.fromString("login"),
              title: "Iniciar sesión",
              onTap: () async{
                await ref.read(serviceProvider).run();
              }
            ),
            PlutoMenuItem.checkbox(
              icon: MdiIcons.fromString("cog"),
              title: "Configuraciones",
              initialCheckValue: ref.watch(tabConfigurationProvider)!=null,
              enable: ref.watch(tabConfigurationProvider)!=null,
              onChanged: (bool? isSelected){
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(tabbedViewProvider.notifier).insertTab(label: "Configuraciones", widget: const ScreenConfiguration(), icon: MdiIcons.fromString("cog"), tabProvider: tabConfigurationProvider);
                  }
                  else{
                    ref.read(tabbedViewProvider.notifier).removeTab(tabConfigurationProvider);
                  }
                }
              }
            )
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
                    ref.read(tabbedViewProvider.notifier).insertTab(label:"Catalogo productos", widget: const ScreenProductCatalog(), icon: MdiIcons.fromString("domain"), tabProvider: tabProductCatalogProvider);
                  }
                  else{
                    ref.read(tabbedViewProvider.notifier).removeTab(tabProductCatalogProvider);
                  }
                }
              },
            ),
            PlutoMenuItem.checkbox(
              title: "Visor PDF",
              initialCheckValue: ref.watch(tabProductCatalogPDFProvider)!=null,
              enable: ref.watch(tabProductCatalogPDFProvider)!=null,
              onChanged: (bool? isSelected) {
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(pdfViewControllerProvider.notifier).initialize();
                    ref.read(pdfTextSearchResultProvider.notifier).free();
                    
                    ref.read(tabbedViewProvider.notifier).insertTab(label:"Visor PDF", widget: const ScreenProductPDFViewerWidget(), icon: MdiIcons.fromString("file-pdf-box"), tabProvider: tabProductCatalogPDFProvider);
                  }
                  else{
                    ref.read(tabbedViewProvider.notifier).removeTab(tabProductCatalogPDFProvider);
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
              enable: ref.watch(tabDistributorBillingCatalogProvider)!=null,
              onChanged: (bool? isSelected) {
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(tabbedViewProvider.notifier).insertTab(label: "Catalogo distribuidoras", widget: const ScreenDistributorCatalog(), icon: MdiIcons.fromString("domain"), tabProvider: tabDistributorCatalogProvider);
                  }
                  else{
                    ref.read(tabbedViewProvider.notifier).removeTab(tabDistributorCatalogProvider);
                  }
                }
              },
            ),
            PlutoMenuItem.checkbox(
              title: "Facturas de distribuidoras",
              initialCheckValue: ref.watch(tabDistributorBillingCatalogProvider)!=null,
              enable: ref.watch(tabDistributorBillingCatalogProvider)!=null,
              onChanged: (bool? isSelected) {
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(tabbedViewProvider.notifier).insertTab(label: "Factura distribuidoras", widget: const ScreenDistributorBilling(), icon: MdiIcons.fromString("cash"), tabProvider: tabDistributorBillingCatalogProvider);
                  }
                  else{
                    ref.read(tabbedViewProvider.notifier).removeTab(tabDistributorBillingCatalogProvider);
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