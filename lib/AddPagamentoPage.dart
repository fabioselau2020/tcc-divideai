import 'dart:io';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tcc/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tcc/HomePage.dart';
import 'model/Pagamento.dart';

enum SingingCharacter { pago, naoPago }

class AddPagamentoPage extends StatefulWidget {
  @override
  _AddPagamentoPageState createState() => _AddPagamentoPageState();
}

class Categoria {
  int id;
  String nome;

  Categoria(this.id, this.nome);

  static List<Categoria> getCategorias() {
    return <Categoria>[
      Categoria(1, 'Aluguel'),
      Categoria(2, 'Conta de Luz'),
      Categoria(3, 'Conta de Água'),
      Categoria(4, 'Internet'),
      Categoria(5, 'Comida'),
      Categoria(6, 'Outros'),
    ];
  }
}

class Item {
  Item({this.nome, this.checked = false, this.uid, this.urlImagem});
  String nome;
  String uid;
  bool checked;
  String urlImagem;
}

class _AddPagamentoPageState extends State<AddPagamentoPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  List<Categoria> _categorias = Categoria.getCategorias();
  List<DropdownMenuItem<Categoria>> _dropdowMenuItems;
  Categoria _selectedCategoria;

  //Controladores
  TextEditingController _controllerNome = TextEditingController();
  var _controllerDataPagamento = TextEditingController();
  var _controllerDataVencimento = TextEditingController();
  var _controllerValor = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');

  String _mensagemErro = "";
  String _idUsuarioLogado;
  SingingCharacter _character = SingingCharacter.pago;
  File _imagem;
  bool _subindoImagem = false;
  String _mensagemComprovante = "";
  String _urlImagemRecuperada;
  String _documentID;
  bool _radioPendente = false;
  DateTime _datePagamento = DateTime.now();
  DateTime _dateVencimento = DateTime.now();
  String iconCategoria;
  DateTime dataVencimento;
  DateTime dataPagamento;
  double altura;
  var selectedCurrency;
  var selectedImovel;
  _validarCampos() {
    //recuperar dados dos campos
    String nome = _controllerNome.text;
    String valor = _controllerValor.text;
    String dataPagamento = _controllerDataPagamento.text;
    String dataVencimento = _controllerDataVencimento.text;
    String categoria = _selectedCategoria.toString();

    if (nome.isNotEmpty) {
      if (valor.isNotEmpty) {
        if (dataVencimento.isNotEmpty) {
          Pagamento pagamento = Pagamento();
          pagamento.nome = nome;
          pagamento.valor = valor;
          pagamento.dataVencimento = dataVencimento;

          _cadastrarPagamento(pagamento);
        } else {
          setState(() {
            _mensagemErro = "Data de Vencimento inválida.";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Valor inválido.";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Nome inválido.";
      });
    }
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
    _listenToData();
    this.iniciarFirebaseListeners();
  }

  void iniciarFirebaseListeners() {
    if (Platform.isIOS) requisitarPermissoesParaNotificacoesNoIos();

    _firebaseMessaging.getToken().then((token) {
      print("Firebase token " + token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('mensagem recebida $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void requisitarPermissoesParaNotificacoesNoIos() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  //FUNÇÃO PARA CADASTRAR O PAGAMENTO DO USUÁRIO NO FIREBASE
  _cadastrarPagamento(Pagamento pagamento) async {
    List<Item> itensMarcados = List.from(itens.where((item) => item.checked));
    var listaUIDAmigos = new List<String>();
    listaUIDAmigos.add(_idUsuarioLogado);
    itensMarcados.forEach((item) async {
      String nomeUsuario = item.nome;
      String uidUsuario = item.uid;
      listaUIDAmigos.add(uidUsuario);
      print(item.nome);
      String valorPagamento = _controllerValor.text;
      String vencimentoPagamento = _controllerDataVencimento.text;
      String DATA =
          "{\"notification\": {\"body\": \"Um pagamento no valor de R\$ $valorPagamento com vencimento em $vencimentoPagamento foi adicionado.\",\"title\": \"Pagamento Adicionado\"}, \"priority\": \"high\", \"data\": {\"click_action\": \"FLUTTER_NOTIFICATION_CLICK\", \"id\": \"1\", \"status\": \"done\"}, \"to\": \"/topics/$uidUsuario\"}";
      http.post("https://fcm.googleapis.com/fcm/send", body: DATA, headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAADS2wGME:APA91bEw3FdAtA7x75ms4zWXQvL_xFTbybfuVsPCPH3tB3oGuIY2O8ujP6CoMLy0C8HoieJujFq1lESmzqE6X1dv6bjrT2keQy4A6UYFFgZES-IuC48UsZf3OQpiHt4H1RnUGThho5uK"
      });
    });

    print("Quantidade de elementos da Lista: " +
        listaUIDAmigos.length.toString());

    String valorConvertido = _controllerValor.text.replaceAll(',', '.');

    double campoValor = double.tryParse(valorConvertido) + 0.00;

    double valorDividido = campoValor / listaUIDAmigos.length;
    valorDividido = num.parse(valorDividido.toStringAsFixed(2));

    Firestore dbu = Firestore.instance;
    DocumentSnapshot snapshot =
        await dbu.collection("usuarios").document(_idUsuarioLogado).get();

    String status = _character.toString();
    if (status == "SingingCharacter.pago") {
      status = "Pago";
    } else {
      status = "Pendente";
    }

    if (_selectedCategoria.nome == "Aluguel") {
      setState(() {
        iconCategoria = "Icons.home";
      });
    }
    if (_selectedCategoria.nome == "Internet") {
      setState(() {
        iconCategoria = "MaterialCommunityIcons.wifi_strength_4";
      });
    }
    if (_selectedCategoria.nome == "Conta de Água") {
      setState(() {
        iconCategoria = "MaterialCommunityIcons.water";
      });
    }
    if (_selectedCategoria.nome == "Conta de Luz") {
      setState(() {
        iconCategoria = "MaterialIcons.flash_on";
      });
    }
    if (_selectedCategoria.nome == "Comida") {
      setState(() {
        iconCategoria = "MaterialCommunityIcons.food_fork_drink";
      });
    }
    if (_selectedCategoria.nome == "Outros") {
      setState(() {
        iconCategoria = "MaterialCommunityIcons.dots_horizontal";
      });
    }

    Map<String, dynamic> map = {
      "nome": _controllerNome.text,
      "valor": _controllerValor.text,
      "dataPagamento": dataPagamento,
      "dataVencimento": dataVencimento,
      "status": status,
      "categoria": _selectedCategoria.nome,
      "iconCategoria": iconCategoria,
      "amigos": listaUIDAmigos,
      "qtde": listaUIDAmigos.length,
      "valorDividido": valorDividido
    };

    Firestore db = Firestore.instance;
    DocumentReference docRef = await db.collection("pagamentos").add(map);
    _documentID = docRef.documentID;
    print(_documentID);
    _recuperarDocumentID(_documentID);

    _rotaHome();
  }

  _rotaHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeNewDesignBar()));
  }

  final List<Item> itens = [
    Item(nome: "Matheus"),
    Item(nome: "Júlio"),
    Item(nome: "Caio")
  ];

  _listenToData() {
    Firestore.instance
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .collection("amigos")
        .where("status", isEqualTo: "Aceito")
        .snapshots()
        .listen((snap) {
      itens.clear();
      setState(() {
        snap.documents.forEach((d) {
          itens.add(Item(
              nome: d.data["nome"],
              uid: d.data["uid"],
              urlImagem: d.data["urlImagem"]));
          altura = 65 * itens.length.toDouble();
          print(d.data["nome"]);
        });
      });
    });
  }

  @override
  void initState() {
    //_listenToData();
    _recuperarDadosUsuario();
    _dropdowMenuItems = buildDropdownMenuItems(_categorias);
    _selectedCategoria = _dropdowMenuItems[0].value;
    _firebaseMessaging.requestNotificationPermissions();
    super.initState();
  }

  List<DropdownMenuItem<Categoria>> buildDropdownMenuItems(List categorias) {
    List<DropdownMenuItem<Categoria>> items = List();
    for (Categoria categoria in categorias) {
      items.add(DropdownMenuItem(
        value: categoria,
        child: Text(categoria.nome),
      ));
    }
    return items;
  }

  onChangeDropdownItem(Categoria selectedCategoria) {
    setState(() {
      _selectedCategoria = selectedCategoria;
      print(_selectedCategoria.nome);
    });
  }

  Future _recuperarImagem(String origemImagem) async {
    File imagemSelecionada;
    switch (origemImagem) {
      case "camera":
        imagemSelecionada =
            await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria":
        imagemSelecionada =
            await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
      if (_imagem != null) {
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() async {
    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo =
        pastaRaiz.child("comprovantes").child(nomeImagem + ".jpg");

    StorageUploadTask task = arquivo.putFile(_imagem);

    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _subindoImagem = true;
          _mensagemComprovante = "Um momento enquanto enviamos...";
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _subindoImagem = false;
          _mensagemComprovante = "Comprovante enviado com sucesso!";
        });
      }
    });

    //recuperar URL da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  _recuperarDocumentID(String _documentID) {
    Firestore db = Firestore.instance;

    Map<String, dynamic> mapa = {
      "doc": _documentID,
      "urlComprovante": _urlImagemRecuperada,
    };

    db.collection("pagamentos").document(_documentID).updateData(mapa);
  }

  void _mensagemAnexarComprovante() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Anexar comprovante"),
          content: new Text(
              "Como deseja obter o comprovante para anexar ao pagamento?"),
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text("Câmera"),
              onPressed: () {
                _recuperarImagem("camera");
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Galeria"),
              onPressed: () {
                _recuperarImagem("galeria");
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _nomeTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            keyboardType: TextInputType.text,
            controller: _controllerNome,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.format_color_text,
                color: Colors.white,
              ),
              hintText: 'Digite nome do pagamento',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _valorTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Valor',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: _controllerValor,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.attach_money,
                color: Colors.white,
              ),
              hintText: 'Digite valor do pagamento',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> selectDatePagamento(BuildContext context) async {
    final DateTime pickedPagamento = await showDatePicker(
        context: context,
        initialDate: _datePagamento,
        firstDate: DateTime(2019),
        lastDate: DateTime(2021));

    if (pickedPagamento != null && pickedPagamento != _datePagamento) {
      //print("DATA DE PAGAMENTO: " + _datePagamento.toString());
      setState(() {
        _datePagamento = pickedPagamento;

        dataPagamento = _datePagamento;
        print("DATA DE PAGAMENTO: " + dataPagamento.toString());
        String dataFormated = DateFormat('dd/MM/yyyy').format(_datePagamento);
        _controllerDataPagamento.text = dataFormated.toString();
      });
    }
  }

  Future<Null> selectDateVencimento(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _dateVencimento,
        firstDate: DateTime(2019),
        lastDate: DateTime(2021));

    if (picked != null && picked != _dateVencimento) {
      // print("DATA DE VENCIMENTO: " + _dateVencimento.toString());
      setState(() {
        _dateVencimento = picked;
        dataVencimento = _dateVencimento;
        print("DATA DE VENCIMENTO: " + dataVencimento.toString());
        String dataFormated = DateFormat('dd/MM/yyyy').format(_dateVencimento);
        _controllerDataVencimento.text = dataFormated.toString();
      });
    }
  }

  Widget _dataPagamentoTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Data Pagamento',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            readOnly: true,
            keyboardType: null,
            onTap: () {
              selectDatePagamento(context);
            },
            //keyboardType: TextInputType.text,
            controller: _controllerDataPagamento,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              hintText: 'Digite a data de pagamento',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _divisao() {
    return Container(
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Divide aí...",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                height: altura,
                child: new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: itens.length,
                  itemBuilder: (_, int index) {
                    Item ad = itens[index];
                    return ItemLista(item: itens[index]);
                  },
                ),
              ),
            )
          ],
        ));
  }

  Widget _conta() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Meio de Pagamento',
            style: kLabelStyle,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("usuarios")
                  .document(_idUsuarioLogado)
                  .collection("meios_pagamentos")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DropdownMenuItem> contasItens = [];
                  for (int i = 0; i < snapshot.data.documents.length; i++) {
                    DocumentSnapshot snap = snapshot.data.documents[i];
                    contasItens.add(DropdownMenuItem(
                      child:
                          Text(snap.data["nome"] + " - " + snap.data["tipo"]),
                      value: "${snap.documentID}",
                    ));
                  }
                  return Container(
                      alignment: AlignmentDirectional.centerStart,
                      margin: EdgeInsets.only(top: 7),
                      decoration: kBoxDecorationStyle,
                      child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                MaterialCommunityIcons.bank,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              DropdownButton(
                                  dropdownColor: Colors.grey,
                                  style: TextStyle(color: Colors.white),
                                  items: contasItens,
                                  onChanged: (currencyValue) {
                                    setState(() {
                                      selectedCurrency = currencyValue;
                                    });
                                  },
                                  value: selectedCurrency,
                                  isExpanded: false,
                                  iconSize: 0,
                                  hint: new Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Text(
                                      "Selecionar Conta",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ],
                          )));
                } else {
                  return Container();
                }
              })
        ]);
  }

  Widget _imovel() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Imóvel',
            style: kLabelStyle,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("usuarios")
                  .document(_idUsuarioLogado)
                  .collection("imoveis")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DropdownMenuItem> contasItens = [];
                  for (int i = 0; i < snapshot.data.documents.length; i++) {
                    DocumentSnapshot snap = snapshot.data.documents[i];
                    contasItens.add(DropdownMenuItem(
                      child:
                          Text(snap.data["nome"] + " - " + snap.data["cidade"]),
                      value: "${snap.documentID}",
                    ));
                  }
                  return Container(
                      alignment: AlignmentDirectional.centerStart,
                      margin: EdgeInsets.only(top: 7),
                      decoration: kBoxDecorationStyle,
                      child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                MaterialCommunityIcons.home,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              DropdownButton(
                                  dropdownColor: Colors.grey,
                                  style: TextStyle(color: Colors.white),
                                  items: contasItens,
                                  onChanged: (currencyValue) {
                                    setState(() {
                                      selectedImovel = currencyValue;
                                    });
                                  },
                                  value: selectedImovel,
                                  isExpanded: false,
                                  iconSize: 0,
                                  hint: new Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Text(
                                      "Selecionar Imóvel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ],
                          )));
                } else {
                  return Container();
                }
              })
        ]);
  }

  Widget _dataVencimentoTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Data Vencimento',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            readOnly: true,
            keyboardType: null,
            onTap: () {
              selectDateVencimento(context);
            },
            controller: _controllerDataVencimento,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.date_range,
                color: Colors.white,
              ),
              hintText: 'Digite a data de vencimento',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _btnAdicionar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => _validarCampos(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Adicionar',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Adicionar Pagamento"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF73AEF5),
      ),
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
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 50.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Categoria:",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 19),
                            ),
                            DropdownButton(
                              value: _selectedCategoria,
                              items: _dropdowMenuItems,
                              onChanged: onChangeDropdownItem,
                            )
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Status',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Pago',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Radio(
                                      activeColor: Colors.white,
                                      value: SingingCharacter.pago,
                                      groupValue: _character,
                                      onChanged: (SingingCharacter value) {
                                        setState(() {
                                          _radioPendente = false;
                                          _character = value;
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Pendente',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Radio(
                                      activeColor: Colors.white,
                                      value: SingingCharacter.naoPago,
                                      groupValue: _character,
                                      onChanged: (SingingCharacter value) {
                                        setState(() {
                                          _radioPendente = true;
                                          _character = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      _nomeTF(),
                      SizedBox(
                        height: 10,
                      ),
                      _valorTF(),
                      SizedBox(
                        height: 10,
                      ),
                      _dataVencimentoTF(),
                      SizedBox(
                        height: 10,
                      ),
                      _conta(),
                      SizedBox(
                        height: 10,
                      ),
                      _imovel(),
                      SizedBox(
                        height: 10,
                      ),
                      _radioPendente == true ? Container() : _dataPagamentoTF(),
                      Text(
                        _mensagemErro,
                        style: TextStyle(color: Colors.white),
                      ),
                      _radioPendente == true
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  child: Row(
                                    children: <Widget>[
                                      Text("Anexar Comprovante",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                          )),
                                      Icon(Icons.description,
                                          size: 17, color: Colors.white)
                                    ],
                                  ),
                                  onPressed: () {
                                    _mensagemAnexarComprovante();
                                  },
                                ),
                              ],
                            ),
                      _subindoImagem
                          ? CircularProgressIndicator()
                          : Container(),
                      Center(
                        child: Text(
                          _mensagemComprovante,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        height: 140,
                        width: altura,
                        child: _divisao(),
                      ),
                      _btnAdicionar(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MountainList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance
          .collection('usuarios')
          .where("convite", isEqualTo: "yWiGl")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((document) {
            print(document["nome"]);
            print(document["email"]);
            return new ListTile(
              title: new Text(document['nome']),
              subtitle: new Text(document['email']),
            );
          }).toList(),
        );
      },
    );
  }
}

