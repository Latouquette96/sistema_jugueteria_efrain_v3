import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/drawer/drawer_sharing.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/catalog/product_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/catalog/product_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/product_prices/product_prices_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_sharing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/state_manager_provider.dart';

///Clase ScreenProductCatalog: Modela un catálogo de productos.
class ScreenProductCatalog extends ConsumerStatefulWidget {
  const ScreenProductCatalog({super.key});

  @override
  ConsumerState<ScreenProductCatalog> createState() {
    return _ScreenProductCatalogState();
  }
}

class _ScreenProductCatalogState extends ConsumerState<ScreenProductCatalog> {

  late final Widget _drawerFilter;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _drawerFilter = const Drawer(
      width: 400,
      child: DrawerSharing(),
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _drawerFilter,
      appBar: AppBar(
        title: Row(
          children: [SizedBox(width: 36,child: Icon(MdiIcons.fromString("domain"),),), const Expanded(child: Text("Catálogo de Productos"))],
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16),
        actionsIconTheme: const IconThemeData(color: Colors.yellow, opacity: 0.75),
        actions: [
          Visibility(
            visible: ref.watch(productSharingProvider).isNotEmpty,
            child: IconButton(
              onPressed: (){
                _scaffoldKey.currentState!.openEndDrawer();
              },
              icon: Icon(MdiIcons.fromString("share-variant")),
              tooltip: "Compartir seleccionados.",
            ),
          ),
          IconButton(
            onPressed: (){
              ref.read(productProvider.notifier).load(Product.clean());
            },
            icon: Icon(MdiIcons.fromString("plus-circle")),
            tooltip: "Insertar un nuevo producto.",
          ),
          IconButton(
            onPressed: (){
              //Actualiza la fecha de sincronización.
              ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
              //Cierra las pantallas abiertas.
              if (ref.read(productProvider)!=null) ref.read(productProvider.notifier).free();
              if (ref.read(productSearchPriceProvider)!=null) ref.read(productSearchPriceProvider.notifier).free();
              if (ref.read(productBillingProvider)!=null) ref.read(productBillingProvider.notifier).free();
              //Refrezca el catálogo de productos.
              ref.read(productCatalogProvider.notifier).refresh();
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
                width: 400,
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: ProductPricesCatalogWidget())
                ],
              ))
            )
        ],
      ),
      bottomNavigationBar: Container(
        decoration: StyleForm.getDecorationContainer(),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Cantidad de productos total: ${ref.read(productCatalogProvider).length} (${(ref.watch(stateManagerProductProvider)!=null) ? ref.watch(stateManagerProductProvider)!.refRows.filterOrOriginalLength : 0} producto/s filtrado/s)", style: StyleForm.getTextStyleListTileSubtitle(),),
            Text("Ultima actualización: ${ref.watch(lastUpdateProvider)}", style: StyleForm.getTextStyleListTileSubtitle())
          ],
        ),
      )
    );
  }
}