import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tcc/EditarMeioPagamento.dart';

import 'AddMeioPagamento.dart';

class MeiosPagamentos extends StatefulWidget {
  @override
  _MeiosPagamentosState createState() => _MeiosPagamentosState();
}

class _MeiosPagamentosState extends State<MeiosPagamentos> {
  String _idUsuarioLogado;
  var id = '';
  String uidConviteEnviado;
  String documento;
  String docEnviado;
  IconData icon;
  Future getSolicitacoes() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(_idUsuarioLogado).get();

    String convite = snapshot['convite'];

    var firestore = Firestore.instance;

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .collection("meios_pagamentos")
        .getDocuments();

    var list = querySnapshot.documents;

    list.forEach((doc) {
      id = doc.documentID;
      print(id);
    });

    return querySnapshot.documents;
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditarMeioPagamento(
                  post: post,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMeioPagamento()));
                  },
                  child: Container(
                    height: 60,
                    alignment: AlignmentDirectional.centerStart,
                    margin: EdgeInsets.only(
                        left: 40, right: 40, top: 20, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[400],
                              offset: Offset(5, 3),
                              blurRadius: 5,
                              spreadRadius: 0)
                        ],
                        color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: 15,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              MaterialCommunityIcons.cash_usd,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Novo Meio Pagamento",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                    future: getSolicitacoes(),
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return new Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Oops, parece que você não tem nenhum meio de pagamento",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "¯\\_(ツ)_/¯",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ));
                        }
                      } else {
                        return Container(
                            child: Column(
                          children: <Widget>[
                            Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (_, index) {
                                    final String icone =
                                        snapshot.data[index].data["icon"];
                                    if (icone ==
                                        'MaterialCommunityIcons.cash_usd') {
                                      icon = MaterialCommunityIcons.cash_usd;
                                    } else if (icone ==
                                        'MaterialCommunityIcons.bank') {
                                      icon = MaterialCommunityIcons.bank;
                                    } else {
                                      icon = MaterialCommunityIcons
                                          .credit_card_outline;
                                    }
                                    return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey[400],
                                                  offset: Offset(5, 3),
                                                  blurRadius: 5,
                                                  spreadRadius: 0)
                                            ],
                                            color: Colors.white),
                                        child: Column(
                                          children: <Widget>[
                                            ListTile(
                                              leading: CircleAvatar(
                                                foregroundColor: Colors.white,
                                                child: Icon(icon),
                                                backgroundColor: Colors.blue,
                                              ),
                                              title: Text(
                                                snapshot.data[index]
                                                        .data["nome"] ??
                                                    "",
                                                style: TextStyle(
                                                    fontFamily:
                                                        'SF-Pro-Text-Regular',
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                snapshot.data[index]
                                                        .data["tipo"] ??
                                                    "",
                                                style: TextStyle(
                                                    fontFamily:
                                                        'SF-Pro-Text-Regular',
                                                    color: Colors.black),
                                              ),
                                              trailing: Container(
                                                width: 100,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text("R\$" +
                                                            snapshot.data[index]
                                                                    .data[
                                                                "saldo"] ??
                                                        "")
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                navigateToDetail(
                                                    snapshot.data[index]);
                                              },
                                            ),
                                          ],
                                        ));
                                  }),
                            ),
                          ],
                        ));
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
