import 'package:flutter/material.dart';

///Clase HomeWidget: Modela la clase de inicio con la información relevante de cada sección.
class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeWidgetState();
  }
}

class _HomeWidgetState extends State<HomeWidget>{

  @override
  Widget build(BuildContext context) {
    List<ListTile> list = [];

    //Info: Login
    list.add(const ListTile(
          title: Text("Login", style: TextStyle(color: Colors.yellow, fontSize: 16),),
          subtitle: Text("El login es necesario para poder recuperar toda la información (productos, distribuidoras, etc) almacenada en el servidor.", style: TextStyle(color: Colors.white),),
          leading: Icon(Icons.login, color: Colors.yellow, size: 16,),
        ));
    //Info: Productos
    list.add(const ListTile(
      title: Text("Producto > Catálogo de productos", style: TextStyle(color: Colors.yellow, fontSize: 16),),
      subtitle: Text("En catálogo de productos podrá ver los productos disponibles en el sistema, ademas "
          "de podeer realizar otras tareas:\n"
          "• Exportar los productos (ya sea todos o los filtrados) a un archivo pdf.\n"
          "• Seleccionar productos para compartir o hacer un pdf con los productos seleccionados.\n"
          "• Filtrar productos por varias propiedades."
          "• Insertar, actualizar o eliminar productos."
          "• Los productos existentes pueden ser editados ya sea haciendo doble click en la fila en el botón editar.", style: TextStyle(color: Colors.white),),
      leading: Icon(Icons.list_alt, color: Colors.yellow, size: 16,),
    ));
    //Info: Lector PDF
    list.add(const ListTile(
      title: Text("Producto > Visor PDF", style: TextStyle(color: Colors.yellow, fontSize: 16),),
      subtitle: Text("En el Lector PDF se puede abrir un archivo pdf almacenado en la computadora "
          "o en internet y hacer uso de las siguientes funciones:\n"
          "• Buscar productos (por su código de barra) en el archivo.\n"
          "• Actualizar el precio base y final del producto.", style: TextStyle(color: Colors.white),),
      leading: Icon(Icons.picture_as_pdf, color: Colors.yellow, size: 16,),
    ));
    //Info: Distribuidores
    list.add(const ListTile(
      title: Text("Distribuidora > Catálogo de distribuidoras", style: TextStyle(color: Colors.yellow, fontSize: 16),),
      subtitle: Text("En catálogo de distribuidoras podrá ver los distribuidoras disponibles en el sistema, ademas "
          "de podeer realizar otras tareas:\n"
          "• Insertar, actualizar o eliminar distribuidoras.\n"
          "• Cargar facturas de compras realizadas a cada distribuidoras.\n"
          "• Las distribuidoras existentes pueden ser editados ya sea haciendo doble click en la fila en el botón editar.", style: TextStyle(color: Colors.white),),
      leading: Icon(Icons.list_alt, color: Colors.yellow, size: 16,),
    ));
    //Info: Configuración
    list.add(const ListTile(
      title: Text("Archivo > Configuraciones", style: TextStyle(color: Colors.yellow, fontSize: 16),),
      subtitle: Text("En Configuraciones se puede modificar los directorios donde se descargarán "
          "las imágenes de producto y donde se almacenarán los archivos pdfs creados.", style: TextStyle(color: Colors.white),),
      leading: Icon(Icons.settings, color: Colors.yellow, size: 16,),
    ));
    //Info: Importar
    list.add(const ListTile(
      title: Text("Archivo > Importar desde MySQL", style: TextStyle(color: Colors.yellow, fontSize: 16),),
      subtitle: Text("En Importar desde MySQL se puede visualizar los productos que se encuentran en el servidor MySQL (base de datos del antiguo sistema) "
          "y es posible importar todos los productos que aparezcan en el catálogo.", style: TextStyle(color: Colors.white),),
      leading: Icon(Icons.download, color: Colors.yellow, size: 16,),
    ));

    return SingleChildScrollView(
      child: Column(
        children: list,
      ),
    );
  }

}