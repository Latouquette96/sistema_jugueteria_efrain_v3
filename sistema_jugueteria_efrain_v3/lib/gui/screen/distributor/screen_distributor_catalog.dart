import 'package:davi/davi.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/distributor_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_catalog_provider.dart';

///Clase ScreenDistributorCatalog: Modela un catálogo de distribuidoras.
class ScreenDistributorCatalog extends ConsumerStatefulWidget {
  const ScreenDistributorCatalog({super.key});

  @override
  ScreenDistributorCatalogState createState() {
    return ScreenDistributorCatalogState();
  }
}

class ScreenDistributorCatalogState extends ConsumerState<ScreenDistributorCatalog> {
  
  
  
  ///ScreenDistributorCatalog: Devuelve un listado de ListTile de los distribuidores.
  Widget _getListDistributor(BuildContext context, List<Distributor> list) {
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
              onTap: () async {},
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
              onTap: () {},
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
            ),
            resizeAreaWidth: 10,
            resizeAreaHoverColor: Colors.blue.withOpacity(.5),
            sortIconColors: SortIconColors.all(Colors.orange),
            expandableName: false,
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
                ref.read(distributorProvider.notifier).freeDistributor();
              }
            },
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    // También podemos usar "ref" para escuchar a un provider dentro del método build
    AsyncValue<List<Distributor>> message = ref.watch(
      providerDistributorCatalog,
    );
    double ancho = MediaQuery.of(context).size.width;

    return message.when(
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
        return Row(
          children: [
            Expanded(child: _getListDistributor(context, message)),
            Visibility(
              visible: ref.watch(distributorProvider) != null,
              child: const Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: DistributorInformationWidget())
                ],
              )
            )
          ],
        );
      },
    );
  }
}