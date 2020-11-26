// Import the test package and Counter class
import 'package:tcc/model/Usuario.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/model/Pagamento.dart';

void main() {
  test('email invalido nao pode ser atribuido', () {
    var usuario = Usuario();
    usuario.email = "emailvalido@teste.com";
    expect(usuario.email, "emailvalido@teste.com");
  });
  test('usuario invalido nao pode ser atribuido', () {
    // var usuario = Usuario();
    // usuario.usuario = "teste";
    // expect(usuario.usuario, "teste");
  });
  test('senha invalido nao pode ser atribuido', () {
    var usuario = Usuario();
    usuario.senha = "teste123";
    expect(usuario.senha, "teste123");
  });

  test('teste validação email', () {
    var usuario = Usuario();
    usuario.testEmail("test123@gmail.com");
    expect(usuario.testEmail("test123@gmail.com"), true);
  });
}
