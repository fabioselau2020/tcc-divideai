import 'package:tcc/model/Amigo.dart';
import 'package:flutter_test/flutter_test.dart';

//TESTES DO AMIGO, FAZ O TESTE NO CAMPO USUARIO/EMAIL.

void main() {
  test('Teste de validação Usuario', () {
    var amigo = Amigo();
    amigo.testUsuario("Casa 123");
    expect(amigo.testUsuario("Casa 123"), true);
  });
}
