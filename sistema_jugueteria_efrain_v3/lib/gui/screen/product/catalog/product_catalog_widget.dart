import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/config/pluto_config.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_sharing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_row_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';

///ProductCatalogWidget: Widget que permite visualizar el catalogo de productos.
class ProductCatalogWidget extends ConsumerStatefulWidget {
  const ProductCatalogWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductCatalogWidgetState();
  }
}

class _ProductCatalogWidgetState extends ConsumerState<ConsumerStatefulWidget> {
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
        title: "Opciones",
        field: "p_options",
        type: PlutoColumnType.text(),
        enableRowChecked: true,
        width: 100,
        minWidth: 100,
        renderer: (rendererContext) {
          return Row(
            children: [
              //IconButton para mostrar informacion del producto.
              Expanded(child:
                IconButton(
                  onPressed: () async{
                    if (ref.read(productProvider)==null){
                      //Busca el producto de acuerdo a la fila.
                      Product product = _getProductForRendererContext(rendererContext);
                      ///Carga un producto al proveedor para que pueda ser editado.
                      ref.read(plutoRowProvider.notifier).load(rendererContext.row);
                      ref.read(productProvider.notifier).load(product);
                      await ref.read(productPricesByIDProvider.notifier).refresh();
                    }
                    else{
                      ref.read(plutoRowProvider.notifier).free();
                      ref.read(productProvider.notifier).free();
                    }
                  },
                  icon: Icon(MdiIcons.fromString("pencil"), color: Colors.black,)
              )
              ),
              //IconButton para eliminar al producto.
              Expanded(child:
              IconButton(
                  onPressed: () async {
                    //Busca el producto de acuerdo a la fila.
                    Product product = _getProductForRendererContext(rendererContext);
                    //Elimina el producto.
                    await _remove(product);
                  },
                  icon: Icon(MdiIcons.fromString("delete"), color: Colors.redAccent,)
              )
              ),
            ],
          );
        },
      ),
    ));

    //Agrega las filas.
    _rows.addAll(ref.read(productCatalogProvider).map((e){
      return e.getPlutoRow()!;
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
            ref.read(stateManagerProductProvider.notifier).load(event.stateManager);
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
              ref.read(productSharingProvider.notifier).insertAll();
            }
            else{
              ref.read(productSharingProvider.notifier).removeAll();
            }
          }
          else{
            //Si la fila no es nula.
            if (event.row!=null){
                //Se recupera el producto en cuestion.
                Product product = _getProduct(event.row!);
                //Se notifica al catalogo de acuerdo 
                if (ref.read(productSharingProvider.notifier).contains(product)){
                  ref.read(productSharingProvider.notifier).remove(product);
                }
                else{
                  ref.read(productSharingProvider.notifier).insert(product);
                }
            } 
          }
        },
        configuration: PlutoConfig.getConfiguration(),
      ),
    );
  }

  ///ProductCatalogWidget: Remueve el producto.
  Future<void> _remove(Product product) async{
    ref.read(productRemoveProvider.notifier).load(product);
    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
    ResponseAPI response = await ref.read(removeProductWithAPIProvider.future);

    if (mounted){
      ElegantNotificationCustom.showNotificationAPI(context, response);

      if (response.isResponseSuccess()){
        ref.read(stateManagerProductProvider)!.removeRows([ref.read(productRemoveProvider)!.getPlutoRow()!]);
        ref.read(productRemoveProvider.notifier).free();
      }
    }
  }

  ///ProductCatalogWidget: Devuelve el producto almacenado en la fila.
  Product _getProduct(PlutoRow row){
    int rowID = row.cells[Product.getKeyID()]!.value;
    return ref.read(productCatalogProvider).firstWhere((element) => element.getID()==rowID);
  }

  ///ProductCatalogWidget: Devuelve el producto renderizado.
  Product _getProductForRendererContext(PlutoColumnRendererContext rendererContext){
    PlutoRow row = rendererContext.row;
    return _getProduct(row);
  }
}