import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/drawer/drawer_sharing.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/catalog/catalog_prueba.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/catalog/product_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_container.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/builder_pdf/builder_pdf.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_singleton.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_sharing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';

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
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        title: Row(
          children: [SizedBox(width: 36,child: Icon(MdiIcons.fromString("domain"),),), const Expanded(child: Text("Catálogo de Productos"))],
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16),
        actionsIconTheme: const IconThemeData(color: Colors.yellow, opacity: 0.75),
        actions: [
          IconButton(
            onPressed: (){
              ref.read(stateManagerProductProvider.notifier).toggleShowColumnFilter();
              setState(() {});
            },
            icon: Icon(
              MdiIcons.fromString("filter"),
              color:  ref.watch(stateManagerProductProvider.notifier).isShowColumnFilter() ? Colors.yellow : Colors.grey,
            ),
            tooltip: "Mostrar/ocultar filtro",
          ),
          Visibility(
            visible: ref.watch(productSharingProvider).isNotEmpty,
            child: IconButton(
              onPressed: () async{
                final response = await BuilderPDF.buildPDF(ref:ref, list: ref.read(productSharingProvider));
                if (context.mounted) ElegantNotificationCustom.showNotificationAPI(context, response);
              },
              icon: Icon(MdiIcons.fromString("file-pdf-box")),
              tooltip: "Generar archivo PDF (productos seleccionados).",
            ),
          ),
          Visibility(
            visible: ref.watch(productSharingProvider).isNotEmpty,
            child: IconButton(
              onPressed: (){
                ref.read(removeSelectedProductWithAPIProvider.future);
              },
              icon: Icon(MdiIcons.fromString("delete"), color: Colors.redAccent,),
              tooltip: "Eliminar productos seleccionados.",
            ),
          ),
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
            onPressed: () async {
              StateManagerSingleton.getInstance().getStateManager()!.removeAllRows();

              //Actualiza la fecha de sincronización.
              ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
              //Cierra las pantallas abiertas.
              if (ref.read(productProvider)!=null) ref.read(productProvider.notifier).free();
              if (ref.read(productBillingProvider)!=null) ref.read(productBillingProvider.notifier).free();

              //Refrezca el catálogo de productos.
              await ref.read(productCatalogProvider.notifier).refresh();

              //Carga el componente con los productos.
              StateManagerSingleton.getInstance().getStateManager()!.insertRows(0, ref.watch(productCatalogProvider).map((e) => e.getPlutoRow()!).toList());
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
            child: const PruebaCatalogWidget(),
          )),
          Visibility(
              visible: ref.watch(productProvider) != null,
              child: const SizedBox(
                width: 1000,
                child: ProductInformationWidget(),
              )
          ),
        ],
      ),
    );
  }
}