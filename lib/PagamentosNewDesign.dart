import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

class PagamentosNewDesign extends StatefulWidget {
  @override
  _PagamentosNewDesignState createState() => _PagamentosNewDesignState();
}

class _PagamentosNewDesignState extends State<PagamentosNewDesign>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  double valorDividido = 0;
  double valor;
  _listenToData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String _idUserLogado = usuarioLogado.uid;

    Firestore.instance
        .collection("pagamentos")
        .where("amigos", arrayContains: _idUserLogado)
        .where("status", isEqualTo: "Pago")
        .snapshots()
        .listen((snap) {
      snap.documents.forEach((d) {
        if (!mounted) return;
        setState(() {
          valor = double.tryParse(d.data["valorDividido"].toString()) + 0.00;
          print(d.data["valorDividido"]);
          valorDividido = valorDividido + valor;
        });
      });
    });
    print("VALOR TOTAL: " + valorDividido.toString());
  }

  @override
  void initState() {
    super.initState();
    _listenToData();
    _controller = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0XFF3172B6), Color(0XFF77A6EE)])),
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 30, right: 10),
                            child: CircleAvatar(
                              child: Icon(
                                Icons.person,
                                size: 30,
                              ),
                              radius: 27,
                            ),
                          ),
                          Text(
                            "Olá, Fabio",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Esse mês você já gastou",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              "R\$ " + valorDividido.toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Container(
                  height: MediaQuery.of(context).size.height,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  child: DefaultTabController(
                      length: 3,
                      child: Scaffold(
                        appBar: TabBar(
                          indicatorColor: Colors.blue,
                          labelColor: Colors.blue,
                          tabs: <Widget>[
                            Tab(
                                child: Text('Todos',
                                    style: TextStyle(color: Colors.grey))),
                            Tab(
                                child: Text('Particular',
                                    style: TextStyle(color: Colors.grey))),
                            Tab(
                                child: Text('Amigos',
                                    style: TextStyle(color: Colors.grey))),
                          ],
                        ),
                        body: TabBarView(
                          children: [
                            PagamentosTodos(),
                            PagamentosParticular(),
                            PagamentosAmigos(),
                          ],
                        ),
                      ))),
            ])));
  }
}

class PagamentosTodos extends StatefulWidget {
  @override
  _PagamentosTodosState createState() => _PagamentosTodosState();
}

class _PagamentosTodosState extends State<PagamentosTodos> {
  IconData icon;
  @override
  Widget build(BuildContext context) {
    Future getPagamentosPendentes() async {
      String _idUsuarioLogado;
      FirebaseAuth auth = FirebaseAuth.instance;
      //auth.signOut();
      FirebaseUser usuarioLogado = await auth.currentUser();
      _idUsuarioLogado = usuarioLogado.uid;

      var firestore = Firestore.instance;

      QuerySnapshot dados = await firestore
          .collection("pagamentos")
          .where("amigos", arrayContains: _idUsuarioLogado)
          .orderBy("dataVencimento", descending: true)
          .getDocuments();

      return dados.documents;
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                child: FutureBuilder(
                    future: getPagamentosPendentes(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 15),
                            Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              ),
                            )
                          ],
                        );
                      } else {
                        return Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  color: Colors.white,
                                  height: 400,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (_, index) {
                                        String dataVencimento =
                                            DateFormat('dd/mM/yyyy').format(
                                                snapshot.data[index]
                                                    .data["dataVencimento"]
                                                    .toDate());

                                        final String icone = snapshot
                                            .data[index].data["iconCategoria"];
                                        if (icone == 'Icons.home') {
                                          icon = Icons.home;
                                        }
                                        if (icone == 'MaterialIcons.flash_on') {
                                          icon = MaterialIcons.flash_on;
                                        }
                                        if (icone ==
                                            'MaterialCommunityIcons.water') {
                                          icon = MaterialCommunityIcons.water;
                                        }
                                        if (icone ==
                                            'MaterialCommunityIcons.wifi_strength_4') {
                                          icon = MaterialCommunityIcons
                                              .wifi_strength_4;
                                        }
                                        if (icone ==
                                            'MaterialCommunityIcons.food_fork_drink') {
                                          icon = MaterialCommunityIcons
                                              .food_fork_drink;
                                        }
                                        if (icone ==
                                            'MaterialCommunityIcons.dots_horizontal') {
                                          icon = MaterialCommunityIcons
                                              .dots_horizontal;
                                        }
                                        // IconData icon = iconSnapshot;

                                        return GestureDetector(
                                          child: Container(
                                              color: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 37, vertical: 20),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.blue,
                                                            child: Icon(
                                                              icon,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                "R\$ " +
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .data["valor"],
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'SF-Pro-Text-Regular',
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                              Text(
                                                                "Dividido em " +
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .data[
                                                                            "qtde"]
                                                                        .toString() +
                                                                    " pessoas",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'SF-Pro-Text-Regular',
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            dataVencimento
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          Text(
                                                            "R\$ " +
                                                                snapshot
                                                                    .data[index]
                                                                    .data[
                                                                        "valorDividido"]
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .blue[600]),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Divider(
                                                    color: Colors.black,
                                                    indent: 10,
                                                    endIndent: 10,
                                                  )
                                                ],
                                              )),
                                          onTap: () => {},
                                        );
                                      }),
                                ),
                              ],
                            ));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PagamentosParticular extends StatefulWidget {
  @override
  _PagamentosParticularState createState() => _PagamentosParticularState();
}

