import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_catalog_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

class DropdownDistributorWidget extends ConsumerStatefulWidget {

  const DropdownDistributorWidget({super.key} );
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DropdownDistributorWidgetState();
  }
}

class _DropdownDistributorWidgetState extends ConsumerState<DropdownDistributorWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      final valueFuture = ref.watch(catalogDistributorProvider);

      return valueFuture.when(
        data: (data){
          List<Distributor> list = data.getValue2() ?? [];
          if (list.isEmpty){
            return const Text("No se encontrarón distribuidoras registradas");
          }
          else{
            return DropdownSearch<Distributor>(
              popupProps: PopupProps.menu(
                  showSelectedItems: ref.watch(distributorBillingProvider) != null,
              ),
              items: list,
              itemAsString:(item) {
                return item.getName();
              },
              dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      labelText: "Seleccione una distribuidora",
                      hintText: "Distribuidora",
                      labelStyle: StyleForm.getStyleTextField(),
                      border: const OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, color: Colors.grey))
                  ),
              ),
              onChanged:(value) {
                if (value!=null){
                  ref.watch(distributorBillingProvider.notifier).loadDistributor(value);
                }
              },
              selectedItem: ref.watch(distributorBillingProvider),
              compareFn: (d1, d2){
                return d1.getID()==d2.getID();
              },
            );
          }
        },
        error: (error, stack){
          return Text("Error: ${stack.toString()}");
        }, 
        loading:(){
          return const CircularProgressIndicator();
        }
      );
  }
}