import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';

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
      ResponseAPI response
  ){
    if (response.isResponseSuccess()){
      ElegantNotification.success(
          title: Text(response.getTitle()),
          description:  Text(response.getMessage() ?? "")
      ).show(context);
    }
    else{
      ElegantNotification.error(
          title: Text(response.getTitle()),
          description:  Text(response.getMessage() ?? "")
      ).show(context);
    }
  }
}