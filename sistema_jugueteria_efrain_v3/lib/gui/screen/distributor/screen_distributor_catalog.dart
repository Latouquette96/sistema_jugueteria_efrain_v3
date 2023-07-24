import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/distributor_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/distributor_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_catalog_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

///Clase ScreenDistributorCatalog: Modela un catálogo de distribuidoras.
class ScreenDistributorCatalog extends ConsumerStatefulWidget {
  const ScreenDistributorCatalog({super.key});

  @override
  ScreenDistributorCatalogState createState() {
    return ScreenDistributorCatalogState();
  }
}

class ScreenDistributorCatalogState extends ConsumerState<ScreenDistributorCatalog> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [SizedBox(width: 36,child: Icon(MdiIcons.fromString("domain"),),), const Expanded(child: Text("Catálogo de Distribuidoras"))],
        ),
        backgroundColor: Colors.black,
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16),
        actions: [
          IconButton(
            onPressed: (){
              ref.read(distributorProvider.notifier).loadDistributor(Distributor());
            },
            icon: Icon(MdiIcons.fromString("plus-circle")),
            tooltip: "Insertar una nueva distribuidora.",
          ),
          IconButton(
            onPressed: (){
              ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
            },
            icon: Icon(MdiIcons.fromString("reload")),
            tooltip: "Recargar catálogo.",
          ),
        ],
      ),
      body: Row(
        children: [
          const Expanded(child: DistributorCatalogWidget()),
          Visibility(
              visible: ref.watch(distributorProvider) != null,
              child: const SizedBox(
                width: 400,
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: DistributorInformationWidget())
                ],
              ))
            )
        ],
      ),
    );
  }
}