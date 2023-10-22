import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/distributor_free_product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

class NewProductPricesWidget extends ConsumerStatefulWidget {

  late final StateNotifierProvider<ElementStateProvider<Product>, Product?> _providerProduct;
  late final FormGroup _formGroup;

  ///Constructor de NewProductPricesWidget
  ///
  ///[providerProduct] es el provider del producto actual.
  ///[providerPriceDistributor] es el provider que almacena los pares <precio,distribuidora> del producto actual.
  ///[providerStateManager] el el provider del controlador del catálogo de productos.
  ///[providerPlutoRow] es el provider que almacena el PlutoRow para poder actualizarlo de ser necesario.
  ///[widgetProduct] (Opcional) widget de producto.
  NewProductPricesWidget({
    super.key,
    required StateNotifierProvider<ElementStateProvider<Product>, Product?> providerProduct,
    required FormGroup formGroup
  }){
    _providerProduct = providerProduct;

    _formGroup = formGroup;
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NewProductPricesWidgetState();
  }

  FormGroup getFormGroup(){
    return _formGroup;
  }

  StateNotifierProvider<ElementStateProvider<Product>, Product?> getProvider(){
    return _providerProduct;
  }

/*
  StateNotifierProvider<ElementStateProvider<ProductPrice>, ProductPrice?> getProviderProductPrice(){
    return _providerProductPrice;
  }*/
}

class _NewProductPricesWidgetState extends ConsumerState<NewProductPricesWidget>{

  late final FormGroup _formNewPP;

  @override
  void initState() {
    super.initState();
    _formNewPP = widget.getFormGroup();
  }

  @override
  Widget build(BuildContext context) {
    final distributorsFree = ref.watch(distributorFreeProductPriceProvider);

    return Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
        decoration: StyleForm.getDecorationFormControl(),
        height: 250,
        child: ReactiveForm(
          formGroup: _formNewPP,
          child: ListTile(
            //Title: Distribuidora.
            title: Text("Ingresar nuevo precio de producto", style: StyleForm.getTextStyleTitle()),
            //Subtitle
            subtitle: Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                  children: [
                    ReactiveTextField(
                      style: StyleForm.getStyleTextField(),
                      decoration: StyleForm.getDecorationTextField("Código interno"),
                      formControlName: ProductPrice.getKeyInternalCode(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReactiveDropdownField<Distributor>(
                      formControlName: "${ProductPrice.getKeyDistributor()}Object",
                      style: StyleForm.getStyleTextField(),
                      decoration: StyleForm.getDecorationTextField("Distribuidora"),
                      items: distributorsFree.map((e) => DropdownMenuItem<Distributor>(
                        value: e,
                        child: Text(e.getName()),
                      )).toList(),
                      onChanged: (control) {
                        _formNewPP.control(ProductPrice.getKeyDistributor()).value = control.value!.getID();
                        _formNewPP.focus(ProductPrice.getKeyPriceBase());
                      },
                      validationMessages: {
                        ValidationMessage.required: (error) => "(Requerido) Seleccione la distribuidora."
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReactiveTextField(
                      style: StyleForm.getStyleTextField(),
                      decoration: StyleForm.getDecorationTextField("Precio base (sin impuestos)"),
                      formControlName: ProductPrice.getKeyPriceBase(),
                      validationMessages: {
                        ValidationMessage.required: (error) => "(Requerido) Ingrese el código de barras del producto."
                      },
                    ),
                    Container(
                      margin: EdgeInsets.zero,
                      height: 32,
                      child: Row(
                        children: [
                          Expanded(child: IconButton(
                            color: Colors.blueGrey,
                            padding: EdgeInsets.zero,
                            icon: Row(
                              children: [
                                Icon(MdiIcons.fromString("content-save")),
                                Text("\tGuardar", style: StyleForm.getTextStyleListTileSubtitle(),),
                              ],
                            ),
                            onPressed: () async{
                              ref.read(productPriceProvider.notifier).load(ProductPrice.fromJSON(_formNewPP.value));
                              final response = await ref.read(newProductPriceWithAPIProvider.future);

                              if (mounted){
                                ElegantNotificationCustom.showNotificationAPI(context, response);

                                if (response.isResponseSuccess()){
                                  ref.read(productPriceProvider.notifier).free();
                                  await ref.read(productPricesByIDProvider.notifier).refresh();
                                  setState(() {});
                                }
                              }
                            },
                          )),
                          Expanded(child: IconButton(
                            color: Colors.redAccent,
                            padding: EdgeInsets.zero,
                            icon: Row(
                              children: [
                                Icon(MdiIcons.fromString("eraser")),
                                Expanded(child: Text("\tLimpiar", style: StyleForm.getTextStyleListTileSubtitle(),)),
                              ],
                            ),
                            onPressed: (){
                              _clearForm();
                              setState(() {});
                            },
                          ),)
                        ],
                      ),
                    )
                  ],
                )
            ),
          ),
        )
    );
  }

  ///ProductPriceWidget: Limpia el formulario de insersion de precio de producto.
  void _clearForm(){
    final distributorsFree = ref.read(distributorFreeProductPriceProvider);
    _formNewPP.control(ProductPrice.getKeyDistributor()).value = 0;
    _formNewPP.control(ProductPrice.getKeyPriceBase()).value = 0.00;
    _formNewPP.control("${ProductPrice.getKeyDistributor()}Object").value = distributorsFree.isEmpty ? null : distributorsFree.first;
  }
}