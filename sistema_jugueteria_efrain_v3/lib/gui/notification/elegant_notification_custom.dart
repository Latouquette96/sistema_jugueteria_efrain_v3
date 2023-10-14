import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';

class ElegantNotificationCustom {

  ///ElegantNotificationCustom: Despliega una notificacion de acuerdo a los datos recibidos de la llamada a la API.
  ///
  ///[context] BuildContext.
  ///[response] Mapeo de claves String y datos dynamic. Se requiere el mapeo esté compuesto de la siguiente manera:
  ///{
  /// [status]: statusCode que representa el éxito o fracaso de la operación.
  /// [title]: Titulo que representa el éxito o error en la API REST.
  /// [message]: Mensaje que representa lo ocurrido en la API REST.
  /// }
  static showNotificationAPI(
      BuildContext context,
      Map<String, dynamic> response
  ){
    if (response['status']==200 || response['status']==201){
      ElegantNotification.success(
          title: Text(response['title']),
          description:  Text(response['message'])
      ).show(context);
    }
    else{
      ElegantNotification.error(
          title: Text(response['title']),
          description:  Text(response['message'])
      ).show(context);
    }

  }


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