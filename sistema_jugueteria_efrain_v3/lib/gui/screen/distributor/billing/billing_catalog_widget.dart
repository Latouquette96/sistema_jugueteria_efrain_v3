import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_catalog_provider.dart';
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
            color: const Color.fromARGB(255, 183, 183, 183),
            border: Border.all(color: Colors.grey), ),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: list.map((e){
                        return ListTile(
                        title: Row(
                          children: [
                            const Text("Fecha:"),
                            Expanded(child: Text(e.getDatetime()))
                          ]
                        ),
                        subtitle: Text("Total: \$${e.getTotal().toStringAsFixed(2)}"),
                        trailing: IconButton(
                          icon: Icon(MdiIcons.fromString("file-pdf-box")),
                          onPressed: (){
                            if (ref.read(billingSearchProvider)==null){
                              ref.read(billingSearchProvider.notifier).loadBilling(e);
                            }
                            else{
                              ref.read(billingSearchProvider.notifier).freeBilling();
                            }
                          },
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