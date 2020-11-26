import 'package:tcc/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tcc/NovoAmigo.dart';

import 'HomePage.dart';

class SolicitacoesAmigos extends StatefulWidget {
  @override
  _SolicitacoesAmigosState createState() => _SolicitacoesAmigosState();
}

class _SolicitacoesAmigosState extends State<SolicitacoesAmigos> {
  String _idUsuarioLogado;
  var id = '';
  String uidConviteEnviado;
  String documento;
  bool isNull;
  String Mensagem = "¯\_(ツ)_/¯";

  Future getSolicitacoes() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(_idUsuarioLogado).get();

    if (snapshot == null) {
      isNull = false;
    }

    String convite = snapshot['convite'];

    var firestore = Firestore.instance;

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .collection("amigos")
        .where("status", isEqualTo: 'Pendente')
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
    print(uidConviteEnviado);

    return querySnapshot.documents;
  }

  _pedidoAceito(String doc, String docEnviado) async {
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
    Future.delayed(const Duration(milliseconds: 500), () {
      _mensagem();
    });
  }

  _mensagem() {
    Fluttertoast.showToast(
        msg:
            "Pedido confirmado, agora você já consegue dividir as contas com esse usuário.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
        fontSize: 14.0);
    Future.delayed(const Duration(milliseconds: 500), () {
      _rotaAmigos();
    });
  }

  _rotaAmigos() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeNewDesignBar()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitações"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF73AEF5),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add_circle,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NovoAmigo()));
          }),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              FutureBuilder(
                  future: getSolicitacoes(),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Oops, parece que você não tem nenhuma solicitação",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "¯\\_(ツ)_/¯",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 10),
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                              leading: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: snapshot
                                                                  .data[index]
                                                                  .data[
                                                              "urlImagem"] !=
                                                          null
                                                      ? NetworkImage(snapshot
                                                          .data[index]
                                                          .data["urlImagem"])
                                                      : NetworkImage(
                                                          "https://firebasestorage.googleapis.com/v0/b/divide-ai-b6983.appspot.com/o/perfil%2Fuser.png?alt=media&token=77c585d6-4e4b-4554-a946-d4006c9defdc")),
                                              title: Text(
                                                snapshot
                                                    .data[index].data["nome"],
                                                style: TextStyle(
                                                    fontFamily:
                                                        'SF-Pro-Text-Regular',
                                                    color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                snapshot
                                                    .data[index].data["email"],
                                                style: TextStyle(
                                                    fontFamily:
                                                        'SF-Pro-Text-Regular',
                                                    color: Colors.white),
                                              ),
                                              trailing: Container(
                                                width: 100,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    _idUsuarioLogado !=
                                                            uidConviteEnviado
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              snapshot.data[index]
                                                                          .data["status"] ==
                                                                      "Aceito"
                                                                  ? Padding(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        "Conectados!",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.green),
                                                                      ),
                                                                    )
                                                                  : IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .check_circle_outline,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        _pedidoAceito(
                                                                            snapshot.data[index].data["doc"],
                                                                            snapshot.data[index].data["docEnviado"]);
                                                                        print(
                                                                            "Apertado");
                                                                        print(
                                                                            id);
                                                                      },
                                                                    ),
                                                            ],
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              snapshot.data[index]
                                                                          .data["status"] ==
                                                                      "Aceito"
                                                                  ? Padding(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        "Conectados!",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.green),
                                                                      ),
                                                                    )
                                                                  : Padding(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        "Pendente",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.red),
                                                                      ),
                                                                    ),
                                                            ],
                                                          )
                                                  ],
                                                ),
                                              )),
                                          Divider(
                                            color: Colors.black,
                                            indent: 10,
                                            endIndent: 10,
                                          )
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
      ),
    );
  }
}
