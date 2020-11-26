import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tcc/AddImovel.dart';
import 'package:tcc/EditarImovel.dart';

class ImoveisPage extends StatefulWidget {
  @override
  _ImoveisPageState createState() => _ImoveisPageState();
}

class _ImoveisPageState extends State<ImoveisPage> {
  String _idUsuarioLogado;
  var id = '';
  String uidConviteEnviado;
  String documento;
  String docEnviado;
  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditarImovel(
                  post: post,
                )));
  }

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
        .collection("imoveis")
        .getDocuments();

    var list = querySnapshot.documents;

    list.forEach((doc) {
      id = doc.documentID;
      print(id);
    });

    return querySnapshot.documents;
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
                        MaterialPageRoute(builder: (context) => AddImovel()));
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
                              MaterialCommunityIcons.home,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Novo Imóvel",
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
                                                foregroundColor: Colors.white,
                                                child: Icon(
                                                    MaterialCommunityIcons
                                                        .home),
                                                backgroundColor: Colors.blue,
                                              ),
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
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index]
                                                            .data["cidade"] +
                                                        "/" +
                                                        snapshot.data[index]
                                                            .data["UF"])
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