class _PagamentosParticularState extends State<PagamentosParticular> {
  @override
  Widget build(BuildContext context) {
    Future getPagamentosParticular() async {
      String _idUsuarioLogado;
      FirebaseAuth auth = FirebaseAuth.instance;
      //auth.signOut();
      FirebaseUser usuarioLogado = await auth.currentUser();
      _idUsuarioLogado = usuarioLogado.uid;

      var firestore = Firestore.instance;

      QuerySnapshot dados = await firestore
          .collection("pagamentos")
          .where("amigos", arrayContains: _idUsuarioLogado)
          .where("qtde", isEqualTo: 1)
          .orderBy("dataVencimento", descending: true)
          .getDocuments();

      return dados.documents;
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                child: FutureBuilder(
                    future: getPagamentosParticular(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 15),
                            Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              ),
                            )
                          ],
                        );
                      } else {
                        return Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  color: Colors.white,
                                  height: 400,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (_, index) {
                                        String dataVencimento =
                                            DateFormat('dd/mM/yyyy').format(
                                                snapshot.data[index]
                                                    .data["dataVencimento"]
                                                    .toDate());
                                        return GestureDetector(
                                          child: Container(
                                              color: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 37, vertical: 20),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.blue,
                                                            child: Image.network(snapshot
                                                                    .data[index]
                                                                    .data[
                                                                "iconCategoria"]),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                "R\$ " +
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .data["valor"],
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'SF-Pro-Text-Regular',
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                              Text(
                                                                "Dividido em " +
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .data[
                                                                            "qtde"]
                                                                        .toString() +
                                                                    " pessoas",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'SF-Pro-Text-Regular',
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            dataVencimento
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          Text(
                                                            "R\$ " +
                                                                snapshot
                                                                    .data[index]
                                                                    .data[
                                                                        "valorDividido"]
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .blue[600]),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Divider(
                                                    color: Colors.black,
                                                    indent: 10,
                                                    endIndent: 10,
                                                  )
                                                ],
                                              )),
                                          onTap: () => {},
                                        );
                                      }),
                                ),
                              ],
                            ));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PagamentosAmigos extends StatefulWidget {
  @override
  _PagamentosAmigosState createState() => _PagamentosAmigosState();
}

class _PagamentosAmigosState extends State<PagamentosAmigos> {
  @override
  Widget build(BuildContext context) {
    Future getPagamentosParticular() async {
      String _idUsuarioLogado;
      FirebaseAuth auth = FirebaseAuth.instance;
      //auth.signOut();
      FirebaseUser usuarioLogado = await auth.currentUser();
      _idUsuarioLogado = usuarioLogado.uid;

      var firestore = Firestore.instance;

      QuerySnapshot dados = await firestore
          .collection("pagamentos")
          .where("amigos", arrayContains: _idUsuarioLogado)
          .where("qtde", isGreaterThan: 1)
          .orderBy("qtde", descending: true)
          .orderBy("dataVencimento", descending: true)
          .getDocuments();

      return dados.documents;
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                child: FutureBuilder(
                    future: getPagamentosParticular(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 15),
                            Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              ),
                            )
                          ],
                        );
                      } else {
                        return Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  color: Colors.white,
                                  height: 400,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (_, index) {
                                        String dataVencimento =
                                            DateFormat('dd/mM/yyyy').format(
                                                snapshot.data[index]
                                                    .data["dataVencimento"]
                                                    .toDate());
                                        return GestureDetector(
                                          child: Container(
                                              color: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 37, vertical: 20),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.blue,
                                                            child: Image.network(snapshot
                                                                    .data[index]
                                                                    .data[
                                                                "iconCategoria"]),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                "R\$ " +
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .data["valor"],
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'SF-Pro-Text-Regular',
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                              Text(
                                                                "Dividido em " +
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .data[
                                                                            "qtde"]
                                                                        .toString() +
                                                                    " pessoas",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'SF-Pro-Text-Regular',
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            dataVencimento
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          Text(
                                                            "R\$ " +
                                                                snapshot
                                                                    .data[index]
                                                                    .data[
                                                                        "valorDividido"]
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .blue[600]),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Divider(
                                                    color: Colors.black,
                                                    indent: 10,
                                                    endIndent: 10,
                                                  )
                                                ],
                                              )),
                                          onTap: () => {},
                                        );
                                      }),
                                ),
                              ],
                            ));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
