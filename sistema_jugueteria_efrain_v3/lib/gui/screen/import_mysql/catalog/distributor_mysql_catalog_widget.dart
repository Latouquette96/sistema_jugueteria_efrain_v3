import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/crud_distributor_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_distributor_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/container_style.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/config/pluto_config.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/catalog_distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/toggle/toggle_notifier.dart';

///DistributorMySQLCatalogWidget: Widget que permite visualizar el catalogo de distribuidoras a importar de MySQL.
class DistributorMySQLCatalogWidget extends ConsumerStatefulWidget {
  const DistributorMySQLCatalogWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DistributorMySQLCatalogWidgetState();
  }
}

class _DistributorMySQLCatalogWidgetState extends ConsumerState<ConsumerStatefulWidget> {
  //Atributos de instancia
  final List<PlutoColumn> _columns = [];
  final List<PlutoRow> _rows = [];

  @override
  initState(){
    super.initState();
    //Agrega las columnas
    _columns.addAll(PlutoConfig.getPlutoColumnsDistributor(
      options: PlutoColumn(
        hide: true,
        cellPadding: EdgeInsets.zero,
        title: "",
        field: "key_options",
        type: PlutoColumnType.text(defaultValue: ""),
        enableRowChecked: false,
        width: 65,
        minWidth: 65,
        renderer: (rendererContext) => const Text(""),
      ),
    ));
    //Agrega las filas.
    _rows.addAll(ref.read(importDistributorMySQLProvider).isEmpty ? [] : ref.read(importDistributorMySQLProvider).map((e){
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
      decoration: ContainerStyle.getContainerRoot(),
      child: Column(
        children: [
          HeaderInformationWidget(
            titleHeader: "Distribuidoras disponibles (Sistema v2)",
            tooltipClose: "Cerrar tabla.",
            onClose: (){
              ref.read(showImportDistributorsMySQL.notifier).toggle();
            },
            onCustom: ref.watch(importDistributorMySQLProvider).isNotEmpty
                ? () async {
                    ResponseAPI response;
                    response = await ref.read(importDistributorWithAPIProvider.future);

                    if (context.mounted){
                      ElegantNotificationCustom.showNotificationAPI(context, response);
                      if (response.isResponseSuccess()){
                        await ref.read(catalogDistributorProvider.notifier).refresh();
                        ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
                        await ref.read(importDistributorMySQLProvider.notifier).refresh();
                        ref.read(notifyImportsProvider.future);
                      }
                    }
                  }
                : null,
            iconCustom: Icons.download,
            tooltipCustom: "Importar todas las distribuidoras.",
          ),
          Expanded(
            child: PlutoGrid(
              key: GlobalKey(),
              mode: PlutoGridMode.popup,
              columns: _columns,
              rows: _rows,
              onLoaded: (event) {
                if (context.mounted){
                  ref.read(stateManagerDistributorMySQLProvider.notifier).load(event.stateManager);
                }
              },
              configuration: PlutoConfig.getConfiguration(),
            ),
          )
        ],
      ),
    );
  }
}