import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/crud_product_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_products_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/container_style.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/config/pluto_config.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/triple.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_brands_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/toggle/toggle_notifier.dart';
//import 'package:url_launcher/url_launcher.dart';

///ProductMySQLCatalogWidget: Widget que permite visualizar el catalogo de productos a importar de MySQL.
class ProductMySQLCatalogWidget extends ConsumerStatefulWidget {
  const ProductMySQLCatalogWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductMySQLCatalogWidgetState();
  }
}

class _ProductMySQLCatalogWidgetState extends ConsumerState<ConsumerStatefulWidget> {
  //Atributos de instancia
  final List<PlutoColumn> _columns = [];
  final List<PlutoRow> _rows = [];

  @override
  initState(){
    super.initState();
    //Agrega las columnas
    _columns.addAll(PlutoConfig.getPlutoColumnsProduct(
      options: PlutoColumn(
        cellPadding: EdgeInsets.zero,
        title: "",
        field: "p_options",
        type: PlutoColumnType.text(defaultValue: ""),
        enableRowChecked: true,
        width: 65,
        minWidth: 65,
        renderer: (rendererContext) => const Text(""),
      ),
    ));
    //Agrega las filas.
    _rows.addAll(ref.read(importProductMySQLProvider).map((e){
      return e.getValue1().getPlutoRow()!;
    }).toList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerStyle.getContainerRoot(),
      child: Column(
        children: [
          HeaderInformationWidget(
            titleHeader: "Productos disponibles (Sistema v2)",
            tooltipClose: "Cerrar tabla.",
            onClose: (){
              ref.read(showImportProductsMySQL.notifier).toggle();
            },
            onButton: IconButton(
              onPressed: () async {
                if (ref.watch(catalogProductsImportProvider).isNotEmpty){
                  ResponseAPI response = await ref.read(importProductWithAPIProvider.future);

                  if (context.mounted){
                    ElegantNotificationCustom.showNotificationAPI(context, response);
                    if (response.isResponseSuccess()) {
                      await ref.read(productCatalogProvider.notifier).refresh();
                      ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
                      await ref.read(importProductMySQLProvider.notifier).refresh();
                      await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
                      await ref.read(notifyImportsProvider.future);
                    }
                  }
                }
              },
              icon: const Icon(Icons.download, color: Colors.yellow,),
            ),
            isButtonVisible: ref.watch(catalogProductsImportProvider).isNotEmpty,
            tooltipCustom: "Importar todos los productos seleccionados.",
          ),
          Expanded(
            child: PlutoGrid(
              key: GlobalKey(),
              mode: PlutoGridMode.popup,
              columns: _columns,
              rows: _rows,
              onLoaded: (event) {
                if (context.mounted){
                  ref.read(stateManagerProductMySQLProvider.notifier).load(event.stateManager);
                }
              },
              //Si se selecciona/deselecciona la casilla checked.
              onRowChecked:(event) {//Si no se seleccionó todos los elementos.
                if (event.isChecked==null){
                  return;
                }

                if (event.isAll){
                  //Obtengo las filas filtradas.
                  List<PlutoRow> listRow = ref.read(stateManagerProductMySQLProvider)?.refRows ?? [];

                  for (PlutoRow row in listRow){
                    //Se recupera el producto en cuestion.
                    Triple<Product, Distributor, double> triple = _getTripleData(row);
                    if (event.isChecked==true){
                      ref.read(catalogProductsImportProvider.notifier).insert(triple);
                    }
                    else{
                      ref.read(catalogProductsImportProvider.notifier).remove(triple);
                    }
                  }
                }
                else{
                  //Si la fila no es nula.
                  if (event.row!=null){
                    //Se recupera el producto en cuestion.
                    Triple<Product, Distributor, double> triple = _getTripleData(event.row!);
                    print("object");
                    //Se notifica al catalogo de acuerdo
                    if (ref.watch(catalogProductsImportProvider).contains(triple)){
                      ref.read(catalogProductsImportProvider.notifier).remove(triple);
                    }
                    else{
                      ref.read(catalogProductsImportProvider.notifier).insert(triple);
                    }
                  }
                }
                try{

                }
                catch(e){
                  print("Error: $e");
                }
              },
              configuration: PlutoConfig.getConfiguration(),
            ),
          )
        ],
      ),
    );
  }

  
  Triple<Product, Distributor, double> _getTripleData(PlutoRow row){
    int rowID = row.cells[Product.getKeyID()]!.value;
    return ref.read(importProductMySQLProvider).firstWhere((element) => element.getValue1().getID()==rowID);
  }
}