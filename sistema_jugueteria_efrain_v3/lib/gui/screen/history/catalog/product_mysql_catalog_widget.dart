import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/configuration/pluto_configuration.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/state_manager_provider.dart';
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
    _columns.addAll(<PlutoColumn>[
      PlutoColumn(
        title: 'Barcode',
        width: 150,
        minWidth: 150,
        field: Product.getKeyBarcode(),
        type: PlutoColumnType.text(),
        readOnly: true
      ),
      PlutoColumn(
        title: 'Cód. Int.',
        width: 100,
        minWidth: 100,
        field: Product.getKeyInternalCode(),
        type: PlutoColumnType.text(),
        readOnly: true
      ),
      PlutoColumn(
        title: 'Titulo',
        field: Product.getKeyTitle(),
        type: PlutoColumnType.text(),
        readOnly: true
      ),
      PlutoColumn(
        title: 'Marca/Importador',
        field: Product.getKeyBrand(),
        type: PlutoColumnType.text(
          defaultValue: "IMPORT."
        ),
        readOnly: true
      ),
      PlutoColumn(
        title: 'Categoria > Subcategoria',
        field: Product.getKeyCategory(),
        type: PlutoColumnType.text(),
        readOnly: true
      ),
      PlutoColumn(
        title: "Stock",
        field: Product.getKeyStock(),
        type: PlutoColumnType.number(
          format: "#"
        ),
        width: 100,
        minWidth: 100,
        readOnly: true
      ),
      PlutoColumn(
        title: "Precio Público",
        field: Product.getKeyPricePublic(),
        type: PlutoColumnType.number(
          negative: false,
          applyFormatOnInit: true,
        ),
        width: 150,
        minWidth: 150,
        readOnly: true
      )
    ]);
    //Agrega las filas.
    _rows.addAll(ref.read(importProductMySQLProvider).map((e){
      return e.getPlutoRow();
    }).toList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: PlutoGrid(
        mode: PlutoGridMode.popup,
        columns: _columns,
        rows: _rows,
        onLoaded: (event) {
          if (context.mounted){
            ref.read(stateManagerProductMySQLProvider.notifier).load(event.stateManager);
          }
        },
        //Si se selecciona/deselecciona la casilla checked.
        onRowChecked:(event) {
          //Si no se seleccionó todos los elementos.
          if (event.isChecked==null){
            return;
          }

          if (event.isAll){
            if (event.isChecked==true){
              //ref.read(productSharingProvider.notifier).insertAll();
            }
            else{
              //ref.read(productSharingProvider.notifier).removeAll();
            }
          }
          else{
            //Si la fila no es nula.
            if (event.row!=null){ /*
                //Se recupera el producto en cuestion.
                Product product = _getProduct(event.row!);
                //Se notifica al catalogo de acuerdo 
                if (ref.read(productSharingProvider.notifier).contains(product)){
                  ref.read(productSharingProvider.notifier).remove(product);
                }
                else{
                  ref.read(productSharingProvider.notifier).insert(product);
                } */
            } 
          }
        },
        configuration: PlutoGridConfiguration(
            localeText: PlutoConfiguration.getPlutoGridLocaleText(),
            columnFilter: PlutoGridColumnFilterConfig(
              filters: const [
                ... FilterHelper.defaultFilters,
              ],
              resolveDefaultColumnFilter: (column, resolver){
                if (column.field == 'text') {
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                } else if (column.field == 'number') {
                  return resolver<PlutoFilterTypeGreaterThan>()
                  as PlutoFilterType;
                } else if (column.field == 'date') {
                  return resolver<PlutoFilterTypeLessThan>() as PlutoFilterType;
                }
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              }
            ),
            scrollbar: const PlutoGridScrollbarConfig(
              isAlwaysShown: true,
              scrollbarThickness: 8,
              scrollbarThicknessWhileDragging: 10,
            ),
            enterKeyAction: PlutoGridEnterKeyAction.none,
            style: PlutoGridStyleConfig(
              rowHeight: 37.5,
              enableGridBorderShadow: true,
              evenRowColor: Colors.blueGrey.shade50,
              oddRowColor: Colors.blueGrey.shade100,
              activatedColor: Colors.lightBlueAccent.shade100,
              cellColorInReadOnlyState: Colors.grey.shade300
            )
        ),
      ),
    );
  }
}