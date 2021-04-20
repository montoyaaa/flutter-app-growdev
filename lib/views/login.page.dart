import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/login.controller.dart';
import 'package:flutter_app/widgets/input.widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var formKey = GlobalKey<FormState>();
  var isLoading = false;

  String? email;
  String? pass;

  void doLogin(ctx) async {
    if (!formKey.currentState!.validate()) return;
    print('entrou aqui');

    formKey.currentState?.save();

    // ignore: await_only_futures
    final isLogged = await LoginController().doLogin(email!);

    if (!isLogged) {
      // showFailureLogin();
      return;
    }

    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      body: Stack(
        children: [
          Container(
            color: Colors.black38,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                  ),
                  BoxShadow(
                    color: Colors.blueGrey[100]!,
                    spreadRadius: -12.0,
                    blurRadius: 30.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        // color: Colors.white,
                        fit: BoxFit.contain,
                        image: AssetImage("assets/logo-dark.png"),
                        filterQuality: FilterQuality.high,
                        height: 150,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Novo por aqui? ',
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/register');
                                    },
                                  text: 'Crie sua conta!',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: 16,
                                      color: Colors.blueGrey[600],
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      BuildInput(
                        icon: Icons.email,
                        label: 'E-mail',
                        validator: (value) {
                          if (!EmailValidator.validate(value!)) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                        onSaved: (value) => email = value,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BuildInput(
                        icon: Icons.lock,
                        label: 'Password',
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Senha inválida';
                          }

                          return null; // deveria retornar null
                        },
                        onSaved: (value) => pass = value,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration:
                                BoxDecoration(color: Colors.blueGrey[600]),
                            child: IconButton(
                              icon: Icon(
                                // manterConectado ? Icons.check : null,
                                Icons.check,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // setState(() {
                                //   manterConectado = !manterConectado;
                                // });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Mantenha-me conectado',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: Builder(builder: (ctx) {
                            return ElevatedButton(
                              onPressed: isLoading ? null : () => doLogin(ctx),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                primary: Color.fromRGBO(225, 110, 14, 1),
                              ),
                              child: isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
