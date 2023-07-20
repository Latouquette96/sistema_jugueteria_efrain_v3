import 'package:davi/davi.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor_catalog_provider.dart';

///Clase ScreenDistributorCatalog: Modela un catálogo de distribuidoras.
class ScreenDistributorCatalog extends ConsumerStatefulWidget {
  const ScreenDistributorCatalog({super.key});

  @override
  ScreenDistributorCatalogState createState() {
    return ScreenDistributorCatalogState();
  }
}

class ScreenDistributorCatalogState
    extends ConsumerState<ScreenDistributorCatalog> {
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
        child:
            Davi<Distributor>(model, rowColor: (DaviRow<Distributor>? rowData) {
          if (rowData == null) {
            return Colors.white;
          } else {
            return (rowData.index % 2 == 0)
                ? Colors.blue.shade50
                : Colors.blueGrey.shade50;
          }
        }));
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
        return _getListDistributor(context, message);
      },
    );
  }
/*
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalogo de Distribuidores"),
        primary: false,
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade700,
      ),
      body: Container(
          margin: const EdgeInsets.all(10),
          child: StreamBuilder(
            stream: http.get(Uri.http(url, '/distributors')).asStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> map = convert.jsonDecode(snapshot.data!.body);
                List<Distributor> list = map.map((e) {
                  return Distributor.fromJSON(e);
                }).toList();
                return _getListDistributor(context, list);
              } else {
                if (snapshot.hasError) {
                  return const CircularProgressIndicator(color: Colors.red);
                } else {
                  return FadeShimmer(
                    baseColor: Colors.blue,
                    highlightColor: Colors.red,
                    width: ancho,
                    radius: 25,
                    height: 25,
                    fadeTheme: FadeTheme.light,
                  );
                }
              }
            },
          )),
      endDrawerEnableOpenDragGesture: true,
      drawerScrimColor: Colors.blueAccent.withOpacity(0.3),
    );
  }*/
}
