import 'package:flutter/material.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/catalog/product_information_widget.dart';

class PopupInformation {

  static void showProductInformation(BuildContext context, Function() onClose){
    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            titlePadding: EdgeInsets.zero,
            content: SizedBox(
              width: width,
              height: height,
              child: ProductInformationWidget(onClose: (){
                Navigator.pop(context, 'close');
                Future.delayed(const Duration(seconds: 2), (){
                  onClose.call();
                });
              },),
            ),
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.black26,
          );
        }
    );
  }
}