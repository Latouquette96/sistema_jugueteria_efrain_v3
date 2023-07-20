///Clase LinkImage: Modela un link de imagen válido para poder ser compartido.
class LinkImage {
  //Atributos de instancia
  late String _link;

  ///Constructor de LinkImage.
  LinkImage(String link) {
    //Si es un link de Google Drive.
    if (link.contains("https://drive.google.com/")) {
      _link = _convertLinkToGoogleDrive(link);
    } else {
      if (link.contains("https://dropbox.com/")) {
        _link = _convertLinkToDropbox(link);
      } else {
        _link = _getLinkDefect();
      }
    }
  }

  ///LinkImage: Convertir a link valido de Google Drive.
  String _convertLinkToGoogleDrive(String link) {
    String url;

    //Si el link contiene algún texto ademas del identificador, entonces se procede a recuperar la clave y construir el link correcto.
    if (link.contains("view?usp=drive_link") ||
        link.contains("view?usp=share_link") ||
        link.contains("view?usp=sharing")) {
      List<String> linkSplit = link.split("/");
      url = "https://drive.google.com/uc?export=view&id=${linkSplit[5]}";
    } else {
      url = link;
    }

    return url;
  }

  ///LinkImage: Convertir a link valido de Dropbox.
  String _convertLinkToDropbox(String link) {
    String url = link;
    if (url.contains("?dl=0")) {
      url = url.replaceAll("?dl=0", "?dl=1");
    }

    return url;
  }

  ///LinkImage: Devuelve el link por defecto.
  String _getLinkDefect() {
    return "https://drive.google.com/uc?export=view&id=1Mh8yFhGtvhq7AkKzs09jad8d5pjwADKi";
  }

  ///LinkImage: Devuelve el link de imagen.
  String getLink() {
    return _link;
  }
}
