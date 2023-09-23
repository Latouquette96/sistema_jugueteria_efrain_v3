import 'package:gsheets/gsheets.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';

///Clase ExportToDrive: Permite exportar los productos a un archivo en Google Drive.
class ExportToDrive {
  //Atributos de clase
  static final ExportToDrive _instance = ExportToDrive._();

  //Atributos de instancia
  static const _credentials = {
    "type": "service_account",
    "project_id": "jugueteria-efrain",
    "private_key_id": "6e59b5430e2fd18c257d02de5a5778a3f3f2cd45",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDxr6Jt2s4m7U43\n1VHIUYlkXgwtUsbIB8DnPFJGdtLA7ypMfbRl3in8/sY89zaGJtQMfSCWLxcYFRtV\ni2/C83cr1bgLeuWUIdbHe/UpD2lA+57VY72cuZUjsZi0+jQCbEzEUUONEhpU1Hms\ntaxk1FEsrjefWyhvC28jFc7B/2PRu+vvRPIetP/hQEInz8Aws516/iBAjJ5GF9NN\nhdNjdtx+UU+yf5H0LDWUBfOF3PpmcU5JDt9ncIph4Uz18AiSEblrOIQ7qNc0BP1r\ngphVkIfjvoLR2KhqWafs3SkuDndytFwjHrEDsVWxKdYUZFW/xB7CnUgwd1fgBBCO\nU0S+KuhfAgMBAAECggEAIXdzo4if8U38/chBOd7oiohnYUNMGVjRgnOc5PsBNgwo\nLE1f1JdN8yWIZ9rHpw3rYQtWntVIemI51b+oKzOxddVzVcufzMJezmLA0P28Um5F\nUUEteW1NVJL8FVtsJkW+35RtKTSvhr2hV6QUiiXIU8qQEzX5RF8t9YrIhZ6KwPji\n0ITjG+MB8Bjglyyvtvfg6LVNzsJTrPFgHtgqMA2mgJZ6VMzLXaTVVwuQJvcjRsSu\nXzRTx5ahuBaQn5ShxGStkB7n4iiny9vVpAFJ1fHMUCezG90Rnd8TIssDHN/F2vEM\nAprTgCpws9eFgIh9Z3GcnTGn4AlTIQRIH2i8U1sj8QKBgQD5AHyiRKwgbfJgcQgk\niA6u6ARviDUQ+KyvCA+3J0J2SocGzuE0ALvofNifTCD/BxkHS4Ww/0lPd8GtBSyy\n+isC70CV0pzomACqTusHVQzNWuKrcHHDBZdK9XtgbEsUp2xSJwDw6CXfWUDgHOKt\nGcLoZuVta7wFPtiLFhE0v1+feQKBgQD4eoMKSzUU9es20fc6g/SSB+Ws4b/i2pOm\nBzk0kt5RGFCXgDSMilppPzV514eBdEcCXDcJOrJD8w7R85rfT49SSk6Ir3+XfAJ6\nGf+xEcn9rJmDf4ZHkFn1x7tvrMdXxbLehiY101SZSW6p2z2tDQ2YONgC5BETF6p8\n3+c8XbSYlwKBgElzP1COeUfHpuuT7Bb6m3o0rrpHr3+mGyo2coxQZGaIbXQwqnWw\nkb1utmenCUSxT0y7lmAzrehnJxZmpFzXNsDS2nZXfjmOPQP/64xqJjCdUqfHr4cb\nqxlNeGtlBnC9QlKpdrmZgTJ1HZH+c08kfj4XvC2ezgOuGipNBB5PJWHhAoGBALO5\nkYzhhxyJH8AAMO2fQkhZ8/OPOgbxCHi/os33KVzI1IowjlHVRL35nUlq7rVhEHeR\nkbFYRlbFuMN9i1jYqBbiblmJbyV36ia9JWfDMTIOJN+rXsnmjFstQ9LryygedFll\n+L9YA0n4hlXPoZXI6jtfakb1BbCknolCPnQ4ZwczAoGAYMr6udRn+pL8KUPsgDZ1\nDzv9g/JCf9F523FQk+cA2bJqVTt2z/BNmjtQHISNBhkikFyrK38PKevriFVb/gc3\nVA+rjk7HBdTgXbnW0vmrctqSppRevJk8V8yuma9OsYLJIMVgeoezFVlUMEshaP65\nV0FOdhBdGEEfOfqTYgoa6HY=\n-----END PRIVATE KEY-----\n",
    "client_email": "sheets-jugueteria-efrain@jugueteria-efrain.iam.gserviceaccount.com",
    "client_id": "116579868379530782822",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/sheets-jugueteria-efrain%40jugueteria-efrain.iam.gserviceaccount.com"
  }; //Credenciales de Google
  static const _spreadsheetId = '1WOYejqwC81iA_tKHUOCG2YHw6AkaXrXGtKXUt-s2cpY'; //ID de la Sheets destino
  late GSheets _gsheets;
  late Worksheet? _sheet;

