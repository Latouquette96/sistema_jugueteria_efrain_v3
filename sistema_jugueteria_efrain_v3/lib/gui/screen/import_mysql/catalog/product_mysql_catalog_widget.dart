import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/config/pluto_config.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/fourfold.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_product_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/selected_items_provider.dart';

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
        width: 100,
        minWidth: 100,
        renderer: (rendererContext) => const Text(""),
        //Footer que contabiliza las filas checkeadas
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.count,
            format: 'Checked : #,###.###',
            filter: (cell) => cell.row.checked == true,
            alignment: Alignment.center,
          );
        },
      ),
    ));
    //Agrega las filas.
    _rows.addAll(StateManagerProductMySQL.getInstance().getElements().map((e){
      return e.getValue1().getPlutoRow();
    }).toList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PlutoGrid(
      key: GlobalKey(),
      mode: PlutoGridMode.selectWithOneTap,
      columns: _columns,
      rows: _rows,
      onChanged: (PlutoGridOnChangedEvent event){
        StateManagerProductMySQL.getInstance().getStateManager()!.notifyListeners();
      },
      onLoaded: (event) {
        if (context.mounted){
          StateManagerProductMySQL.getInstance().loadStateManager(event.stateManager);
        }
      },
      //Si se selecciona/deselecciona la casilla checked.
      onRowChecked:(event) {//Si no se seleccionó todos los elementos.
        if (event.isChecked==null){
          return;
        }

        if (event.isAll){
          int total = StateManagerProductMySQL.getInstance().getElements().length;
          if (event.isChecked==true){
            int isChecked = StateManagerProductMySQL.getInstance().getStateManager()!.checkedRows.length;
            if (total==isChecked){
              ref.read(catalogProductsImportProvider.notifier).insertMultiple(StateManagerProductMySQL.getInstance().getElements());
            }
            else{
              List<Fourfold<Product, Distributor, double, String>> list = StateManagerProductMySQL.getInstance().getStateManager()!.checkedRows.map((e) => _getFourfoldData(e)!).toList();
              ref.read(catalogProductsImportProvider.notifier).insertMultiple(list);
            }
          }
          else{
            ref.read(catalogProductsImportProvider.notifier).removeAll();
          }
        }
        else{
          //Si la fila no es nula.
          if (event.row!=null){
            //Se recupera el producto en cuestion.
            Fourfold<Product, Distributor, double, String>? fourfold = _getFourfoldData(event.row!);
            //Se notifica al catalogo de acuerdo
            if (fourfold!=null){
              if (ref.read(catalogProductsImportProvider).contains(fourfold)){
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
    );
  }

  
  Fourfold<Product, Distributor, double, String>? _getFourfoldData(PlutoRow row){
    int rowID = row.cells[Product.getKeyID()]!.value;
    if (rowID!=0){
      return StateManagerProductMySQL.getInstance().getElements().firstWhere((element) => element.getValue1().getID()==rowID);
    }
    else{
      String rowBarcode = row.cells[Product.getKeyBarcode()]!.value;
      if (rowBarcode!="-"){
        return StateManagerProductMySQL.getInstance().getElements().firstWhere((element) => element.getValue1().getBarcode()==rowBarcode);
      }
      else{
        return null;
      }
    }
  }
}
