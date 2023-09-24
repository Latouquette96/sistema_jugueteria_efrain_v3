import 'package:mysql1/mysql1.dart';

///CLase MySQLConnection: Modela la conexion a la base de datos de MySQL.
class MySQLConnection {

  //Atributos de instancia
  late MySqlConnection? _connection;

  //Singleton
  static final MySQLConnection _instance = MySQLConnection._();

  ///Constructor privado MySQLConnection
  MySQLConnection._(){
    _connection = null;
  }

  Future<void> close() async {
    await _connection?.close();
    _connection=null;
  }

  Future<bool> connect({String server="localhost", String? user, String? pass}) async {
    bool toReturn = true;

    try{
      var settings = ConnectionSettings(
          host: server,
          port: 3306,
          user: user,
          password: pass,
          db: 'db_jugueteria_efrain'
      );
      _connection = await MySqlConnection.connect(settings);
    }
    catch(e){
      toReturn = false;
    }
    return toReturn;
  }

  Future<bool> isConnect() async {
    bool conexionActiva = false;

    if (_connection!=null){
      // Verificar si la conexión está activa
      try {
        await _connection?.query('SELECT 1');
        conexionActiva = true;
      }
      // ignore: empty_catches
      catch (e) {}
    }

    return conexionActiva;
  }

  MySqlConnection? getClient(){
    return _connection;
  }

  ///MySQLConnection: Devuelve la instancia en ejecucion de MySQLConnection.
  static MySQLConnection getConnection(){
    return _instance;
  }
}