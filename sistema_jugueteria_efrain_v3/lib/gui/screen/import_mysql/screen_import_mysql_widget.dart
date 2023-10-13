import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_distributor_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/drawer/drawer_login_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/import_mysql/catalog/distributor_mysql_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/import_mysql/catalog/product_mysql_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/container_style.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/mixin_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
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
            onPressed: () async{
              //Refrezca el catálogo de productos.
              await ref.read(importDistributorMySQLProvider.notifier).refresh();
            },
            icon: Icon(MdiIcons.fromString("reload")),
            tooltip: "Recargar catálogo.",
          ),
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
          Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: getMarginInformationForms(),
                    decoration: StyleForm.getDecorationContainer(),
                    child: ListTile(
                      title: Text("Importación de distribuidoras", style: StyleForm.getTextStyleListTileTitle(),),
                      trailing: IconButton(
                        tooltip: "Muestra/oculta las distribuidoras a importar.",
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: (){
                          ref.read(showImportDistributorsMySQL.notifier).toggle();
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: getMarginInformationForms(),
                    decoration: StyleForm.getDecorationContainer(),
                    child: ListTile(
                      title: Text("Importación de productos", style: StyleForm.getTextStyleListTileTitle(),),
                      trailing: IconButton(
                        tooltip: "Muestra/oculta los productos a importar.",
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: (){
                          ref.read(showImportProductsMySQL.notifier).toggle();
                        },
                      ),
                    ),
                  )
                ],
              )
          ),
          Expanded(
              child: Column(
                children: [
                  Visibility(
                    visible: ref.watch(showImportDistributorsMySQL),
                    child: Expanded(
                        child: Container(
                          margin: getMarginInformationForms(),
                          decoration: ContainerStyle.getContainerRoot(),
                          child: const DistributorMySQLCatalogWidget(),
                        )
                    ),
                  ),
                  Visibility(
                    visible: ref.watch(showImportProductsMySQL),
                    child: Expanded(
                        child: Container(
                          margin: getMarginInformationForms(),
                          decoration: ContainerStyle.getContainerRoot(),
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