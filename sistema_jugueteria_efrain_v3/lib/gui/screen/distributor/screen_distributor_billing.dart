import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/billing/billing_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/billing/billing_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/billing/billing_pdfview_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/billing/dropdown_distributor_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

///Clase ScreenDistributorBilling: Modela un catálogo de distribuidoras.
class ScreenDistributorBilling extends ConsumerStatefulWidget {
  const ScreenDistributorBilling({super.key});

  @override
  ConsumerState<ScreenDistributorBilling> createState() {
    return _ScreenDistributorBillingState();
  }
}

class _ScreenDistributorBillingState extends ConsumerState<ScreenDistributorBilling> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [SizedBox(width: 36,child: Icon(MdiIcons.fromString("file-cabinet"),),), const Expanded(child: Text("Facturas de Distribuidoras"))],
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16),
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                //ref.read(billingProvider.notifier).freeBilling();
                ref.read(distributorBillingProvider.notifier).freeDistributor(ref);
                //ref.refresh(billingsByDistributorProvider);
              });
              
            },
            icon: Icon(MdiIcons.fromString("reload")),
            tooltip: "Recargar lista de facturas.",
          ),
        ],
      ),
      body: Row(
        children: [
          //Panel izquierdo.
          Expanded(child: 
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: BorderDirectional(
                  start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
                  top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
                  end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
                  bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
                )
              ),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Row(
                    children: [
                      const Expanded(child: DropdownDistributorWidget(),),
                      SizedBox(
                        width: 50,
                        child: IconButton(
                          icon: Icon(MdiIcons.fromString("close"),), 
                          onPressed: () { 
                            ref.read(distributorBillingProvider.notifier).freeDistributor(ref);
                           },
                        )
                      )
                    ],
                  )),
                  Visibility(
                    visible: ref.watch(distributorBillingProvider)!=null,
                    child: const Expanded(child: BillingCatalogWidget(),)
                  ),
                  Visibility(
                    visible: ref.watch(distributorBillingProvider)!=null,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: StyleForm.getStyleElevatedButtom(),
                            onPressed: (){
                              int distributorID = ref.read(distributorBillingProvider)!.getID();
                              ref.read(billingProvider.notifier).loadBilling(DistributorBilling.newBilling(distributorID: distributorID));
                            }, 
                            child: const Text("Agregar nueva factura")
                          )
                        ]
                      ),
                    ),)
                ],
              ),
          )),
          //Panel derecho
          Visibility(
              visible: ref.watch(billingProvider) != null,
              child: const SizedBox(
                width: 400,
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: BillingInformationWidget()),
                ],
              ))
          ),
          Visibility(
              visible: ref.watch(billingSearchProvider) != null,
              child: const SizedBox(
                width: 600,
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: BillingPDFViewWidget()),
                ],
              ))
            )
        ],
      ),
    );
  }
}