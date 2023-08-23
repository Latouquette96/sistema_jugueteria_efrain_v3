import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/configuration/pluto_configuration.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pdf_view/pdf_view_controller_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/pluto_row_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/state_manager_provider.dart';
//import 'package:url_launcher/url_launcher.dart';

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
    _columns.addAll(<PlutoColumn>[
      PlutoColumn(
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
                  tooltip: "Buscar en el PDF",
                  onPressed: (){
                    if ( ref.read(productSearchPDFPriceProvider)!=null){
                      ref.read(plutoRowPDFProvider.notifier).free();
                      ref.read(productSearchPDFPriceProvider.notifier).free();
                    }
                    else{
                      //Busca el producto de acuerdo a la fila.
                      Product product = _getProductForRendererContext(rendererContext);
                      ///Carga un producto al proveedor para que pueda ser editado.
                      ref.read(plutoRowPDFProvider.notifier).load(rendererContext.row);
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
      PlutoColumn(
        hide: true,
        title: 'ID',
        field: Product.getKeyID(),
        enableEditingMode: false,
        width: 75,
        minWidth: 75,
        type: PlutoColumnType.number(
          format: "#"
        ),
        readOnly: true
      ),
      PlutoColumn(
        title: 'Barcode',
        enableEditingMode: false,
        width: 150,
        minWidth: 150,
        field: Product.getKeyBarcode(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Cód. Int.',
        enableEditingMode: false,
        width: 100,
        minWidth: 100,
        field: Product.getKeyInternalCode(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Titulo',
        enableEditingMode: false,
        field: Product.getKeyTitle(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Marca/Importador',
        enableEditingMode: false,
        field: Product.getKeyBrand(),
        type: PlutoColumnType.select(
          enableColumnFilter: true,
          ref.read(filterOfLoadedBrandsWithAPIProvider),
          defaultValue: "IMPORT."
        ),
      ),
      PlutoColumn(
        enableEditingMode: false,
        title: 'Categoria > Subcategoria',
        field: Product.getKeyCategory(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableEditingMode: false,
        title: "Stock",
        field: Product.getKeyStock(),
        type: PlutoColumnType.number(
          format: "#"
        ),
        width: 100,
        minWidth: 100,
      ),
      PlutoColumn(
        enableEditingMode: false,
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
    _rows.addAll(ref.read(productCatalogPDFProvider).map((e){
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
        onLoaded: (event) {
          if (context.mounted){
            ref.read(stateManagerProductPricePDFProvider.notifier).load(event.stateManager);
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

  Product _getProduct(PlutoRow row){
    int rowID = row.cells[Product.getKeyID()]!.value;
    return ref.read(productCatalogPDFProvider).firstWhere((element) => element.getID()==rowID);
  }

  ///
  Product _getProductForRendererContext(PlutoColumnRendererContext rendererContext){
    PlutoRow row = rendererContext.row;
    return _getProduct(row);
  }
}