enum ResourceLinkMode{
  imageJPG,
  documentPDF
}


///Clase ResourceLink: Modela un link de imagen válido para poder ser compartido.
class ResourceLink {
  //Atributos de instancia
  late String _link;
  late ResourceLinkMode? _mode;

  ///Constructor de ResourceLink.
  ResourceLink(String link, {ResourceLinkMode mode = ResourceLinkMode.imageJPG}) {
    //Modo de analisis del archivo.
    _mode = mode;
    //Si es un link de Google Drive.
    if (link.contains("https://drive.google.com/") || link.contains("https://www.drive.google.com/")) {
      _link = _convertLinkToGoogleDrive(link);
    } else {
      if (link.contains("https://dropbox.com/") || link.contains("https://www.dropbox.com")) {
        _link = _convertLinkToDropbox(link);
      } else {
        //Si es un link de internet (https, http o ftp)
        if (link.contains("https://") || link.contains("http://") || link.contains("ftp://")){
          _link = link;
        }
        //Si está mal escrito, entonces cargar otra cosa.
        else{
          _link = _getLinkDefect();
        }
      }
    }
  }

  ///ResourceLink: Convertir a link valido de Google Drive.
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

  ///ResourceLink: Convertir a link valido de Dropbox.
  String _convertLinkToDropbox(String link) {
    String url = link;
    //https://www.dropbox.com/scl/fi/xew3uxohs815e1hmvnyxx/Hot-wheels.png?rlkey=1b00aiutbrne1pkn21gjq77lz&dl=0
    if (url.contains("&dl=0")) {
      url = url.replaceAll("&dl=0", "&dl=1");
    }

    return url;
  }

  ///ResourceLink: Devuelve el link por defecto.
  String _getLinkDefect() {
    if (_mode==ResourceLinkMode.imageJPG){
      return "https://drive.google.com/uc?export=view&id=1Mh8yFhGtvhq7AkKzs09jad8d5pjwADKi";
    }
    else{
      return "https://www.dropbox.com/scl/fi/u4jmep8ynoy3oc0wm6487/prueba.pdf?rlkey=83i5a3dzrfqs91a2se2lh0ez4&dl=1";
    }
  }

  ///ResourceLink: Devuelve el link de imagen.
  String getLink() {
    return _link;
  }
}
