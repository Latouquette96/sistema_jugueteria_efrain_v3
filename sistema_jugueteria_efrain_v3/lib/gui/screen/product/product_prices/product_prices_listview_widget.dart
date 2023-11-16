import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_list_tile.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_text_field.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/container/expansion_tile_container.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPriceListViewWidget extends ConsumerStatefulWidget {

  late final StateNotifierProvider<ElementStateProvider<Product>, Product?> _providerProduct;
  late final StateNotifierProvider<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>> _providerPriceDistributor;

  ///Constructor de ProductPriceListViewWidget
  ///
  ///[providerProduct] es el provider del producto actual.
  ///[providerPriceDistributor] es el provider que almacena los pares <precio,distribuidora> del producto actual.
  ProductPriceListViewWidget({
    super.key,
    required StateNotifierProvider<ElementStateProvider<Product>, Product?> providerProduct,
    required StateNotifierProvider<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>> providerPriceDistributor,
  }){
    _providerPriceDistributor = providerPriceDistributor;
    _providerProduct = providerProduct;
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductPriceListViewWidgetState();
  }

  StateNotifierProvider<ElementStateProvider<Product>, Product?> getProvider(){
    return _providerProduct;
  }

  StateNotifierProvider<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>> getProviderID(){
    return _providerPriceDistributor;
  }
}

class _ProductPriceListViewWidgetState extends ConsumerState<ProductPriceListViewWidget>{

  @override
  Widget build(BuildContext context) {
    var pricesProduct = ref.watch(widget.getProviderID());

    return SizedBox(
        height: 300,
        child: ListView(
            children: pricesProduct.map((e){
              return Container(
                margin: const EdgeInsets.fromLTRB(0, 2.5, 0, 2.5),
                child: ExpansionTileContainerWidget(
                    childrenLevel: 2,
                    expanded: false,
                    title: "",
                    trailing: Row(
                      children: [
                        Expanded(child: Text(e.getValue1().getName(), style: StyleListTile.getTextStyleTitle(), overflow: TextOverflow.ellipsis,)),
                        Visibility(
                          visible: e.getValue2()!.getWebsite()!=null,
                          child: IconButton(
                              onPressed: () async {
                                Uri url = Uri.parse(e.getValue2()?.getWebsite() ?? "");
                                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              icon: Icon(MdiIcons.fromString("web"), color: Colors.blue)
                          ),
                        ),
                        IconButton(
                          tooltip: "Guarda los cambios realizados.",
                          padding: EdgeInsets.zero,
                          icon: Icon(MdiIcons.fromString("content-save"), color: Colors.black.withOpacity(0.65),),
                          onPressed: () async{
                            ref.read(productPriceProvider.notifier).load(e.getValue2()!);
                            ResponseAPI response = await ref.read(updateProductPriceWithAPIProvider.future);
                            if (mounted){
                              ElegantNotificationCustom.showNotificationAPI(context, response);
                              if (response.isResponseSuccess()){
                                await ref.read(productPricesByIDProvider.notifier).refresh();
                                setState(() {});
                              }
                            }
                          },
                        ),
                        IconButton(
                          tooltip: "Elimina el precio del producto.",
                          padding: EdgeInsets.zero,
                          icon: Icon(MdiIcons.fromString("delete"), color: Colors.redAccent.withOpacity(0.75),),
                          onPressed: () async{
                            ref.read(productPriceRemoveProvider.notifier).load(e.getValue2()!);
                            ResponseAPI response = await ref.read(removeProductPriceWithAPIProvider.future);
                            if (mounted){
                              ElegantNotificationCustom.showNotificationAPI(context, response);
                              if (response.isResponseSuccess()){
                                await ref.read(productPricesByIDProvider.notifier).refresh();
                                setState(() {});
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    children: [
                      TextField(
                        decoration: StyleTextField.getDecoration("Código interno"),
                        controller: TextEditingController(text: e.getValue2()!.getInternalCode()),
                        onChanged: (String value){
                          e.getValue2()!.setInternalCode(value);
                        },
                        onSubmitted:(value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 10,),
                      TextField(
                        decoration: StyleTextField.getDecoration("Precio base (sin impuestos)"),
                        controller: TextEditingController(text: e.getValue2()!.getPriceBase().toStringAsFixed(2)),
                        onChanged: (String value){
                          e.getValue2()!.setPriceBase(double.parse(value));
                        },
                        onSubmitted:(value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 10,),
                      TextField(
                        readOnly: true,
                        decoration: StyleTextField.getDecoration("Precio compra (+${((e.getValue1().getIVA()-1)*100).toStringAsFixed(0)}% de IVA)"),
                        controller: TextEditingController(text: (e.getValue2()!.getPriceBase()*e.getValue1().getIVA()).toStringAsFixed(2)),
                        onChanged: (String value){
                          e.getValue2()!.setPriceBase(double.parse(value));
                        },
                        onSubmitted:(value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(child: TextField(
                            decoration: StyleTextField.getDecoration("Sitio web del producto"),
                            controller: TextEditingController(text: e.getValue2()!.getWebsite()),
                            onChanged: (String value){
                              e.getValue2()!.setWebsite(value);
                            },
                            onSubmitted:(value) {
                              setState(() {});
                            },
                          )),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text("• Ultimo cambio: ${e.getValue2()!.getDateLastUpdated()}", style: StyleContainer.getTextStyleBold()),
                    ]
                ),
              );
            }).toList()
        )
    );
  }
}