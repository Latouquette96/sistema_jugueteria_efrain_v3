import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/crud_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/import_mysql/catalog/product_mysql_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/container_style.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';

///Clase ScreenImportProductWidget: Modela un catálogo de productos provenientes de MySQL.
class ScreenImportProductWidget extends ConsumerStatefulWidget {
  const ScreenImportProductWidget({super.key});

  @override
  ConsumerState<ScreenImportProductWidget> createState() {
    return _ScreenImportProductWidgetState();
  }
}

class _ScreenImportProductWidgetState extends ConsumerState<ScreenImportProductWidget> {

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
          children: [SizedBox(width: 36,child: Icon(MdiIcons.fromString("domain"),),), const Expanded(child: Text("Importación de Productos de MySQL"))],
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16),
        actionsIconTheme: const IconThemeData(color: Colors.yellow, opacity: 0.75),
        actions: [
          Visibility(
            visible: ref.watch(catalogImportProvider).isNotEmpty,
            child: IconButton(
              onPressed: () async{
                bool success = true;
                try{
                  success = await ref.read(importProductWithAPIProvider.future);
                }
                catch(e){
                  success = false;
                }

                if (context.mounted){
                  (success)
                      ? ElegantNotificationCustom.showNotificationSuccess(context)
                      : ElegantNotificationCustom.showNotificationError(context);
                }

                if (success){
                  ref.read(notifyImportsProvider.future);
                }
              },
              icon: Icon(MdiIcons.fromString("import")),
              tooltip: "Importar productos seleccionados.",
            ),
          ),
          IconButton(
            onPressed: () async{
              //Refrezca el catálogo de productos.
              await ref.read(importProductMySQLProvider.notifier).refresh();
            },
            icon: Icon(MdiIcons.fromString("reload")),
            tooltip: "Recargar catálogo.",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: 
            Container(
              margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              decoration: ContainerStyle.getContainerRoot(),
              child: const ProductMySQLCatalogWidget(),
            )
          )
        ],
      ),
      bottomNavigationBar: Container(
        decoration: StyleForm.getDecorationContainer(),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Cantidad de productos total: ${ref.read(importProductMySQLProvider).length} (${(ref.watch(stateManagerProductMySQLProvider)!=null) ? ref.watch(stateManagerProductMySQLProvider)!.refRows.filterOrOriginalLength : 0} producto/s de MySQL filtrado/s)", style: StyleForm.getTextStyleListTileSubtitle(),)
          ],
        ),
      )
    );
  }
}