class ItemLista extends StatefulWidget {
  const ItemLista({Key key, this.item}) : super(key: key);

  final Item item;

  @override
  _ItemListaState createState() => _ItemListaState();
}

class _ItemListaState extends State<ItemLista> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 100,
            width: 70,
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor:
                            widget.item.checked ? Colors.green : Colors.white,
                        child: CircleAvatar(
                          radius: 30,
                          child: widget.item.urlImagem != null
                              ? CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.blue,
                                  backgroundImage:
                                      NetworkImage(widget.item.urlImagem))
                              : CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    MaterialCommunityIcons.ghost,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          widget.item.checked = !widget.item.checked;
                          print(widget.item.nome);
                          print(widget.item.uid);
                          print(widget.item.checked);
                          print(widget.item.urlImagem);
                        });
                      },
                    ),
                    Positioned(
                        bottom: -20,
                        left: 10,
                        child: Checkbox(
                          value: widget.item.checked,
                          onChanged: (bool value) {
                            setState(() {
                              widget.item.checked = value;
                              print(widget.item.nome);
                              print(widget.item.uid);
                              print(widget.item.checked);
                            });
                          },
                        ))
                  ],
                ),
                Text(widget.item.nome,
                    style: widget.item.checked
                        ? TextStyle(color: Colors.green[900], fontSize: 16)
                        : TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
