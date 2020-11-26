import 'package:tcc/model/Amigo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Teste de validação Usuario', () {
    var amigo = Amigo();
    amigo.testUsuario("Casa 123");
    expect(amigo.testUsuario("Casa 123"), true);
  });
  test('Teste de validação Endereco', () {
    var amigo = Amigo();
    amigo.testStatus("Aprovado");
    expect(amigo.testStatus("Aprovado"), true);
  });
}
