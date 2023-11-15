import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/container/expansion_tile_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/image/image_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

///Clase ProductImageCarouselWidget: Modela un caroussel de imágenes de un producto dado.
class ProductImageCarouselWidget extends ConsumerStatefulWidget {
  //Atributos
  final StateNotifierProvider<ElementStateProvider<Product>, Product?> providerProduct;
  final int? imagesDisplay;

  const ProductImageCarouselWidget({
    super.key,
    required this.providerProduct,
    this.imagesDisplay
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductImageCarouselWidgetState();
  }

}

class _ProductImageCarouselWidgetState extends ConsumerState<ProductImageCarouselWidget>{

  @override
  Widget build(BuildContext context) {
    int index = -1;
    Product? product = ref.watch(widget.providerProduct);
    List<ResourceLink> listImage = [];

    if (widget.imagesDisplay!=null){
      for (int i=0; i<widget.imagesDisplay! && i<product!.getLinkImages().length; i++){
        listImage.add(product.getLinkImages()[i]);
      }
    }
    else{
      listImage.addAll(product!.getLinkImages());
    }

    return ExpansionTileContainerWidget(
      title: "Imágenes del producto",
      subtitle: "• Código de barras: ${product!.getBarcode()}\n• Título del producto: ${product.getTitle()} \n• Marca/Importador: ${product.getBrand()}.",
      descriptionShow: true,
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          height: 200,
          width: 300,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: listImage.map((e){
              index++;
              return ImageCustom(
                  fileName: product.getFileName(index),
                  resourceLink: e,
                  isReplaceable: false,
                  isDownloaded: true,
                  isRemoved: false,
                  isSelected: false,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

}