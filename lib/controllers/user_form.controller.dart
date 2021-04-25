import 'package:flutter_app/models/user.model.dart';

class Service {
  bool doSubmit({
    required User user,
    required String nome,
    required String email,
    required String cpf,
    required String cep,
    required String address,
    required String image,
  }) {
    try {
      user.name = nome;
      user.email = email;
      user.cpf = cpf;
      user.cep = cep;
      user.address = address;
      user.pathImage = image;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
