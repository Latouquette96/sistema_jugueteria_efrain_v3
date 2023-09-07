import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:mailto/mailto.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/configuration/pluto_configuration.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/pluto_row_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/pluto_grid_state_manager_provider.dart';
import 'package:url_launcher/url_launcher.dart';

///DistributorCatalogWidget: Widget que permite visualizar el catalogo de distribuidoras.
class DistributorCatalogWidget extends ConsumerStatefulWidget {
  const DistributorCatalogWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DistributorCatalogWidgetState();
  }
}

class _DistributorCatalogWidgetState extends ConsumerState<ConsumerStatefulWidget> {

  //Atributos de instancia
  final List<PlutoColumn> _columns = [];
  final List<PlutoRow> _rows = [];

  @override
  void initState() {
    super.initState();

    _columns.addAll(<PlutoColumn>[
      PlutoColumn(
        cellPadding: EdgeInsets.zero,
        title: "Opciones", 
        field: "key_options", 
        type: PlutoColumnType.text(),
        enableRowChecked: true,
        width: 200,
        minWidth: 200,
        renderer: (rendererContext) {
          return Row(
            children: [
              Expanded(child: 
                IconButton(
                  onPressed: (){
                    //Busca el distribuidor de acuerdo a la fila.
                    Distributor distributor = _getDistributorForRendererContext(rendererContext);
                    ///Carga un distribuidor al proveedor para que pueda ser editado.
                    ref.read(plutoRowProvider.notifier).load(rendererContext.row);
                    ref.read(distributorStateProvider.notifier).load(distributor);
                  }, 
                  icon: Icon(MdiIcons.fromString("pencil"), color: Colors.black,)
                )
              ),
              Expanded(child: 
                IconButton(
                  onPressed: () async {
                    //Busca el distribuidor de acuerdo a la fila.
                    Distributor distributor = _getDistributorForRendererContext(rendererContext);
                    //Elimina el distribuidor.
                    await _remove(distributor);
                  }, 
                  icon: Icon(MdiIcons.fromString("delete"), color: Colors.redAccent,)
                )
              ),
              //Abrir en navegador
              Expanded(child: 
                IconButton(
                  onPressed: () async{
                    //Busca el distribuidor de acuerdo a la fila.
                    Distributor distributor = _getDistributorForRendererContext(rendererContext);

                    Uri url = Uri.parse(distributor.getWebsite() ?? "");
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  }, 
                  icon: Icon(MdiIcons.fromString("web"), color: Colors.blue)
                )
              ),
              //Enviar email
              Expanded(child: 
                IconButton(
                  onPressed: () async{
                    //Busca el distribuidor de acuerdo a la fila.
                    Distributor distributor = _getDistributorForRendererContext(rendererContext);

                    if (distributor.getEmail()!=null){
                      final mailtoLink = Mailto(
                        to: [distributor.getEmail()!],
                        cc: [],
                        subject: 'Consulta: <Inserte consulta>',
                        body: '<Insertar mensaje>.',
                      );
                      
                      Uri url = Uri.parse(mailtoLink.toString());
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }
                    }
                  }, 
                  icon: Icon(MdiIcons.fromString("email"), color: Colors.brown)
                )
              ),
            ],
          );
        },
      ),
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
    ]);

    //Agrega las filas.
    _rows.addAll(ref.read(distributorCatalogProvider).map((e){
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
          if (mounted){
            ref.read(stateManagerDistributorProvider.notifier).load(event.stateManager);
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

  
  Future<void> _remove(Distributor distributor) async{
    bool isError = false;
    ref.read(distributorStateRemoveProvider.notifier).load(distributor);
    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
    Response response = await ref.read(removeDistributorWithAPIProvider.future);
    //Consulta el estado de la respuesta.
    isError = response.statusCode!=200;
    //Si ocurre error, entonces se procede a notificar del éxito de la operación y a cerrar el widget.
    if (isError==false){
      if (context.mounted){
        ElegantNotificationCustom.showNotificationSuccess(context);
      }
      ref.read(stateManagerDistributorProvider)!.removeRows([ref.read(distributorStateRemoveProvider)!.getPlutoRow()!]);
      ref.read(distributorStateRemoveProvider.notifier).free();
    }
    else{
      if (context.mounted){
        ElegantNotificationCustom.showNotificationError(context);
      }
    }
  }

  Distributor _getDistributor(PlutoRow row){
    int rowID = row.cells[Distributor.getKeyID()]!.value;
    return ref.read(distributorCatalogProvider).firstWhere((element) => element.getID()==rowID);
  }

  ///
  Distributor _getDistributorForRendererContext(PlutoColumnRendererContext rendererContext){
    PlutoRow row = rendererContext.row;
    return _getDistributor(row);
  }
}