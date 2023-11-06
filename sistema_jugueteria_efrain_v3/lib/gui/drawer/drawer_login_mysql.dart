import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/drawer/drawer_header_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/mixin_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_elevated_button.dart';

import 'package:sistema_jugueteria_efrain_v3/gui/style/style_text_field.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_mysql_provider.dart';

///Clase DrawerLoginMySQL: Widget que permite controlar las configuraciones del sistema.
@immutable
class DrawerLoginMySQL extends ConsumerStatefulWidget{

  const DrawerLoginMySQL({super.key});

  @override
  ConsumerState<DrawerLoginMySQL>  createState() {
    return _DrawerLoginMySQLState();
  }
}

class _DrawerLoginMySQLState extends ConsumerState<DrawerLoginMySQL> with ContainerParameters {

  late final FormGroup _form;
  static const String _keyURL = "login_url";
  static const String _keyUser = "login_user";
  static const String _keyPassword = "login_password";

  late bool _visiblePassword = false;

  @override
  void initState() {
    super.initState();
    _visiblePassword = false;
    _form = FormGroup({
      _keyURL: FormControl<String>(
        value: ref.read(urlLoginMySQLProvider),
        validators: [Validators.required]
      ),
      _keyUser: FormControl<String>(
        value: ref.read(userLoginMySQLProvider),
        validators: [Validators.required]
      ),
      _keyPassword: FormControl<String>(
        value: ref.read(passwordLoginMySQLProvider),
        validators: [Validators.required]
      )
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getWidgetHeader(context),
        Expanded(child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const Center(child: Text("Datos de Conexión", style: TextStyle(fontWeight: FontWeight.bold))),
            _getWidgetForm(context)
          ],
        ),),
        _getWidgetOptions(context)
      ],
    );
  }

  ///DrawerLoginMySQL: Devuelve el widget de encabezado
  Widget _getWidgetHeader(BuildContext context){
    return DrawerHeaderCustom(
      title: "Login a servidor MySQL",
      description: 'En el servidor MySQL están almacenados los productos de una versión anterior del sistema.'
          ' Para poder acceder a la lista de dichos productos se debe loguear correctamente.',
      width: 400,
      height: 150,
    );
  }

  Widget _getWidgetForm(BuildContext context){
    return SingleChildScrollView(
      child: ReactiveForm(
        formGroup: _form, 
        child: Column(
          children: [
            //URL
            Container(
              margin: getMarginInformationForms(),
              padding: getPaddingInformationForms(),
              decoration: StyleContainer.getDecorationFormControl(),
              child: ReactiveTextField(
                style: StyleTextField.getTextStyleNormal(),
                decoration: StyleTextField.getDecoration("Servidor (por ej. 192.168.0.10)"),
                formControlName: _keyURL,
                textInputAction: TextInputAction.next,
                onSubmitted: (_){
                  setState(() {});
                  _form.focus(_keyUser);
                },
                validationMessages: {
                  ValidationMessage.required: (error) => "(Requerido) Ingrese el código de barras del producto."
                },
              ),
            ),   
            //USER
            Container(
              margin: getMarginInformationForms(),
              padding: getPaddingInformationForms(),
              decoration: StyleContainer.getDecorationFormControl(),
              child: ReactiveTextField(
                style: StyleTextField.getTextStyleNormal(),
                decoration: StyleTextField.getDecoration("Usuario"),
                formControlName: _keyUser,
                textInputAction: TextInputAction.next,
                onSubmitted: (_){
                  setState(() {});
                  _form.focus(_keyPassword);
                },
                validationMessages: {
                  ValidationMessage.required: (error) => "(Requerido) Ingrese el nombre de usuario."
                },
              ),
            ),   
            //PASSWORD
            Container(
              margin: getMarginInformationForms(),
              padding: getPaddingInformationForms(),
              decoration: StyleContainer.getDecorationFormControl(),
              child: Row(
                children: [
                  Expanded(child: ReactiveTextField(
                    style: StyleTextField.getTextStyleNormal(),
                    decoration: StyleTextField.getDecoration("Contraseña"),
                    formControlName: _keyPassword,
                    obscureText: !_visiblePassword,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_){
                      setState(() {});
                    },
                    validationMessages: {
                      ValidationMessage.required: (error) => "(Requerido) Ingrese la contraseña."
                    },
                  ),),
                  SizedBox(
                    width: 50,
                    child: IconButton(
                    onPressed: (){
                      _visiblePassword = !_visiblePassword;
                      setState((){});
                    }, 
                    icon: Icon(_visiblePassword ? Icons.visibility_off  : Icons.visibility)),
                  )
                ],
              )
            ),   
          ],
        )
      ),
    );
  }


  ///DrawerLoginMySQL: Devuelve el widget de opciones
  Widget _getWidgetOptions(BuildContext context){
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: ElevatedButton(
            style: StyleElevatedButton.getStyleLoginCancel(),
            onPressed: () async{
              ResponseAPI response = await ref.read(closeConnectionMySQLProvider.future);
              if (context.mounted){
                ElegantNotificationCustom.showNotificationAPI(context, response);
                Navigator.pop(context);
              }
            },
            child: const Text("Cancelar"),
          )),
          const SizedBox(width: 5,),
          Expanded(child: ElevatedButton(
            style: StyleElevatedButton.getStyleLogin(),
            onPressed: () async {
              //Si los datos son validados, entonces conectar al servidor.
              ref.read(userLoginMySQLProvider.notifier).state = _form.control(_keyUser).value.toString();
              ref.read(passwordLoginMySQLProvider.notifier).state = _form.control(_keyPassword).value.toString();
              ref.read(urlLoginMySQLProvider.notifier).state = _form.control(_keyURL).value.toString();
              //Sincronizar
              ResponseAPI response = await ref.read(connectionMySQLProvider.future);
              if (context.mounted){
                ElegantNotificationCustom.showNotificationAPI(context, response);
                Navigator.pop(context);
              }
            },
            child: const Text("Conectar"),
          )),
        ],
      ),
    );
  }
}