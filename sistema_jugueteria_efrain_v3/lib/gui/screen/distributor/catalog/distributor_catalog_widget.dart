import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mailto/mailto.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/config/pluto_config.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/catalog_distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_row_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';
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

    _columns.addAll(PlutoConfig.getPlutoColumnsDistributor(
      options: PlutoColumn(
        cellPadding: EdgeInsets.zero,
        title: "Opciones", 
        field: "key_options", 
        type: PlutoColumnType.text(),
        width: 200,
        minWidth: 200,
        renderer: (rendererContext) {
          return Row(
            children: [
              //Editar distribuidora.
              Expanded(child: 
                IconButton(
                  onPressed: (){
                    if (ref.read(distributorStateProvider)!=null){
                      ref.read(distributorStateProvider.notifier).free();
                      ref.read(plutoRowProvider.notifier).free();
                    }
                    else{
                      //Busca el distribuidor de acuerdo a la fila.
                      Distributor distributor = _getDistributorForRendererContext(rendererContext);
                      ///Carga un distribuidor al proveedor para que pueda ser editado.
                      ref.read(plutoRowProvider.notifier).load(rendererContext.row);
                      ref.read(distributorStateProvider.notifier).load(distributor);
                    }
                  }, 
                  icon: Icon(MdiIcons.fromString("pencil"), color: Colors.black,)
                )
              ),
              //Eliminar distribuidora.
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
              //Abrir pdfs
              Expanded(child:
                IconButton(
                  onPressed: (){
                    if (ref.read(distributorStateBillingProvider)!=null){
                      ref.read(distributorStateBillingProvider.notifier).free();
                    }
                    else{
                      //Busca el distribuidor de acuerdo a la fila.
                      Distributor distributor = _getDistributorForRendererContext(rendererContext);
                      ///Carga un distribuidor
                      ref.read(distributorStateBillingProvider.notifier).load(distributor);
                    }
                  },
                  icon: Icon(MdiIcons.fromString("file-pdf-box"), color: Colors.black,)
                )
              )
            ],
          );
        },
      ),
    ));

    //Agrega las filas.
    _rows.addAll(ref.read(catalogDistributorProvider).map((e){
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
            ref.read(catalogDistributorProvider.notifier).refresh();
          }
        },
        configuration: PlutoConfig.getConfiguration()
      ),
    );
  }

  ///DistributorCatalogWidget: Remueve la distribuidora de la grilla y del servidor.
  Future<void> _remove(Distributor distributor) async{
    ref.read(distributorStateRemoveProvider.notifier).load(distributor);
    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
    ResponseAPI response = await ref.read(removeDistributorWithAPIProvider.future);
    //Si ocurre error, entonces se procede a notificar del éxito de la operación y a cerrar el widget.
    if (context.mounted){
      ElegantNotificationCustom.showNotificationAPI(context, response);

      if (response.isResponseSuccess()){
        // ignore: unused_result
        ref.read(stateManagerDistributorProvider)!.removeRows([ref.read(distributorStateRemoveProvider)!.getPlutoRow()!]);
        ref.read(distributorStateRemoveProvider.notifier).free();
      }
    }
  }

  ///DistributorCatalogWidget: Devuelve la distribuidora de una fila.
  Distributor _getDistributor(PlutoRow row){
    int rowID = row.cells[Distributor.getKeyID()]!.value;
    return ref.read(catalogDistributorProvider).firstWhere((element) => element.getID()==rowID);
  }

  ///DistributorCatalogWidget: Devuelve la distribuidora del contexto.
  Distributor _getDistributorForRendererContext(PlutoColumnRendererContext rendererContext){
    PlutoRow row = rendererContext.row;
    return _getDistributor(row);
  }
}