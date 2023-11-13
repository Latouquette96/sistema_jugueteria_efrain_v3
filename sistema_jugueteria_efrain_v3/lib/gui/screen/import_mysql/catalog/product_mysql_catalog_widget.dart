import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/crud_product_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_products_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/config/pluto_config.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/fourfold.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_brands_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_product.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';
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
      return e.getValue1().getPlutoRow();
    }).toList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: StyleContainer.getContainerRoot(),
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
                      await StateManagerProduct.getInstanceProduct().refresh(ref.read(urlAPIProvider));
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
                    Fourfold<Product, Distributor, double, String>? fourfold = _getFourfoldData(row);
                    if (fourfold!=null){
                      if (event.isChecked==true){
                        ref.read(catalogProductsImportProvider.notifier).insert(fourfold);
                      }
                      else{
                        ref.read(catalogProductsImportProvider.notifier).remove(fourfold);
                      }
                    }
                  }
                }
                else{
                  //Si la fila no es nula.
                  if (event.row!=null){
                    //Se recupera el producto en cuestion.
                    Fourfold<Product, Distributor, double, String>? fourfold = _getFourfoldData(event.row!);
                    //Se notifica al catalogo de acuerdo
                    if (fourfold!=null){
                      if (ref.watch(catalogProductsImportProvider).contains(fourfold)){
                        ref.read(catalogProductsImportProvider.notifier).remove(fourfold);
                      }
                      else{
                        ref.read(catalogProductsImportProvider.notifier).insert(fourfold);
                      } 
                    }
                  }
                }
              },
              configuration: PlutoConfig.getConfiguration(),
            ),
          )
        ],
      ),
    );
  }

  
  Fourfold<Product, Distributor, double, String>? _getFourfoldData(PlutoRow row){
    int rowID = row.cells[Product.getKeyID()]!.value;
    if (rowID!=0){
      return ref.read(importProductMySQLProvider).firstWhere((element) => element.getValue1().getID()==rowID);
    }
    else{
      String rowBarcode = row.cells[Product.getKeyBarcode()]!.value;
      if (rowBarcode!="-"){
        return ref.read(importProductMySQLProvider).firstWhere((element) => element.getValue1().getBarcode()==rowBarcode);
      }
      else{
        return null;
      }
    }
  }
}
