import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/config/screen_configuration.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/screen_distributor_billing.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/screen_distributor_catalog.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/screen_product_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/config/services_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/tabbedview/tabbedview_provider.dart';

@immutable
class MainBarWidget extends ConsumerWidget {
  const MainBarWidget({super.key});

  static const TabEnum _keyCatalogDistributor = TabEnum.distributorCatalogWidget;
  static const TabEnum _keyDistributorBilling = TabEnum.distributorBillingWidget;
  static const TabEnum _keyCatalogProduct = TabEnum.productCatalogWidget;
  static const TabEnum _keyConfiguration = TabEnum.configurationWidget;

  //final String _keyCatalogProduct = "catalog_product";

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
              initialCheckValue: ref.read(tabProvider.notifier).isExistTab(_keyConfiguration),
              enable: ref.read(tabProvider.notifier).isExistTab(_keyConfiguration),
              onChanged: (bool? isSelected){
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(tabProvider.notifier).insertTab(tabEnum: _keyConfiguration, label: "Configuraciones", widget: const ScreenConfiguration(), icon: MdiIcons.fromString("cog"));
                  }
                  else{
                    ref.read(tabProvider.notifier).removeTab(_keyConfiguration);
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
              initialCheckValue: ref.read(tabProvider.notifier).isExistTab(_keyCatalogProduct),
              enable: ref.read(tabProvider.notifier).isExistTab(_keyCatalogProduct),
              onChanged: (bool? isSelected) {
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(tabProvider.notifier).insertTab(tabEnum: _keyCatalogProduct, label:"Catalogo productos", widget: const ScreenProductCatalog());
                  }
                  else{
                    ref.read(tabProvider.notifier).removeTab(_keyCatalogProduct);
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
              initialCheckValue: ref.read(tabProvider.notifier).isExistTab(_keyCatalogDistributor),
              enable: ref.read(tabProvider.notifier).isExistTab(_keyCatalogDistributor),
              onChanged: (bool? isSelected) {
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(tabProvider.notifier).insertTab(tabEnum: _keyCatalogDistributor, label: "Catalogo distribuidoras", widget: const ScreenDistributorCatalog());
                  }
                  else{
                    ref.read(tabProvider.notifier).removeTab(_keyCatalogDistributor);
                  }
                }
              },
            ),
            PlutoMenuItem.checkbox(
              title: "Facturas de distribuidoras",
              initialCheckValue: ref.read(tabProvider.notifier).isExistTab(_keyDistributorBilling),
              enable: ref.read(tabProvider.notifier).isExistTab(_keyDistributorBilling),
              onChanged: (bool? isSelected) {
                if (isSelected!=null){
                  if (isSelected){
                    ref.read(tabProvider.notifier).insertTab(tabEnum: _keyDistributorBilling, label: "Factura distribuidoras", widget: const ScreenDistributorBilling());
                  }
                  else{
                    ref.read(tabProvider.notifier).removeTab(_keyDistributorBilling);
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