  ///Constructor de ExportToDrive
  ExportToDrive._();

  ///ExportToDrive: Inicializa la hoja de cálculo con sus respectivas credenciales.
  Future<void> initialize() async{
    //Inicializa la hoja de calculo con las credenciales
    _gsheets = GSheets(_credentials);
    // fetch spreadsheet by its id
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    // get worksheet by its title
    _sheet = ss.worksheetByTitle('productos');

    //Celdas de encabezado del documento
    await _sheet!.values.insertRow(1,
        ["id", "title",	"description", "google_product_category",	"availability",
          "condition", "price", "link", "image_link",	"additional_image_link", "brand"]);
  }

  ///ExportTODrive: Actualiza la hoja de cálculo con el producto dado.
  Future<void> updateSheets(Product p) async{
    await initialize();

    //Buscar código de barra en el formulario.
    int rowAux = (p.getBarcode()!=null)
      ? await _sheet!.values.rowIndexOf(p.getBarcode()!)
      : await _sheet!.values.rowIndexOf(p.getInternalCode()!);

    //Obtengo la posicion de modificación del registro
    int rowReg = (rowAux==-1)
      ? (await _sheet!.values.allRows()).length + 1
      : rowAux;

    if (p.getStock()==-1){
      //Limpia la fila de producto.
      await _sheet!.clearRow(rowReg);
    }
    else{
      FactoryCategory factoryCategory = FactoryCategory.getInstance();
      SubCategory subCategory = factoryCategory.search(p.getSubcategory()).getValue2()!;
      //Inserta la fila de producto en la fila rowReg
      await _sheet!.values.insertRow(rowReg, [
        (p.getBarcode()!=null) ? p.getBarcode() : p.getInternalCode(),
        p.getTitle(),
        _getDescriptionComplete(p),
        subCategory.getSubCategoryIDGoogle(),
        (p.getStock()==0 ? "available for order" : "in stock"),
        "new",
        "${p.getPricePublic().toStringAsFixed(2)} ARS",
        "https://www.facebook.com/jugueteriaefrain",
        p.getLinkImages()[0],
        _getLinkImageAdditional(p.getLinkImages()),
        p.getBrand()
      ]);
    }
  }

  ///ExportTODrive: Remueve un producto de la hoja de cálculo.
  Future<void> removeSheets(Product p) async{
    await initialize();

    //Buscar código de barra en el formulario.
    int rowAux = (p.getBarcode()!=null)
        ? await _sheet!.values.rowIndexOf(p.getBarcode()!)
        : await _sheet!.values.rowIndexOf(p.getInternalCode()!);

    //Si se encontró la fila del producto.
    if (rowAux>0){
      await _sheet!.clearRow(rowAux);
    }
  }

  ///ExportToDrive: Devuelve los links adicionales de imagen en un solo string.
  String _getLinkImageAdditional(List<ResourceLink> list){
    List<ResourceLink> listExtra = list.sublist(1);
    String toReturn = "";

    if (listExtra.isNotEmpty){
      toReturn = listExtra[0].getLink();

      for (int i=1; i<listExtra.length; i++){
        toReturn = "$toReturn, ${listExtra[i].getLink()}";
      }
    }

    return toReturn;
  }

  ///ExportToDrive: Devuelve la descripcion con medidas.
  String _getDescriptionComplete(Product p){
    String description = p.getDescription();
    for (String size in p.getSizes()){
      description = "$description\n\n$size";
    }

    return description;
  }

  ///ExportToDrive: Devuelve la instancia en ejecución.
  static ExportToDrive getInstance(){
    return _instance;
  }
}