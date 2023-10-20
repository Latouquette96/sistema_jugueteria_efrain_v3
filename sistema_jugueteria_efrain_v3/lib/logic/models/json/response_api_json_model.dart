class ResponseApiJSON {

  ///ResponseApiJSON: Devuelve un mensaje que indica que ocurrió un problema.
  static Map<String, dynamic> getProblemOccurredMessage(){
    return {
      'status': 400,
      'title': "Error 400",
      'message': 'Error: No se pudo realizar la solicitud al servidor.',
      'error': null,
      'value': null
    };
  }

}