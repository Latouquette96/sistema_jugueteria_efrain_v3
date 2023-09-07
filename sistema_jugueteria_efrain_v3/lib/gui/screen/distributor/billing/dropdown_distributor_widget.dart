import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_search_provider.dart';

///Clase DropdownDistributorWidget: Modela un Dropdown exclusivo para mostrar las distribuidoras existentes.
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
      //Obtiene todas las distribuidoras existentes.
      List<Distributor> list = ref.watch(distributorCatalogProvider);

      return DropdownSearch<Distributor>(
        popupProps: PopupProps.menu(
          showSelectedItems: ref.watch(distributorStateBillingProvider) != null,
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
            ref.watch(distributorStateBillingProvider.notifier).load(value);
          }
        },
        selectedItem: ref.watch(distributorStateBillingProvider),
        compareFn: (d1, d2){
          return d1.getID()==d2.getID();
        },
      );
  }
}