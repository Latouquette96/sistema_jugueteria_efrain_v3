///Clase DatetimeCustom: Modela un conjunto de operaciones que permiten obtener distintas interpretaciones de un DateTime.
class DatetimeCustom {

  ///DatetimeCustom: Devuelve el patron a emplear para validar fechas con formato 'YYYY/MM/DD hh:mm:ss'.
  static Pattern getPattern(){
    return RegExp(r'(\d{4}//?\d\d//?\d\d(\s|T)\d\d:?\d\d:?\d\d)');
  }

  ///DatetimeCustom: Devuelve un entero que representa al DateTime dt dado en formato yyyymmddhhmmss.
  static int getDatetimeInteger(DateTime dt) {
    int datetime = 0;
    datetime += dt.second; //ss
    datetime += dt.minute * 100; //mmss
    datetime += dt.hour * 10000; //hhmmss
    datetime += dt.day * 1000000; //ddhhmmss
    datetime += dt.month * 100000000; //mmddhhmmss
    datetime += dt.year * 10000000000; //yyyymmddhhmmss.

    return datetime;
  }

  ///DatetimeCustom: Devuelve un entero que representa al tiempo/hora actual en formato yyyymmddhhmmss.
  static int getDatetimeIntegerNow() {
    return getDatetimeInteger(DateTime.now());
  }

  ///DatetimeCustom: Devuelve una cadena que representa a la fecha y hora dada en formato yyyy/mm/dd hh:mm/ss.
  static String getDatetimeString(int number) {
    int total = number;

    int year = (total ~/ 10000000000);
    total = total - (year * 10000000000);

    int mes = (total ~/ 100000000);
    total = total - (mes * 100000000);

    int day = (total ~/ 1000000);
    total = total - (day * 1000000);

    int hours = (total ~/ 10000);
    total = total - (hours * 10000);

    int minutes = (total ~/ 100);
    total = total - (minutes * 100);

    int seconds = total;

    String dateString = "$year"
        "/${(mes < 10 ? "0$mes" : mes)}"
        "/${(day < 10 ? "0$day" : day)}"
        " "
        "${(hours < 10 ? "0$hours" : hours)}"
        ":${(minutes < 10 ? "0$minutes" : minutes)}"
        ":${(seconds < 10 ? "0$seconds" : seconds)}";

    return dateString;
  }

  ///DatetimeCustom: Devuelve una cadena que representa a la fecha y hora actual en formato yyyy/mm/dd hh:mm/ss.
  static String getDatetimeStringNow() {
    return getDatetimeString(getDatetimeIntegerNow());
  }

  ///DatetimeCustom: Realiza el parsing de una fecha en formato string (según el patrón) y la retorna en formato entero.
  static int parseStringDatetime(String datetime){
    List<String> value = datetime.split(" ");
    List<int> date = value[0].split("/").map((e) => int.parse(e)).toList();
    List<int> time = value[1].split(":").map((e) => int.parse(e)).toList();

    DateTime dt = DateTime(date[0], date[1], date[2], time[0], time[1], time[2]);
    return getDatetimeInteger(dt);
  }
}
