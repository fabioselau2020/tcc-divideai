import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  String uidUsuarioLogado;
  String nome;
  String email;
  String usuario;
  String urlImagem;

  void verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    if (usuarioLogado == null) {
      print("Usuário não logado!");
    }else{
      recuperarDadosUsuario();
    }
  }
  
  void recuperarUidUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    uidUsuarioLogado = usuarioLogado.uid;
  }

  void recuperarDadosUsuario() async {
    recuperarUidUsuario();
    Firestore dbu = Firestore.instance;
    DocumentSnapshot snapshot =
        await dbu.collection("usuarios").document(uidUsuarioLogado).get();
    nome = snapshot["nome"];
    email = snapshot["email"];
    usuario = snapshot["usuario"];
    urlImagem = snapshot["urlImagem"];
  }
}
