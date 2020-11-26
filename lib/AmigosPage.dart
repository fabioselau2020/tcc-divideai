//import 'package:app/NovoAmigo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tcc/AddAmigo.dart';

import 'NovoAmigo.dart';
import 'Solicitacoes.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  String _idUsuarioLogado;
  var id = '';
  String uidConviteEnviado;
  String documento;
  String docEnviado;

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
        .collection("amigos")
        .where("status", isEqualTo: "Aceito")
        .getDocuments();

    var list = querySnapshot.documents;

    list.forEach((doc) {
      id = doc.documentID;
      print(id);
    });

    DocumentSnapshot docs = await db
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .collection("amigos")
        .document(id)
        .get();
    uidConviteEnviado = docs['uidEnviado'];
    documento = docs['doc'];
    docEnviado = docs['docEnviado'];
    print(uidConviteEnviado);

    return querySnapshot.documents;
  }

  _pedidoAceito(String doc) async {
    Firestore db = Firestore.instance;
    Map<String, dynamic> dados = {
      "status": "Aceito",
    };
    Map<String, dynamic> dadosLogado = {
      "status": "Aceito",
    };

    db
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .collection('amigos')
        .document(doc)
        .updateData(dados);

    db
        .collection("usuarios")
        .document(uidConviteEnviado)
        .collection('amigos')
        .document(docEnviado)
        .updateData(dadosLogado);
    print("Teste");
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NovoAmigo()));
                  },
                  child: Container(
                    height: 60,
                    alignment: AlignmentDirectional.centerStart,
                    margin: EdgeInsets.only(
                        left: 40, right: 40, top: 20, bottom: 5),
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
                              MaterialCommunityIcons.ghost,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Novo Amigo",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SolicitacoesAmigos()));
                  },
                  child: Container(
                    height: 60,
                    alignment: AlignmentDirectional.centerStart,
                    margin: EdgeInsets.only(
                        left: 40, right: 40, top: 5, bottom: 10),
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
                              MaterialCommunityIcons.account_multiple_check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Solicitações",
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
                                "Oops, parece que você não tem nenhum amigo",
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
                                                    child: snapshot.data[index]
                                                                    .data[
                                                                "urlImagem"] !=
                                                            null
                                                        ? Container()
                                                        : Icon(
                                                            MaterialCommunityIcons
                                                                .ghost,
                                                            color: Colors.white,
                                                          ),
                                                    backgroundColor:
                                                        Colors.blue,
                                                    backgroundImage: snapshot
                                                                    .data[index]
                                                                    .data[
                                                                "urlImagem"] !=
                                                            null
                                                        ? NetworkImage(snapshot
                                                            .data[index]
                                                            .data["urlImagem"])
                                                        : null),
                                                title: Text(
                                                  snapshot
                                                      .data[index].data["nome"],
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'SF-Pro-Text-Regular',
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                  "R\$ 0,00",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'SF-Pro-Text-Regular',
                                                      color: Colors.black),
                                                ),
                                                trailing: Container(
                                                  width: 100,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      _idUsuarioLogado !=
                                                              uidConviteEnviado
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                snapshot.data[index].data[
                                                                            "status"] ==
                                                                        "Aceito"
                                                                    ? Padding(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                5),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .group,
                                                                          color:
                                                                              Colors.green,
                                                                        ))
                                                                    : IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .check_circle_outline,
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                      ),
                                                              ],
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                snapshot.data[index].data[
                                                                            "status"] ==
                                                                        "Aceito"
                                                                    ? Padding(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                5),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .group,
                                                                          color:
                                                                              Colors.green,
                                                                        ))
                                                                    : Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: 5),
                                                                        child:
                                                                            Text(
                                                                          "Pendente",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.red),
                                                                        ),
                                                                      ),
                                                              ],
                                                            )
                                                    ],
                                                  ),
                                                )),
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
