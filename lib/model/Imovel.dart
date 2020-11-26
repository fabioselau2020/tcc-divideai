class Imovel {
  String _nome;
  String _endereco;

  Imovel();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "endereco": this.endereco,
      "urlImagem":
          "https://firebasestorage.googleapis.com/v0/b/fyrer-e9f2e.appspot.com/o/perfil%2Ficon_padrao_fyrer.png?alt=media&token=c76289f3-9523-4d5a-ba76-2e6aa4a3713a"
    };

    return map;
  }

  testNome(String nome) {
    if (nome.isNotEmpty) {
      return true;
    }
  }

  testEndereco(String endereco) {
    if (endereco.isNotEmpty) {
      return true;
    }
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get endereco => _endereco;

  set endereco(String value) {
    _endereco = value;
  }
}
