import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/container_style.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/extract_text/extract_text_pdf_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pdf_view/pdf_view_controller_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';

///Clase FilteredProductCatalogWidget: Permite mostrar y actualizar la información de un producto.
class FilteredProductCatalogWidget extends ConsumerStatefulWidget {
  const FilteredProductCatalogWidget({super.key});
  
  @override
  ConsumerState<FilteredProductCatalogWidget> createState() {
    return _FilteredProductCatalogWidgetState();
  }
}

class _FilteredProductCatalogWidgetState extends ConsumerState<FilteredProductCatalogWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 750,
      margin: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      decoration: StyleForm.getDecorationContainer(),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Encabezado principal.
            const HeaderInformationWidget(
              titleHeader: "Visualizador de productos en el PDF",
              tooltipClose: "Cerrar visor PDF.",
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: ref.watch(extractTextFromPDFProvider).map((e){
                      return Container(
                        margin: const EdgeInsets.fromLTRB(7.5, 2.5, 7.5, 2.5),
                        decoration: ContainerStyle.getContainerChild(),
                        child: ListTile(
                          title: Text(e.getTitle(), style: TextStyle(color: (ref.watch(productExtractTextProvider)==e) ? Colors.blueAccent.shade700 : Colors.grey.shade900),),
                          leading: Icon(Icons.arrow_back_ios_new_rounded, color: (ref.watch(productExtractTextProvider)==e) ? Colors.blueAccent : Colors.grey.shade700, size: 16,),
                          trailing: Icon(Icons.arrow_forward_ios_rounded, color: (ref.watch(productExtractTextProvider)==e) ? Colors.blueAccent : Colors.grey.shade700, size: 16,),
                          onTap: (){
                            if (ref.read(productExtractTextProvider)!=null){
                              ref.read(productExtractTextProvider.notifier).free();
                            }
                            else{
                              //Busca el producto de acuerdo a la fila.
                              Product product = e;
                              ref.read(pdfExtractTextTextSearchResultProvider.notifier).search(product);
                              ref.read(productExtractTextProvider.notifier).load(product);
                              ref.read(productPricesExtractTextPDFProvider.notifier).refresh();
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
            )
          ]
      )
    );
  }
}