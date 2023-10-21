import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
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
  late final double _widthTreeNode;

  ///Constructor de ProductPriceListViewWidget
  ///
  ///[providerProduct] es el provider del producto actual.
  ///[providerPriceDistributor] es el provider que almacena los pares <precio,distribuidora> del producto actual.
  ///[widthTreeNode] establece el ancho del bloque TreeNode.
  ProductPriceListViewWidget({
    super.key,
    required StateNotifierProvider<ElementStateProvider<Product>, Product?> providerProduct,
    required StateNotifierProvider<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>> providerPriceDistributor,
    double widthTreeNode = 250
  }){
    _providerPriceDistributor = providerPriceDistributor;
    _providerProduct = providerProduct;
    _widthTreeNode = widthTreeNode;
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

  double getWidthTreeNode(){
    return _widthTreeNode;
  }
}

class _ProductPriceListViewWidgetState extends ConsumerState<ProductPriceListViewWidget>{

  final TreeController _controller = TreeController(allNodesExpanded: false);

  @override
  Widget build(BuildContext context) {
    var pricesProduct = ref.watch(widget.getProviderID());

    return Container(
        height: 300,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(0),
        decoration: StyleForm.getDecorationFormControl(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Precios de producto por distribuidora", style: StyleForm.getTextStyleTitle()),
            Expanded(
                child: SingleChildScrollView(
                  child: TreeView(
                    indent: 10,
                    treeController: _controller,
                    //Lo nodos serán cada uno de los elementos 'e' que son pares de <Distribuidora, PrecioProducto>
                    nodes: pricesProduct.map((e){
                      //Nodo del elemento 'e'
                      return TreeNode(
                          content: Container(
                            decoration: StyleForm.getDecorationControlImage(),
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            margin: const EdgeInsets.fromLTRB(0, 2.5, 0, 0),
                            width: widget.getWidthTreeNode(),
                            child: Row(
                              children: [
                                Expanded(child: Text(e.getValue1().getName(), style: StyleForm.getTextStyleListTileTitle(), overflow: TextOverflow.ellipsis,)),
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
                                  icon: Icon(MdiIcons.fromString("content-save"), color: Colors.blueGrey,),
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
                                  icon: Icon(MdiIcons.fromString("delete"), color: Colors.redAccent,),
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
                          ),
                          children: [
                            //Nodo de código interno.
                            TreeNode(
                                content: Container(
                                  color: Colors.grey.shade50,
                                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                                  height: 60,
                                  width: widget.getWidthTreeNode()-15,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: TextField(
                                    decoration: StyleForm.getDecorationTextField("Código interno"),
                                    controller: TextEditingController(text: e.getValue2()!.getInternalCode()),
                                    onChanged: (String value){
                                      e.getValue2()!.setInternalCode(value);
                                    },
                                    onSubmitted:(value) {
                                      setState(() {});
                                    },
                                  ),
                                )
                            ),
                            //Nodo de precio.
                            TreeNode(
                                content: Container(
                                  color: Colors.grey.shade50,
                                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                                  height: 60,
                                  width: widget.getWidthTreeNode()-15,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: TextField(
                                    decoration: StyleForm.getDecorationTextField("Precio base (sin impuestos)"),
                                    controller: TextEditingController(text: e.getValue2()!.getPriceBase().toStringAsFixed(2)),
                                    onChanged: (String value){
                                      e.getValue2()!.setPriceBase(double.parse(value));
                                    },
                                    onSubmitted:(value) {
                                      setState(() {});
                                    },
                                  ),
                                )
                            ),
                            TreeNode(
                                content: Container(
                                  color: Colors.grey.shade50,
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  height: 40,
                                  width: widget.getWidthTreeNode()-15,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text("• Precio compra (x${e.getValue1().getIVA().toStringAsFixed(2)}): \$${(e.getValue2()!.getPriceBase()*e.getValue1().getIVA()).toStringAsFixed(2)}", style: StyleForm.getTextStyleListTileSubtitle()),
                                )
                            ),
                            TreeNode(
                                content: Container(
                                  color: Colors.grey.shade50,
                                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                  height: 50,
                                  width: widget.getWidthTreeNode()-15,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Row(
                                    children: [
                                      Expanded(child: TextField(
                                        decoration: StyleForm.getDecorationTextField("Sitio web del producto"),
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
                                )
                            ),
                            TreeNode(
                                content: Container(
                                  color: Colors.grey.shade50,
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  height: 60,
                                  width: widget.getWidthTreeNode()-15,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text("• Ultimo cambio: ${e.getValue2()!.getDateLastUpdated()}", style: StyleForm.getTextStyleListTileSubtitle()),
                                )
                            )
                          ]
                      );
                    }).toList(),
                  ),
                )
            ),
          ],
        )
    );
  }
}