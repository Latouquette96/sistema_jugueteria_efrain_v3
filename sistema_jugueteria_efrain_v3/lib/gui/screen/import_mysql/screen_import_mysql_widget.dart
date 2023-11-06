import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_distributor_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_products_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/drawer/drawer_login_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/import_mysql/catalog/distributor_mysql_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/import_mysql/catalog/product_mysql_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/mixin_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_list_tile.dart';

import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/catalog_distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/toggle/toggle_notifier.dart';

///Clase ScreenImportProductWidget: Modela un catálogo de productos provenientes de MySQL.
class ScreenImportProductWidget extends ConsumerStatefulWidget {
  const ScreenImportProductWidget({super.key});

  @override
  ConsumerState<ScreenImportProductWidget> createState() {
    return _ScreenImportProductWidgetState();
  }
}

class _ScreenImportProductWidgetState extends ConsumerState<ScreenImportProductWidget> with ContainerParameters {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        title: Row(
          children: [SizedBox(width: 36,child: Icon(MdiIcons.fromString("domain"),),), const Expanded(child: Text("Importación de información (Sistema v2)"))],
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16),
        actionsIconTheme: const IconThemeData(color: Colors.yellow, opacity: 0.75),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            icon: const Icon(Icons.login),
            tooltip: "Login.",
          ),
        ],
      ),
      endDrawer: const Drawer(
        child: DrawerLoginMySQL(),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 500,
            child:  ListView(
              children: [
                Container(
                  margin: getMarginInformationForms(),
                  decoration: StyleContainer.getDecoration(),
                  child: ListTile(
                    title: Text("Importación de distribuidoras", style: StyleListTile.getTextStyleTitle(),),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text("• Distribuidoras nuevas/modificadas (Sistema v2): ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey.shade900),),
                            Text(ref.watch(importDistributorMySQLProvider).length.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.blue.shade800),)
                          ],
                        ),
                        Row(
                          children: [
                            Text("• Distribuidoras en el Sistema actual: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey.shade900),),
                            Text(ref.watch(catalogDistributorProvider).length.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.blue.shade800),)
                          ],
                        )
                      ],
                    ),
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            tooltip: "Refrescar el listado de distribuidoras a importar.",
                            icon: Icon(Icons.update, color: Colors.blue.shade700,),
                            onPressed: () async{
                              //Refrescar el catálogo de productos.
                              ResponseAPI response = await ref.read(importDistributorMySQLProvider.notifier).refresh();
                              if (mounted){
                                ElegantNotificationCustom.showNotificationAPI(context, response);
                              }
                            },
                          ),
                          IconButton(
                            tooltip: "Muestra/oculta las distribuidoras a importar.",
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: (){
                              ref.read(showImportDistributorsMySQL.notifier).toggle();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: getMarginInformationForms(),
                  decoration: StyleContainer.getDecoration(),
                  child: ListTile(
                    title: Text("Importación de productos", style: StyleListTile.getTextStyleTitle(),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("• Productos nuevos/modificados (Sistema v2): ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey.shade900),),
                            Text(ref.watch(importProductMySQLProvider).length.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.blue.shade800),),
                          ],
                        ),
                        Row(
                          children: [
                            Text("• Productos en el Sistema actual: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey.shade900),),
                            Text(ref.watch(productCatalogProvider).length.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.blue.shade800),)
                          ],
                        )
                      ],
                    ),
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            tooltip: "Refrescar el listado de productos a importar.",
                            icon: Icon(Icons.update, color: Colors.blue.shade700,),
                            onPressed: () async{
                              //Refrescar el catálogo de productos.
                              ResponseAPI response = await ref.read(importProductMySQLProvider.notifier).refresh();
                              if (mounted){
                                ElegantNotificationCustom.showNotificationAPI(context, response);
                              }
                            },
                          ),
                          IconButton(
                            tooltip: "Muestra/oculta el listado de productos a importar.",
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: (){
                              ref.read(showImportProductsMySQL.notifier).toggle();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Column(
                children: [
                  Visibility(
                    visible: ref.watch(showImportDistributorsMySQL),
                    child: Expanded(
                        child: Container(
                          margin: getMarginInformationForms(),
                          decoration: StyleContainer.getContainerRoot(),
                          child: const DistributorMySQLCatalogWidget(),
                        )
                    ),
                  ),
                  Visibility(
                    visible: ref.watch(showImportProductsMySQL),
                    child: Expanded(
                        child: Container(
                          margin: getMarginInformationForms(),
                          decoration: StyleContainer.getContainerRoot(),
                          child: const ProductMySQLCatalogWidget(),
                        )
                    ),
                  ),
                ]
              )
          )
        ],
      )
    );
  }
}