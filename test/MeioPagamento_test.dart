import 'package:tcc/model/MeioPagamento.dart';
import 'package:flutter_test/flutter_test.dart';

//TESTES DO MEIO DE PAGAMENTO, FAZ O TESTE NOS CAMPOS NOME, SALDO E CATEGORIA.

void main() {
  test('Teste de validação Nome', () {
    var meioPagamento = MeioPagamento();
    meioPagamento.testNome("Casa 123");
    expect(meioPagamento.testNome("Casa 123"), true);
  });
  test('Teste de validação do Saldo', () {
    var meioPagamento = MeioPagamento();
    meioPagamento.testSaldo("2500");
    expect(meioPagamento.testNome("2500"), true);
  });
  test('Teste de validação da Categoria', () {
    var meioPagamento = MeioPagamento();
    meioPagamento.testCategoria("Banco");
    expect(meioPagamento.testNome("Banco"), true);
  });
}
