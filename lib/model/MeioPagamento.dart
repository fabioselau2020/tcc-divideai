class MeioPagamento {
  String _nome;
  String _saldo;
  String _categoria;

  MeioPagamento();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "saldo": saldo,
      "categoria": categoria
    };
    return map;
  }

  testNome(String nome) {
    if (nome.isNotEmpty) {
      return true;
    }
  }

  testSaldo(String saldo) {
    if (saldo.isNotEmpty) {
      return true;
    }
  }

  testCategoria(String categoria) {
    if (categoria.isNotEmpty) {
      return true;
    }
  }

  String get saldo => _saldo;

  set saldo(String value) {
    _saldo = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }
}
