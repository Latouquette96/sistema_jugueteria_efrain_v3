import 'package:davi/davi.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:mailto/mailto.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_catalog_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:url_launcher/url_launcher.dart';

@immutable
///DistributorCatalogWidget: Widget que permite visualizar el catalogo de distribuidoras.
class DistributorCatalogWidget extends ConsumerWidget {

  const DistributorCatalogWidget({super.key});
  
  ///DistributorCatalogWidget: Devuelve un listado de los distribuidores.
  Widget _getListDistributor(BuildContext context, WidgetRef ref, List<Distributor> list) {
    DaviModel<Distributor>? model = DaviModel<Distributor>(rows: list, columns: [
      //CUIT
      DaviColumn(
          name: 'CUIT',
          stringValue: (row) => row.getCUIT(),
          width: 150,
          resizable: false,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center),
      //NOMBRE
      DaviColumn(
        name: 'Nombre distribuidora',
        stringValue: (Distributor p) {
          return p.getName();
        },
        grow: 40,
        headerAlignment: Alignment.center,
      ),
      //DIRECCION
      DaviColumn(
          name: 'Dirección',
          stringValue: (Distributor p) {
            return p.getAddress();
          },
          grow: 30,
          headerAlignment: Alignment.center),
      //TELEFONO
      DaviColumn(
          name: 'Telefono',
          stringValue: (Distributor p) {
            return p.getPhone();
          },
          width: 150,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center),
      //CORREO ELECTRÓNICO
      DaviColumn(
          name: 'Correo electrónico',
          stringValue: (Distributor p) {
            return p.getEmail();
          },
          fractionDigits: 2,
          grow: 30,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center),
      //IVA
      DaviColumn(
          name: 'IVA',
          doubleValue: (Distributor p) {
            return p.getIVA();
          },
          fractionDigits: 2,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center),
      //Opciones
      DaviColumn(
          pinStatus: PinStatus.none,
          width: 40,
          resizable: false,
          cellBuilder: (BuildContext context, DaviRow<Distributor> data) {
            return InkWell(
              child: const Icon(Icons.edit, color: Colors.green, size: 24),
              onTap: () {
                ///Carga una ditribuidora al proveedor para que pueda ser editado.
                ref.read(distributorProvider.notifier).loadDistributor(data.data);
              },
            );
          }),
      DaviColumn(
          pinStatus: PinStatus.none,
          width: 40,
          resizable: false,
          cellBuilder: (BuildContext context, DaviRow<Distributor> data) {
            return InkWell(
              child: const Icon(
                Icons.remove_circle,
                color: Colors.red,
                size: 24,
              ),
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
          }),
      DaviColumn(
          pinStatus: PinStatus.none,
          width: 40,
          resizable: false,
          cellBuilder: (BuildContext context, DaviRow<Distributor> data) {
            return InkWell(
              child: Icon(
                MdiIcons.fromString("web"),
                color: Colors.blue,
                size: 24,
              ),
              onTap: () async {
                Uri url = Uri.parse(data.data.getWebsite() ?? "");
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
            );
          }),
      DaviColumn(
          pinStatus: PinStatus.none,
          width: 40,
          resizable: false,
          cellBuilder: (BuildContext context, DaviRow<Distributor> data) {
            return InkWell(
              child: Icon(
                MdiIcons.fromString("email"),
                color: const Color.fromARGB(255, 175, 107, 82),
                size: 24,
              ),
              onTap: () async {
                if (data.data.getEmail()!=null){
                  final mailtoLink = Mailto(
                    to: [data.data.getEmail()!],
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
        child: Davi<Distributor>(
            model, 
            rowColor: (DaviRow<Distributor>? rowData) {
              if (rowData == null) {
                return Colors.white;
              } 
              else {
                return (rowData.index % 2 == 0)
                  ? Colors.blue.shade50
                  : Colors.blueGrey.shade50;
              }
            },
            onRowDoubleTap:(Distributor data) {
              if (ref.read(distributorProvider)==null){
                ref.read(distributorProvider.notifier).loadDistributor(data);
              }
              else{
                ref.read(distributorProvider.notifier).freeDistributor(ref);
              }
            },
        )
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamProvider = ref.watch(catalogDistributorProvider);
    double ancho = MediaQuery.of(context).size.width;

    return streamProvider.when(
      loading: () {
        return FadeShimmer(
          baseColor: Colors.blue,
          highlightColor: Colors.red,
          width: ancho,
          radius: 25,
          height: 25,
          fadeTheme: FadeTheme.light,
        );
      },
      error: (err, stack) => Text('Error: $err'),
      data: (message) {
        return _getListDistributor(context, ref, message.getValue2()!);
      },
    );
  }
}