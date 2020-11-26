import 'package:tcc/AddPagamentoPage.dart';
import 'package:tcc/AmigosPage.dart';
import 'package:tcc/LoginScreen.dart';
import 'package:tcc/Perfil.dart';
import 'package:tcc/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

import 'PagamentosNewDesign.dart';
import 'PaymentDetail.dart';

class HomeNewDesignBar extends StatefulWidget {
  @override
  _HomeNewDesignBarState createState() => _HomeNewDesignBarState();
}

class _HomeNewDesignBarState extends State<HomeNewDesignBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    HomeNewDesign(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeNewDesign();
  String nome = "";
  String iconUser = "";
  String email = "";
  TextEditingController _controllerNomeFeedback = TextEditingController();
  TextEditingController _controllerMensagemFeedback = TextEditingController();
  TextEditingController _controllerEmailFeedback = TextEditingController();

  _puxarDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      iconUser = prefs.getString("iconUser");
      nome = prefs.getString("nome");
      email = prefs.getString("email");
      _controllerEmailFeedback.text = prefs.getString("email");
      _controllerNomeFeedback.text = prefs.getString("nome");
    });
  }

  _deslogarUsuario() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    super.initState();
    //_puxarDados();
  }

  void _showDialogFeedback() {
    slideDialog.showSlideDialog(
      context: context,
      child: Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 10.0,
          ),
          child: Column(
            children: <Widget>[
              _buildNomeFeedback(),
              _buildEmailFeedback(),
              _buildMensagemTF(),
              _buildEnviarBtn(),
            ],
          ),
        ),
      ),
      barrierColor: Colors.blue.withOpacity(0.5),
      pillColor: Colors.white,
      backgroundColor: Colors.lightBlue,
    );
  }

  Widget _buildEnviarBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => {},
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Enviar',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildEmailFeedback() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'E-mail',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            enabled: false,
            keyboardType: TextInputType.text,
            controller: _controllerEmailFeedback,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Digite seu e-mail',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNomeFeedback() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Nome',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            enabled: false,
            keyboardType: TextInputType.text,
            controller: _controllerNomeFeedback,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Digite seu nome',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMensagemTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Mensagem',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            maxLines: 3,
            keyboardType: TextInputType.text,
            controller: _controllerMensagemFeedback,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.message,
                color: Colors.white,
              ),
              hintText: 'Digite sua mensagem',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _btnFeedback() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _showDialogFeedback();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFF6CA8F1),
        child: Text(
          'Feedback',
          style: TextStyle(
            color: Colors.white54,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
        ),
        child: Scaffold(
          key: _scaffoldKey,
          endDrawer: Drawer(
            elevation: 0,
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  accountName: Text(nome),
                  accountEmail: Text(email),
                  currentAccountPicture: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(iconUser),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Início"),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Perfil"),
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Perfil()));
                    }),
                ListTile(
                    leading: Icon(MaterialCommunityIcons.google_analytics),
                    title: Text("Relatórios"),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => RelatoriosPage()));
                    }),
                Divider(),
                ListTile(
                    leading: Icon(Icons.feedback),
                    title: Text("Feedback"),
                    onTap: () {
                      _showDialogFeedback();
                    }),
                ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Configurações"),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ConfiguracoesPage()));
                    }),
                ListTile(
                    leading: Icon(MaterialCommunityIcons.script_text),
                    title: Text("Termos de Uso"),
                    onTap: () {
                      // debugPrint('toquei no drawer');
                    }),
                Divider(),
                ListTile(
                    leading: Icon(
                      Ionicons.md_log_out,
                      color: Colors.red,
                    ),
                    title: Text(
                      "Sair",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      _deslogarUsuario();
                    }),
              ],
            ),
          ),
          body: PageStorage(
            child: currentScreen,
            bucket: bucket,
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.monetization_on,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddPagamentoPage()));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 10,
            child: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                HomeNewDesign(); // if user taps on this dashboard tab will be active
                            currentTab = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Ionicons.md_home,
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey,
                            ),
                            Text(
                              'Home',
                              style: TextStyle(
                                color:
                                    currentTab == 0 ? Colors.blue : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                PagamentosNewDesign(); // if user taps on this dashboard tab will be active
                            currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Ionicons.md_wallet,
                              color:
                                  currentTab == 1 ? Colors.blue : Colors.grey,
                            ),
                            Text(
                              'Extratos',
                              style: TextStyle(
                                color:
                                    currentTab == 1 ? Colors.blue : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  // Right Tab bar icons

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                FriendsPage(); // if user taps on this dashboard tab will be active
                            currentTab = 2;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Ionicons.md_contacts,
                              color:
                                  currentTab == 2 ? Colors.blue : Colors.grey,
                            ),
                            Text(
                              'Amigos',
                              style: TextStyle(
                                color:
                                    currentTab == 2 ? Colors.blue : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                AjustesPage(); // if user taps on this dashboard tab will be active
                            currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Ionicons.ios_settings,
                              color:
                                  currentTab == 3 ? Colors.blue : Colors.grey,
                            ),
                            Text(
                              'Ajustes',
                              style: TextStyle(
                                color:
                                    currentTab == 3 ? Colors.blue : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class HomeNewDesign extends StatefulWidget {
  @override
  _HomeNewDesignState createState() => _HomeNewDesignState();
}

class _HomeNewDesignState extends State<HomeNewDesign> {
  String nome = "";
  String email = "";
  String qtdePagas = "0";
  String qtdePendentes = "0";
  int qtdePagasIcon = 0;
  String _idUserLogadoPagas;
  double valorDividido = 0;
  double valor;
  String iconUser = "";
  IconData icon;
  _verificarContasPagas() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUserLogadoPagas = usuarioLogado.uid;

    var firestore = Firestore.instance;

    QuerySnapshot dadosPagas = await firestore
        .collection("pagamentos")
        .where("amigos", arrayContains: _idUserLogadoPagas)
        .where("status", isEqualTo: "Pago")
        .getDocuments();
    print("Quantidade de documentos Pagos: " +
        dadosPagas.documents.length.toString());
    if (!mounted) return;
    setState(() {
      qtdePagas = dadosPagas.documents.length.toString();
      qtdePagasIcon = int.tryParse(qtdePagas);
    });
  }

  _verificarContasPendentes() async {
    String _idUserLogadoPendentes;
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUserLogadoPendentes = usuarioLogado.uid;

    var firestore = Firestore.instance;
    DocumentSnapshot snapshot = await firestore
        .collection("usuarios")
        .document(_idUserLogadoPendentes)
        .get();
    iconUser = snapshot['urlImagem'];
    nome = snapshot['nome'];
    email = snapshot['email'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("iconUser", iconUser);
    prefs.setString("nome", nome);
    prefs.setString("email", email);

    QuerySnapshot dadosPendentes = await firestore
        .collection("pagamentos")
        .where("amigos", arrayContains: _idUserLogadoPendentes)
        .where("status", isEqualTo: "Pendente")
        .getDocuments();
    print("Quantidade de documentos Pendentes: " +
        dadosPendentes.documents.length.toString());
    if (!mounted) return;
    setState(() {
      qtdePendentes = dadosPendentes.documents.length.toString();
    });
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentDetail(
                  post: post,
                )));
  }

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
    _listenToData();
    _verificarContasPagas();
    _verificarContasPendentes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future getPagamentosPendentes() async {
      String _idUsuarioLogado;
      FirebaseAuth auth = FirebaseAuth.instance;
      //auth.signOut();
      FirebaseUser usuarioLogado = await auth.currentUser();
      _idUsuarioLogado = usuarioLogado.uid;

      Firestore db = Firestore.instance;
      DocumentSnapshot snapshot =
          await db.collection("usuarios").document(_idUsuarioLogado).get();

      String convite = snapshot['convite'];

      var firestore = Firestore.instance;

      QuerySnapshot dados = await firestore
          .collection("pagamentos")
          .where("amigos", arrayContains: _idUsuarioLogado)
          .orderBy("dataVencimento", descending: true)
          .limit(5)
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
              Container(
                margin: EdgeInsets.only(top: 25),
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Resumo",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 16.0, bottom: 16, top: 16),
                  child: Material(
                    color: Colors.blue[400],
                    elevation: 4,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Gasto esse Mês: R\$ " +
                                    valorDividido.toStringAsFixed(2),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'SF-Pro-Text-Bold'),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              GestureDetector(
                                child: Text(
                                  "Contas Pagas: " + qtdePagas.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'SF-Pro-Text-Bold'),
                                ),
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             PagamentosStatus(
                                  //               status: "Pago",
                                  //             )));
                                },
                              ),
                              Container(
                                width: 1,
                                height: 20,
                                color: Colors.white,
                              ),
                              GestureDetector(
                                child: Text(
                                  "Contas Pendentes: " +
                                      qtdePendentes.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'SF-Pro-Text-Bold'),
                                ),
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             PagamentosStatus(
                                  //               status: "Pendente",
                                  //             )));
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Últimos Pagamentos",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'Montserrat'),
                  ),
                ),
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
                                          onTap: () => navigateToDetail(
                                              snapshot.data[index]),
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

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerValor = TextEditingController();
  TextEditingController _controllerDataPagamento = TextEditingController();
  TextEditingController _controllerDataVencimento = TextEditingController();
  TextEditingController _controllerStatus = TextEditingController();
  String _status;
  String comprovante;
  bool _radioPendente;

  _recuperarDados() {
    setState(() {
      _controllerNome.text = widget.post.data["nome"];
      _controllerValor.text = "R\$ " + widget.post.data["valor"];
      _controllerDataPagamento.text = widget.post.data["dataPagamento"];
      _controllerDataVencimento.text = DateFormat('dd/mM/yyyy')
          .format(widget.post.data["dataVencimento"].toDate());
      comprovante = widget.post.data["urlComprovante"];
      _controllerStatus.text = widget.post.data["status"];
      _status = widget.post.data["status"];

      if (_status == "SingingCharacter.pago") {
        _radioPendente = false;
      } else {
        _radioPendente = true;
      }
    });

    if (_status == "SingingCharacter.pago") {
      _controllerStatus.text = "Pago";
    } else {
      _controllerStatus.text = "Pendente";
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detalhes do Pagamento"),
        ),
        body: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text("Nome"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        enabled: false,
                        controller: _controllerNome,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Nome",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text("Valor"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      enabled: false,
                      controller: _controllerValor,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Valor R\$ (ex. 500,00)",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                    ),
                    _radioPendente == false
                        ? Column(
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Center(
                                child: Text("Data de Pagamento"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                enabled: false,
                                controller: _controllerDataPagamento,
                                keyboardType: TextInputType.datetime,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(32, 16, 32, 16),
                                    hintText: "Não informada.",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(32))),
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text("Data de Vencimento"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      enabled: false,
                      controller: _controllerDataVencimento,
                      keyboardType: TextInputType.datetime,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Não informada.",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text("Status"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      enabled: false,
                      controller: _controllerStatus,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Status",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                    ),
                    comprovante != null
                        ? Center(
                            child: FlatButton(
                            child: Text("Visualizar Comprovante",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageView(
                                            comprovante: comprovante,
                                          )));
                            },
                          ))
                        : Center(
                            child: Text("Nenhum comprovante foi anexado.",
                                style:
                                    TextStyle(fontSize: 15, color: Colors.red)),
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: RaisedButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Color(0xff1B65F3),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: RaisedButton(
                        child: Text(
                          "Voltar",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Color(0xff1B65F3),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeNewDesignBar()));
                        },
                      ),
                    ),
                  ]),
            )));
  }
}

class ImageView extends StatefulWidget {
  final comprovante;
  ImageView({@required this.comprovante});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
      child: PhotoView(
        imageProvider: NetworkImage(widget.comprovante),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    ));
  }
}
