import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/config/pluto_config.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pdf_view/pdf_view_controller_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_product.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';

///ProductPricePDFViewCatalogWidget: Widget que permite visualizar el catalogo de productos.
class ProductPricePDFViewCatalogWidget extends ConsumerStatefulWidget {
  const ProductPricePDFViewCatalogWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductPricePDFViewCatalogWidgetState();
  }
}

class _ProductPricePDFViewCatalogWidgetState extends ConsumerState<ConsumerStatefulWidget> {
  //Atributos de instancia
  final List<PlutoColumn> _columns = [];
  final List<PlutoRow> _rows = [];

  @override
  initState(){
    super.initState();
    //Agrega las columnas
    _columns.addAll(PlutoConfig.getPlutoColumnsProduct(
        options: PlutoColumn(
          enableEditingMode: false,
          enableFilterMenuItem: false,
          cellPadding: EdgeInsets.zero,
          title: "",
          field: "p_options",
          type: PlutoColumnType.text(),
          width: 50,
          minWidth: 50,
          renderer: (rendererContext) {
            return Row(
              children: [
                //IconButton para mostrar precios de producto.
                Expanded(child:
                IconButton(
                    onPressed: (){
                      if ( ref.read(productSearchPDFPriceProvider)!=null){
                        ref.read(productSearchPDFPriceProvider.notifier).free();
                      }
                      else{
                        //Busca el producto de acuerdo a la fila.
                        Product product = _getProductForRendererContext(rendererContext);
                        ///Carga un producto al proveedor para que pueda ser editado.
                        ref.read(pdfTextSearchResultProvider.notifier).search(product);
                      }
                    },
                    icon: Icon(MdiIcons.fromString("file-search"), color: Colors.green)
                )
                ),
              ],
            );
          },
        ),
    ));

    //Agrega las filas.
    _rows.addAll(StateManagerProduct.getInstanceProductPDF().getElements().map((e){
      return e.getPlutoRow();
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: PlutoGrid(
        key: GlobalKey(),
        mode: PlutoGridMode.popup,
        columns: _columns,
        rows: _rows,
        onChanged: (PlutoGridOnChangedEvent event){
          StateManagerProduct.getInstanceProductPDF().getStateManager()!.notifyListeners();
        },
        onRowDoubleTap: (event) {
          if ( ref.read(productSearchPDFPriceProvider)!=null){
              ref.read(productSearchPDFPriceProvider.notifier).free();
            }
            else{
              //Busca el producto de acuerdo a la fila.
              Product product = _getProduct(event.row);
              ///Carga un producto al proveedor para que pueda ser editado.
              ref.read(pdfTextSearchResultProvider.notifier).search(product);
            }
        },
        onLoaded: (event) {
          if (context.mounted){
            StateManagerProduct.getInstanceProductPDF().loadStateManager(event.stateManager);
          }
        },
        configuration: PlutoConfig.getConfiguration()
      ),
    );
  }

  Product _getProduct(PlutoRow row){
    int rowID = row.cells[Product.getKeyID()]!.value;
    return StateManagerProduct.getInstanceProductPDF().getElements().firstWhere((element) => element.getID()==rowID);
  }


  Product _getProductForRendererContext(PlutoColumnRendererContext rendererContext){
    PlutoRow row = rendererContext.row;
    return _getProduct(row);
  }
}