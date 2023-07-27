import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/screen_distributor_billing.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/screen_distributor_catalog.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/tabbedview/tabbedview_provider.dart';

@immutable
class MainBarWidget extends ConsumerWidget {
  const MainBarWidget({super.key});

  static const TabEnum _keyCatalogDistributor = TabEnum.distributorCatalogWidget;
  static const TabEnum _keyDistributorBilling = TabEnum.distributorBillingWidget;
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
        PlutoMenuItem(title: "Archivo"),
        PlutoMenuItem(title: "Producto"),
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
                    ref.read(tabProvider.notifier).insertTab(_keyCatalogDistributor, "Catalogo distribuidoras", const ScreenDistributorCatalog());
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
                    ref.read(tabProvider.notifier).insertTab(_keyDistributorBilling, "Factura distribuidoras", const ScreenDistributorBilling());
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