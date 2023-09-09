import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_provider.dart';

///Clase BillingCatalogWidget: Modela un catalogo de facturas para la distribuidora seleccionada.
class BillingCatalogWidget extends ConsumerWidget {
  const BillingCatalogWidget({super.key});
  
  ///BillingCatalogWidget: Devuelve un widget con el listado de las facturas para una determinada distribuidora.
  Widget _getBillingsDistributor(WidgetRef ref, List<DistributorBilling> list){
    
    return Row(
      children: [
        Expanded(child: 
          Container(
            decoration: BoxDecoration(
            color: const Color.fromARGB(70, 114, 114, 114),
            border: Border.all(color: const Color.fromARGB(255, 158, 158, 158)), ),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: list.map((e){
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.grey.shade200, Colors.grey.shade300, Colors.grey.shade400]),
                            border: Border.all(color: Colors.grey)
                          ),
                          margin: const EdgeInsets.fromLTRB(0, 0.5, 0, 0.5),
                          child: ListTile(
                            iconColor: Colors.black,
                            title: Row(
                              children: [
                                Text("Fecha: ", style: StyleForm.getStyleTextField(),),
                                Expanded(child: Text(e.getDatetime(), style: StyleForm.getStyleTextField()))
                              ]
                            ),
                            subtitle: Text("Total: \$${e.getTotal().toStringAsFixed(2)}", style: StyleForm.getStyleTextField(),),
                            trailing: IconButton(
                              icon: Icon(MdiIcons.fromString("file-pdf-box")),
                              tooltip: "Visualizar factura",
                              onPressed: (){
                                if (ref.read(billingSearchProvider)==null){
                                  ref.read(billingSearchProvider.notifier).load(e);
                                }
                                else{
                                  ref.read(billingSearchProvider.notifier).free();
                                }
                              },
                            ),
                      ),
                        );
                      }).toList(),
                    ),
                  )
                )
              ],
            ),
          )
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamProvider = ref.watch(billingsByDistributorProvider);
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
        return _getBillingsDistributor(ref, message);
      },
    );
  }
}