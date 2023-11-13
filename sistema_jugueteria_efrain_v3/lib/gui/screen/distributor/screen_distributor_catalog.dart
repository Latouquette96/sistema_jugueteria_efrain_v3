import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/billing/billing_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/catalog/distributor_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/catalog/distributor_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_container.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_distributor.dart';

///Clase ScreenDistributorCatalog: Modela un catálogo de distribuidoras.
class ScreenDistributorCatalog extends ConsumerStatefulWidget {
  const ScreenDistributorCatalog({super.key});

  @override
  ConsumerState<ScreenDistributorCatalog> createState() {
    return _ScreenDistributorCatalogState();
  }
}

class _ScreenDistributorCatalogState extends ConsumerState<ScreenDistributorCatalog> {
  // The reference to the navigator
  // ignore: unused_field
  late NavigatorState _navigator;

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  dependOnInheritedWidgetOfExactType(){
    ref.read(passwordLoginMySQLProvider.notifier);
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        title: Row(
          children: [SizedBox(width: 36,child: Icon(MdiIcons.fromString("domain"),),), const Expanded(child: Text("Catálogo de Distribuidoras"))],
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16),
        actionsIconTheme: const IconThemeData(color: Colors.yellow, opacity: 0.75),
        actions: [
          IconButton(
            onPressed: (){
              StateManagerDistributor.getInstance().toggleShowFilter();
              setState(() {});
            },
            icon: Icon(
              MdiIcons.fromString("filter"),
              color:  StateManagerDistributor.getInstance().isShowFilter() ? Colors.yellow : Colors.grey,
            ),
            tooltip: "Mostrar/ocultar filtro",
          ),
          IconButton(
            onPressed: (){
              if (ref.read(distributorStateProvider)!=null){
                ref.read(distributorStateProvider.notifier).free();
              }
              else{
                ref.read(distributorStateProvider.notifier).load(Distributor());
              }
            },
            icon: Icon(MdiIcons.fromString("plus-circle")),
            tooltip: "Insertar una nueva distribuidora.",
          ),
          IconButton(
            onPressed: (){
              //Cierra las pantallas abiertas.
              if (ref.read(distributorStateProvider)!=null) ref.read(distributorStateProvider.notifier).free();
              //Refrezca el catálogo de distribuidoras.
              StateManagerDistributor.getInstance().refresh(ref.read(urlAPIProvider));
            },
            icon: Icon(MdiIcons.fromString("reload")),
            tooltip: "Recargar catálogo.",
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(child: Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            decoration: StyleContainer.getContainerRoot(),
            child: const DistributorCatalogWidget(),
          )),
          Visibility(
              visible: ref.watch(distributorStateProvider) != null,
              child: const SizedBox(
                width: 400,
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: DistributorInformationWidget())
                ],
              ))
          ),
          Visibility(
              visible: ref.watch(distributorStateBillingProvider) != null,
              child: const SizedBox(
                  width: 1000,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: BillingWidget())
                    ],
                  ))
          )
        ],
      ),
    );
  }
}