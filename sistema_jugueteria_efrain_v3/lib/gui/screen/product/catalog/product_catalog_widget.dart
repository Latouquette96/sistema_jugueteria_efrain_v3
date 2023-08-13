import 'package:davi/davi.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/category_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';
//import 'package:url_launcher/url_launcher.dart';

@immutable
///ProductCatalogWidget: Widget que permite visualizar el catalogo de productos.
class ProductCatalogWidget extends ConsumerStatefulWidget {

  const ProductCatalogWidget({super.key});
  
 @override
  ConsumerState<ProductCatalogWidget> createState() {
    return _ProductCatalogWidgetState();
  }
}

class _ProductCatalogWidgetState extends ConsumerState<ProductCatalogWidget> {

  ///ProductCatalogWidget: Devuelve un listado de los productos.
  Widget _getListProduct(BuildContext context, WidgetRef ref, List<Product> list) {
    DaviModel<Product>? model = DaviModel<Product>(rows: list, columns: [
      //CUIT
      DaviColumn(
          name: 'Cód. de barras',
          stringValue: (row) => "${row.getBarcode()} (Cód. int. ${row.getInternalCode()})",
          width: 150,
          resizable: false,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center),
      //NOMBRE
      DaviColumn(
        name: 'Título',
        stringValue: (Product p) {
          return p.getTitle();
        },
        grow: 40,
        headerAlignment: Alignment.center,
      ),
      //MARCA
      DaviColumn(
          name: 'Marca/Importador',
          stringValue: (Product p) {
            return p.getBrand();
          },
          grow: 30,
          headerAlignment: Alignment.center),
      //Categoria y subcategoria
      DaviColumn(
          name: 'Categoria > Subcategoria',
          stringValue: (Product p) {
            Pair<Category?, SubCategory?> map = FactoryCategory.getInstance().search(p.getSubcategory());
            String texto = "";
            if (map.getValue1()==null){
              texto = "Sin definir";
            }
            else{
              texto = "${map.getValue1()!.getCategoryName()} > ${map.getValue2()!.getSubCategoryName()}";
            }

            return texto;
          },
          grow: 50,
          width: 150,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center),
      //STOCK
      DaviColumn(
          name: 'Stock',
          intValue: (Product p) {
            return p.getStock();
          },
          grow: 30,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center),
      //Precio Público
      DaviColumn(
          name: 'Precio Público',
          doubleValue: (Product p) {
            return p.getPricePublic();
          },
          grow: 20,
          fractionDigits: 2,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center
      ),
      //Opciones
      DaviColumn(
          pinStatus: PinStatus.none,
          width: 40,
          resizable: false,
          cellBuilder: (BuildContext context, DaviRow<Product> data) {
            return InkWell(
              child: const Icon(Icons.edit, color: Colors.green, size: 24),
              onTap: () {
                ///Carga un producto al proveedor para que pueda ser editado.
                ref.read(productProvider.notifier).load(data.data);
              },
            );
          }
      ),
      DaviColumn(
          pinStatus: PinStatus.none,
          width: 40,
          resizable: false,
          cellBuilder: (BuildContext context, DaviRow<Product> data) {
            return InkWell(
              child: Icon(MdiIcons.fromString("cash"), color: Colors.blue.shade600, size: 24),
              onTap: () {
                ///Carga un producto para que pueda ser desplegado el catalogo de precios.
                ref.read(productSearchPriceProvider.notifier).load(data.data);
                ref.read(productPricesByIDProvider.notifier).refresh();
              },
            );
          }
      ),
      DaviColumn(
          pinStatus: PinStatus.none,
          width: 40,
          resizable: false,
          cellBuilder: (BuildContext context, DaviRow<Product> data) {
            return InkWell(
              child: const Icon(
                Icons.remove_circle,
                color: Colors.red,
                size: 24,
              ),
              onTap: () {
                bool isError = false;
                ref.read(productRemoveProvider.notifier).load(data.data);

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

                  ref.read(productRemoveProvider.notifier).free();
                }
                else{
                  //Caso contrario, mostrar notificación de error.
                  ElegantNotification.error(
                    title:  const Text("Error"),
                    description:  const Text("Ocurrió un error y no fue posible eliminar la información del producto.")
                  ).show(context);
                }
              },
            );
          }),
    ]);
    return DaviTheme(
        data: DaviThemeData(
          header: HeaderThemeData(
              color: Colors.black87,
              bottomBorderHeight: 4,
              bottomBorderColor: Colors.blueGrey.shade500),
          headerCell: HeaderCellThemeData(
            height: 40,
            alignment: Alignment.center,
            textStyle: const TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
              fontSize: 12
            ),
            resizeAreaWidth: 10,
            resizeAreaHoverColor: Colors.blue.withOpacity(.5),
            sortIconColors: SortIconColors.all(Colors.orange),
            expandableName: true,
          ),
        ),
        child: Davi<Product>(
            model, 
            rowColor: (DaviRow<Product>? rowData) {
              if (rowData == null) {
                return Colors.white;
              } 
              else {
                return (rowData.index % 2 == 0)
                  ? Colors.blue.shade50
                  : Colors.blueGrey.shade50;
              }
            },
            onRowDoubleTap:(Product data) {
              if (ref.read(productProvider)==null){
                ref.read(productProvider.notifier).load(data);
              }
              else{
                ref.read(productProvider.notifier).free();
              }
            },
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    //Obtiene la lista de productos.
    final listProduct = ref.watch(productCatalogProvider);
    return _getListProduct(context, ref, listProduct);
  }
}