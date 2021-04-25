import 'package:flutter_app/models/user.model.dart';
import 'package:flutter_app/database/user_database.dart';

class UserRepository {
  UserDatabase _userDB;

  UserRepository(this._userDB);

  Future<bool> save(User user) async {
    try {
      final instance = await _userDB.getInstance();

      final id = await instance.insert('users', user.toMap());
      print('user id: $id');

      return id > 0;
    } catch (e) {
      print(e);
      throw 'Erro ao inserir o usuário';
    }
  }

  Future<bool> update(User user) async {
    try {
      final instance = await _userDB.getInstance();

      final result = await instance.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );

      return result > 0;
    } catch (e) {
      print(e);
      throw 'Erro ao inserir o usuário';
    }
  }

  Future<List<User>> get() async {
    try {
      final instance = await _userDB.getInstance();

      final result = await instance.query('users');

      final users = result.map((user) => User.fromMap(user)).toList();

      return users;
    } catch (e) {
      print(e);
      throw 'Erro ao recuperar os usuário';
    }
  }

  Future<bool> delete(User user) async {
    try {
      final instance = await _userDB.getInstance();

      final result = await instance.delete(
        'users',
        where: 'id == ?',
        whereArgs: [user.id],
      );

      return result > 0;
    } catch (e) {
      print(e);
      throw 'Erro ao excluir o usuário';
    }
  }
}
