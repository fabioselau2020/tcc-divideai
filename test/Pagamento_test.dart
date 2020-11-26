import 'package:tcc/model/Pagamento.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Teste de validação Nome', () {
    var pagamento = Pagamento();
    pagamento.testNome("Selau");
    expect(pagamento.testNome("Selau"), true);
  });
  test('Teste de validação Valor', () {
    var pagamento = Pagamento();
    pagamento.testValor(0.1);
    expect(pagamento.testValor(0.1), true);
  });
  test('Teste de validação Status', () {
    var pagamento = Pagamento();
    pagamento.testStatus("Pago");
    expect(pagamento.testStatus("Pago"), true);
  });
  test('Teste de validação Data de Pagamento', () {
    var pagamento = Pagamento();
    final now = new DateTime.now();
    pagamento.testDataPagamento(now);
    expect(pagamento.testDataPagamento(now), true);
  });
  test('Teste de validação Data de Vencimento', () {
    var pagamento = Pagamento();
    final now = new DateTime.now();
    pagamento.testDataVencimento(now);
    expect(pagamento.testDataVencimento(now), true);
  });
}
