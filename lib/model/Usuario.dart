class Usuario {
  String _nome;
  String _email;
  String _senha;

  Usuario();

  testUsuario() {
    if (_nome.isNotEmpty && _nome.length >= 5) {
      return true;
    }
  }

  testEmail(String email) {
    if (email.contains("@")) {
      return true;
    }
  }

  testSenha() {
    if (_senha.length >= 8) {
      return true;
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
      "urlImagem":
          "https://firebasestorage.googleapis.com/v0/b/fyrer-e9f2e.appspot.com/o/perfil%2Ficon_padrao_fyrer.png?alt=media&token=c76289f3-9523-4d5a-ba76-2e6aa4a3713a"
    };

    return map;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}
