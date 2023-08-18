import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:mailto/mailto.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_catalog_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_search_provider.dart';
import 'package:url_launcher/url_launcher.dart';

@immutable
///DistributorCatalogWidget: Widget que permite visualizar el catalogo de distribuidoras.
class DistributorCatalogWidget extends ConsumerStatefulWidget {
  const DistributorCatalogWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DistributorCatalogWidgetState();
  }
}

class _DistributorCatalogWidgetState extends ConsumerState<ConsumerStatefulWidget> {


  final List<PlutoColumn> _columns = <PlutoColumn>[
    PlutoColumn(
      title: 'ID',
      field: Distributor.getKeyID(),
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'CUIT',
      field: Distributor.getKeyCUIT(),
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Nombre',
      field: Distributor.getKeyName(),
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Direccion',
      field: Distributor.getKeyAddress(),
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Telefono',
      field: Distributor.getKeyCel(),
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Correo electronico',
      field: Distributor.getKeyEmail(),
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
        title: "IVA",
        field: Distributor.getKeyIVA(),
        type: PlutoColumnType.number()
    ),
    PlutoColumn(
        title: "Página web",
        field: Distributor.getKeyWebsite(),
        type: PlutoColumnType.number()
    )
  ];


  ///DistributorCatalogWidget: Devuelve un listado de los distribuidores.
  Widget _getListDistributor(BuildContext context, List<Distributor> list) {
    //Boton: Carga una ditribuidora al proveedor para que pueda ser editado.
    //ref.read(distributorProvider.notifier).loadDistributor(data.data)

    /*
    onTap: () {
                bool isError = false;
                ref.read(distributorRemoveProvider.notifier).loadDistributor(data.data);

                //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
                AsyncValue<Response> response = ref.watch(
                  removeDistributorWithAPIProvider,
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
                    description:  const Text("La información de la distribuidora fue eliminada con éxito.")
                  ).show(context);

                  ref.read(distributorRemoveProvider.notifier).freeDistributor(ref);
                }
                else{
                  //Caso contrario, mostrar notificación de error.
                  ElegantNotification.error(
                    title:  const Text("Error"),
                    description:  const Text("Ocurrió un error y no fue posible eliminar la información de la distribuidora.")
                  ).show(context);
                }
              },
            );
     */
    List<PlutoRow> rows = list.map((e){
      return PlutoRow(
        cells: {
          Distributor.getKeyID(): PlutoCell(value: e.getID()),
          Distributor.getKeyCUIT(): PlutoCell(value: e.getCUIT()),
          Distributor.getKeyName(): PlutoCell(value: e.getName()),
          Distributor.getKeyAddress(): PlutoCell(value: e.getAddress()),
          Distributor.getKeyCel(): PlutoCell(value: e.getPhone()),
          Distributor.getKeyIVA(): PlutoCell(value: e.getIVA()),
          Distributor.getKeyEmail(): PlutoCell(value: e.getEmail()),
          Distributor.getKeyWebsite(): PlutoCell(value: e.getWebsite()),
        },
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(15),
      child: PlutoGrid(
        columns: _columns,
        rows: rows,
        onChanged: (PlutoGridOnChangedEvent event) {
          print(event);
        },
        configuration: const PlutoGridConfiguration(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Distributor> list = ref.watch(distributorCatalogProvider);
    return _getListDistributor(context, list);
  }
}