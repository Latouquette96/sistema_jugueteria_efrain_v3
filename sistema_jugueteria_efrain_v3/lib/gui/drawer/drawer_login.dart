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
import 'package:sistema_jugueteria_efrain_v3/provider/config/services_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

///Clase DrawerLogin: Widget que permite controlar las configuraciones del sistema.
@immutable
class DrawerLogin extends ConsumerStatefulWidget{

  const DrawerLogin({super.key});

  @override
  ConsumerState<DrawerLogin>  createState() {
    return _DrawerLoginState();
  }
}

class _DrawerLoginState extends ConsumerState<DrawerLogin> with ContainerParameters {

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
        value: ref.read(urlLoginProvider),
        validators: [Validators.required]
      ),
      _keyUser: FormControl<String>(
        value: ref.read(userLoginProvider),
        validators: [Validators.required]
      ),
      _keyPassword: FormControl<String>(
        value: ref.read(passwordLoginProvider),
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

  ///DrawerLogin: Devuelve el widget de encabezado
  Widget _getWidgetHeader(BuildContext context){
    return DrawerHeaderCustom(
      title: "Login al Servidor",
      description: 'Debe loguearse para acceder a funciones vinculadas con el servidor tales como'
          'la actualización de la base de datos, el carrito de ventas, etc.',
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


  ///DrawerLogin: Devuelve el widget de opciones
  Widget _getWidgetOptions(BuildContext context){
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: ElevatedButton(
            style: StyleElevatedButton.getStyleLoginCancel(),
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          )),
          const SizedBox(width: 5,),
          Expanded(child: ElevatedButton(
            style: StyleElevatedButton.getStyleLogin(),
            onPressed: () async {
              //Si los datos son validados, entonces conectar al servidor.
              ref.read(userLoginProvider.notifier).state = _form.control(_keyUser).value.toString(); 
              ref.read(passwordLoginProvider.notifier).state = _form.control(_keyPassword).value.toString();
              ref.read(urlLoginProvider.notifier).state = _form.control(_keyURL).value.toString();    
              //Sincronizar
              ResponseAPI response = await ref.read(serviceProvider)!.run();
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