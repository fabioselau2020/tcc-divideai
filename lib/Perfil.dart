import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc/AmigosPage.dart';
import 'package:tcc/ImoveisPage.dart';
import 'package:tcc/LoginScreen.dart';
import 'package:tcc/MeiosPagamentos.dart';

import 'ProfilePage.dart';

class AjustesPage extends StatefulWidget {
  @override
  _AjustesPageState createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> {
  String _urlImagemRecuperada;
  String email = "";
  String nome = "";
  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String _idUsuarioLogado = usuarioLogado.uid;

    Firestore dbu = Firestore.instance;
    DocumentSnapshot snapshot =
        await dbu.collection("usuarios").document(_idUsuarioLogado).get();

    if (snapshot['urlImagem'] != null) {
      setState(() {
        _urlImagemRecuperada = snapshot['urlImagem'];
      });
    }

    setState(() {
      nome = snapshot['nome'];
      email = snapshot['email'];
    });
  }

  @override
  void initState() {
    _recuperarDadosUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(children: <Widget>[
              Align(
                alignment: AlignmentDirectional.center,
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0XFF3172B6), Color(0XFF77A6EE)])),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 20),
                          alignment: AlignmentDirectional.centerEnd,
                          width: MediaQuery.of(context).size.width / 2 - 70,
                          child: CircleAvatar(
                            backgroundImage: _urlImagemRecuperada != null
                                ? NetworkImage(_urlImagemRecuperada)
                                : NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/divide-ai-b6983.appspot.com/o/perfil%2Fuser.png?alt=media&token=77c585d6-4e4b-4554-a946-d4006c9defdc"),
                            radius: 40,
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              alignment: AlignmentDirectional.bottomStart,
                              height: 150 / 2,
                              width: MediaQuery.of(context).size.width / 2 + 70,
                              child: Text(
                                "Olá, " + nome ?? '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              alignment: AlignmentDirectional.topStart,
                              height: 150 / 2,
                              width: MediaQuery.of(context).size.width / 2 + 70,
                              child: Text(
                                email ?? '',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListTile(
                    title: Text(
                      "PREFERÊNCIAS",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.indigo,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                    trailing: Container(
                      height: 1,
                      width: 1,
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                    },
                    title: Text(
                      "Meu Perfil",
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  )),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListTile(
                    title: Text(
                      "CADASTROS",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.indigo,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                    trailing: Container(
                      height: 1,
                      width: 1,
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendsPage()));
                    },
                    title: Text(
                      "Amigos",
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  )),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImoveisPage()));
                    },
                    title: Text(
                      "Imóveis",
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  )),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MeiosPagamentos()));
                    },
                    title: Text(
                      "Meios Pagamentos",
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  )),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListTile(
                    title: GestureDetector(
                      child: Text(
                        "LOGOUT",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.indigo,
                          fontFamily: 'Roboto-Regular',
                        ),
                      ),
                      onTap: () {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        auth.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                    ),
                    trailing: Container(
                      height: 1,
                      width: 1,
                    ),
                  )),
            ])));
  }
}
