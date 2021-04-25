import 'dart:io';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_app/controllers/user_form.controller.dart';
import 'package:flutter_app/widgets/input.widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/models/user.model.dart';

class UserFormPage extends StatefulWidget {
  UserFormPage({Key? key, this.title, this.user}) : super(key: key);

  final String? title;
  final User? user;

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  var isLoading = false;
  var formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File? imageFile;
  final cepController = TextEditingController();
  User? user = User.empty();
  String address = '';

  bool isLoadingCep = false;

  String? nome;
  String? email;
  String? cpf;
  String? cep;
  String? rua;
  String? numero;
  String? bairro;
  String? cidade;
  String? uf;
  String? pais;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      user = widget.user;
      cepController.text = widget.user!.cep!;
    }
  }

  void changePhoto() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => user?.pathImage = pickedFile.path);
    }
  }

  void doSubmit(ctx) {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState?.save();

    final isSubmitted = Service().doSubmit(
      user: user!,
      nome: nome!,
      email: email!,
      cpf: cpf!,
      cep: cep!,
      address: address,
      image: '$imageFile!.path',
    );

    if (!isSubmitted) {
      showFailureSubmit();
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text('Deu certo!'),
          contentPadding: EdgeInsets.all(20),
          children: [
            Text('$imageFile!.path'),
            Text('Nome: $nome'),
            Text('Email: $email'),
            Text('CPF: $cpf'),
            Text('CEP: $cep'),
            Text('Rua: $rua'),
            Text('Numero: $numero'),
            Text('Bairro: $bairro'),
            Text('Cidade: $cidade'),
            Text('UF: $uf'),
            Text('Pais: $pais'),
          ],
        );
      },
    );
  }

  void showFailureSubmit() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Voce precisa preencher o formulário corretamente',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  void getAddress() async {
    try {
      setState(() {
        isLoadingCep = true;
      });
      var cep = cepController.text.replaceAll('.', '').replaceAll('-', '');

      var response = await Dio().get('https://viacep.com.br/ws/$cep/json/');

      final resultAddress = response.data as Map<String, dynamic>;

      setState(() {
        isLoadingCep = false;
        rua = resultAddress['logradouro'];
        bairro = resultAddress['bairro'];
        cidade = resultAddress['localidade'];
        uf = resultAddress['uf'];
        pais = pais == 'Brasil' && uf == null ? '' : 'Brasil';
        address =
            '${resultAddress['logradouro']}, ${resultAddress['cep']} - ${resultAddress['bairro']}, ${resultAddress['localidade']} - ${resultAddress['uf']}';
      });
      print(resultAddress);
    } catch (e) {
      setState(() {
        isLoadingCep = false;
      });
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        backwardsCompatibility: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: imageFile != null
                            ? Image.network(
                                imageFile!.path,
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                              )
                            : InkWell(
                                onTap: changePhoto,
                                child: Icon(
                                  Icons.photo_camera_outlined,
                                  size: 40,
                                  color: Color.fromRGBO(225, 110, 14, 1),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                BuildInput(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nome inválido';
                    }

                    return null;
                  },
                  label: 'Nome completo',
                  onSaved: (value) => nome = value,
                ),
                SizedBox(
                  height: 10,
                ),
                BuildInput(
                  validator: (value) {
                    if (!EmailValidator.validate(value!)) {
                      return 'Email inválido';
                    }

                    return null;
                  },
                  label: 'E-mail',
                  onSaved: (value) => email = value,
                ),
                SizedBox(
                  height: 10,
                ),
                BuildInput(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'CPF inválido';
                    }

                    return null;
                  },
                  label: 'CPF',
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  onSaved: (value) => cpf = value,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: BuildInput(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'CEP inválido';
                          }

                          return null;
                        },
                        label: 'CEP',
                        controller: cepController,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CepInputFormatter(),
                        ],
                        keyboardType: TextInputType.number,
                        onSaved: (value) => cep = value,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: Builder(builder: (ctx) {
                        return ElevatedButton(
                          onPressed: isLoadingCep ? null : () => getAddress(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            primary: Color.fromRGBO(225, 110, 14, 1),
                            padding: new EdgeInsets.symmetric(
                                vertical: 25.0, horizontal: 20.0),
                          ),
                          child: isLoadingCep
                              ? CircularProgressIndicator(
                                  backgroundColor:
                                      Color.fromRGBO(225, 110, 14, 1),
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                    ),
                                    Text('Buscar CEP'),
                                  ],
                                ),
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: BuildInput(
                        controller: TextEditingController(text: rua),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Rua inválida';
                          }

                          return null;
                        },
                        label: 'Rua',
                        onSaved: (value) => rua = value,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: BuildInput(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Número inválido';
                          }

                          return null;
                        },
                        label: 'Número',
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        onSaved: (value) => numero = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: BuildInput(
                        controller: TextEditingController(text: bairro),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bairro inválido';
                          }

                          return null;
                        },
                        label: 'Bairro',
                        onSaved: (value) => bairro = value,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: BuildInput(
                        controller: TextEditingController(text: cidade),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Cidade inválida';
                          }

                          return null;
                        },
                        label: 'Cidade',
                        onSaved: (value) => cidade = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: BuildInput(
                        controller: TextEditingController(text: uf),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'UF inválido';
                          }

                          return null;
                        },
                        label: 'UF',
                        onSaved: (value) => uf = value,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: BuildInput(
                        controller: TextEditingController(text: pais),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'País inválido';
                          }

                          return null;
                        },
                        label: 'País',
                        onSaved: (value) => pais = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: Builder(builder: (ctx) {
                    return ElevatedButton(
                      onPressed: isLoading ? null : () => doSubmit(ctx),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        primary: Color.fromRGBO(225, 110, 14, 1),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              'Cadastrar',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
