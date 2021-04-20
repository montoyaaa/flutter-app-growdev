class LoginController {
  bool doLogin(String email) {
    if (email != 'teste@teste.com') {
      print('nao validou $email');
      return false;
    }
    print('validou $email');
    return true;
  }
}
