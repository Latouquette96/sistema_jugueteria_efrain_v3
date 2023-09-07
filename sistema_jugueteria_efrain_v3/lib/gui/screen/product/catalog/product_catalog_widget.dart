import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/configuration/pluto_configuration.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_sharing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/pluto_row_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/pluto_grid_state_manager_provider.dart';
//import 'package:url_launcher/url_launcher.dart';

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
    _columns.addAll(<PlutoColumn>[
      PlutoColumn(
        cellPadding: EdgeInsets.zero,
        title: "Opciones", 
        field: "p_options", 
        type: PlutoColumnType.text(),
        enableRowChecked: true,
        width: 150,
        minWidth: 150,
        renderer: (rendererContext) {
          return Row(
            children: [
              //IconButton para mostrar precios de producto.
              Expanded(child: 
                IconButton(
                  onPressed: (){
                    if ( ref.read(productSearchPriceProvider)!=null){
                      ref.read(productSearchPriceProvider.notifier).free();
                    }
                    else{
                      //Busca el producto de acuerdo a la fila.
                      Product product = _getProductForRendererContext(rendererContext);
                      ///Carga un producto al proveedor para que pueda ser editado.
                      ref.read(plutoRowProvider.notifier).load(rendererContext.row);
                      ///Carga un producto para que pueda ser desplegado el catalogo de precios.
                      ref.read(productSearchPriceProvider.notifier).load(product);
                      ref.read(productPricesByIDProvider.notifier).refresh();
                    }
                  }, 
                  icon: Icon(MdiIcons.fromString("cash"), color: Colors.green)
                )
              ),
              //IconButton para mostrar informacion del producto.
              Expanded(child: 
                IconButton(
                  onPressed: (){
                    if (ref.read(productProvider)==null){
                      //Busca el producto de acuerdo a la fila.
                      Product product = _getProductForRendererContext(rendererContext);
                      ///Carga un producto al proveedor para que pueda ser editado.
                      ref.read(plutoRowProvider.notifier).load(rendererContext.row);
                      ref.read(productProvider.notifier).load(product);
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
      PlutoColumn(
        hide: true,
        title: 'ID',
        field: Product.getKeyID(),
        width: 75,
        minWidth: 75,
        type: PlutoColumnType.number(
          format: "#"
        ),
        readOnly: true
      ),
      PlutoColumn(
        title: 'Barcode',
        width: 150,
        minWidth: 150,
        field: Product.getKeyBarcode(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Cód. Int.',
        width: 100,
        minWidth: 100,
        field: Product.getKeyInternalCode(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Titulo',
        field: Product.getKeyTitle(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Marca/Importador',
        field: Product.getKeyBrand(),
        type: PlutoColumnType.select(
          enableColumnFilter: true,
          ref.read(filterOfLoadedBrandsWithAPIProvider),
          defaultValue: "IMPORT."
        ),
      ),
      PlutoColumn(
        title: 'Categoria > Subcategoria',
        field: Product.getKeyCategory(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Stock",
        field: Product.getKeyStock(),
        type: PlutoColumnType.number(
          format: "#"
        ),
        width: 100,
        minWidth: 100,
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
      )
    ]);
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

  Future<void> _remove(Product product) async{
    bool isError = false;
    ref.read(productRemoveProvider.notifier).load(product);
    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
    AsyncValue<Response> response = ref.watch(
      removeProductWithAPIProvider,
    );
    //Realiza la peticion de eliminacion y analiza la respuesta obtenida.
    response.when(
      data: (data){
        isError = false;
      },
      error: (err, stack){
        isError = true;
      },
      loading: (){null;}
    );
    //Si no ocurre error, entonces se procede a notificar del éxito de la operación y a cerrar el widget.
    if (isError==false){
      ElegantNotification.success(
        title:  const Text("Información"),
        description:  const Text("La información de la producto fue eliminada con éxito.")
      ).show(context);

      ref.read(stateManagerProductProvider)!.removeRows([ref.read(productRemoveProvider)!.getPlutoRow()!]);
      ref.read(productRemoveProvider.notifier).free();
    }
    else{
      //Caso contrario, mostrar notificación de error.
      ElegantNotification.error(
        title:  const Text("Error"),
        description:  const Text("Ocurrió un error y no fue posible eliminar la información del producto.")
      ).show(context);
    }
  }

  Product _getProduct(PlutoRow row){
    int rowID = row.cells[Product.getKeyID()]!.value;
    return ref.read(productCatalogProvider).firstWhere((element) => element.getID()==rowID);
  }

  ///
  Product _getProductForRendererContext(PlutoColumnRendererContext rendererContext){
    PlutoRow row = rendererContext.row;
    return _getProduct(row);
  }
}