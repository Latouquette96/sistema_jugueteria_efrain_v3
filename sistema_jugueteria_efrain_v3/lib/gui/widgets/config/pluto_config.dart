import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/configuration/pluto_configuration.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';

///Clase PlutoConfig: Modela un "estandar" para todos los PlutoGrid del proyecto.
class PlutoConfig {

  ///PlutoConfig: Devuelve la configuración por defecto de todos los PlutoGrid.
  static PlutoGridConfiguration getConfiguration(){
    return PlutoGridConfiguration(
        columnSize: const PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale),
        localeText: PlutoConfiguration.getPlutoGridLocaleText(),
        columnFilter: PlutoGridColumnFilterConfig(
            filters: const [
              ... FilterHelper.defaultFilters,
            ],
            resolveDefaultColumnFilter: (column, resolver){
              if (column.field == 'text') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              }
              else if (column.field == 'number') {
                return resolver<PlutoFilterTypeGreaterThan>() as PlutoFilterType;
              }
              else if (column.field == 'date') {
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
    );
  }

  ///PlutoConfig: Devuelve la estructura general de las columnas de un PlutoGrid para productos.
  static List<PlutoColumn> getPlutoColumnsProduct({
    required PlutoColumn options
  }){
    return [
      options,
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
        //Footer que contabiliza las filas checkeadas
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.count,
            format: '#,###.### productos',
            alignment: Alignment.center,
          );
        },
      ),
      PlutoColumn(
        title: 'Titulo',
        enableEditingMode: false,
        minWidth: 500,
        width: 500,
        suppressedAutoSize: true,
        field: Product.getKeyTitle(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Marca/Importador',
        enableEditingMode: false,
        field: Product.getKeyBrand(),
        type: PlutoColumnType.text(
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
        //Footer que contabiliza las filas checkeadas
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.sum,
            format: 'Stock: #,###.###',
            alignment: Alignment.center,
          );
        },
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
    ];
  }

  ///PlutoConfig: Devuelve la estructura general de las columnas de un PlutoGrid para productos.
  static List<PlutoColumn> getPlutoColumnsDistributor({
    required PlutoColumn options
  }){
    return [
      options,
      PlutoColumn(
          hide: true,
          title: 'ID',
          field: Distributor.getKeyID(),
          width: 75,
          minWidth: 75,
          type: PlutoColumnType.number(
              format: "#"
          ),
          readOnly: true
      ),
      PlutoColumn(
        title: 'CUIT',
        width: 150,
        minWidth: 150,
        field: Distributor.getKeyCUIT(),
        type: PlutoColumnType.text(),
        //Footer que contabiliza las filas checkeadas
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.count,
            format: '#,###.### distribuidoras',
            alignment: Alignment.center,
          );
        }
      ),
      PlutoColumn(
        title: 'Nombre',
        width: 200,
        minWidth: 100,
        field: Distributor.getKeyName(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Dirección',
        field: Distributor.getKeyAddress(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Teléfono',
        field: Distributor.getKeyCel(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Correo electrónico',
        field: Distributor.getKeyEmail(),
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "IVA",
        field: Distributor.getKeyIVA(),
        type: PlutoColumnType.number(
            format: "#.##"
        ),
        width: 100,
        minWidth: 100,
      ),
      PlutoColumn(
        title: "Website",
        field: Distributor.getKeyWebsite(),
        type: PlutoColumnType.text(),
        width: 150,
        minWidth: 150,
      )
    ];
  }
}