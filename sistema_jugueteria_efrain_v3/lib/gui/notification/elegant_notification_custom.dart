import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';

class ElegantNotificationCustom {


  static showNotificationError(BuildContext context, {String title = "Error", String description = "Ocurrió un error y no fue posible actualizar la información."}){
    //Mostrar notificación de error.
    ElegantNotification.error(
      title: Text(title),
      description:  Text(description)
    ).show(context);
  }

  static showNotificationSuccess(BuildContext context, {String title = "Información", String description = "La información ha sido actualizada con éxito."}){
     //Mostrar notificación de error.
    ElegantNotification.success(
      title: Text(title),
      description:  Text(description)
    ).show(context);
  }

}