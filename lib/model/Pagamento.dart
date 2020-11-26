class Pagamento {

  String _nome;
  String _valor;
  String _status;
  String _amigos;
  String _dataPagamento;
  String _idUsuarioLogado;
  String _dataVencimento;

  Pagamento();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "uid" : this.idUsuarioLogado,
      "dataVencimento" : this.dataVencimento,
      "amigos": this.amigos,
      "status": this.status,
      "nome" : this.nome,
      "valor" : this.valor,
      "dataPagamento" : this.dataPagamento,
    };
    return map;

  }

  testNome(String nome) {
    if (nome.isNotEmpty) {
      return true;
    }
  }

  testStatus(String status) {
    if (status == "Pago" || status == "Pendente") {
      return true;
    }
  }

  testValor(double valor){
    if(valor > 0){
      return true;
    }
  }

  testDataPagamento(DateTime dataPagamento){
    if(dataPagamento != null){
      return true;
    }
  }
  testDataVencimento(DateTime dataVencimento){
    if(dataVencimento != null){
      return true;
    }
  }


  String get dataVencimento => _dataVencimento;

  set dataVencimento(String value){
    _dataVencimento = value;
  }

  String get dataPagamento => _dataPagamento;

  set dataPagamento(String value) {
    _dataPagamento = value;
  }

  String get valor => _valor;

  set valor(String value) {
    _valor = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get idUsuarioLogado => _idUsuarioLogado;

  set idUsuarioLogado(String value) {
    _idUsuarioLogado = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get amigos => _amigos;

  set amigos(String value) {
    _amigos = value;
  }

}