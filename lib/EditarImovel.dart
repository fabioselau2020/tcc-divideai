import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tcc/ImoveisPage.dart';
import 'package:tcc/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class EditarImovel extends StatefulWidget {
  final DocumentSnapshot post;

  const EditarImovel({Key key, this.post}) : super(key: key);
  @override
  _EditarImovelState createState() => _EditarImovelState();
}

class _EditarImovelState extends State<EditarImovel> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerCEP = TextEditingController();
  TextEditingController _controllerUF = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerCidade = TextEditingController();

  _recuperarCEP() async {
    String cep = _controllerCEP.text;
    var url = 'https://viacep.com.br/ws/${cep}/json';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var itemCount = jsonResponse['localidade'];
      var cidade = jsonResponse['localidade'];
      var estado = jsonResponse['uf'];
      var endereco = jsonResponse['logradouro'];
      setState(() {
        _controllerCidade.text = cidade;
        _controllerUF.text = estado;
        _controllerEndereco.text = endereco;
      });
      print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Widget _cepTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'CEP',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            autofocus: true,
            onChanged: (String value) async {
              if (_controllerCEP.text.length == 8) {
                _recuperarCEP();
                FocusScope.of(context).unfocus();
              } else if (_controllerCEP.text.length > 8) {
                scaffoldKey.currentState.showSnackBar(
                  new SnackBar(
                    content: new Text(
                      "Oops, CEP somente 8 números",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Color(0xFF6746cc),
                    action: SnackBarAction(
                      label: 'Fechar',
                      onPressed: () {},
                    ),
                  ),
                );
              }
            },
            keyboardType: TextInputType.number,
            controller: _controllerCEP,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.map,
                color: Colors.white,
              ),
              hintText: 'Digite o CEP (apenas números)',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _nomeTF() {
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
                Icons.account_circle,
                color: Colors.white,
              ),
              hintText: 'Digite o nome (apelido)',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _cidadeTF() {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      height: 50,
      width: 220,
      child: TextField(
        readOnly: true,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.text,
        controller: _controllerCidade,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.map,
            color: Colors.white,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14.0),
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }

  Widget _estadoTF() {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      height: 50,
      width: 90,
      child: TextField(
        readOnly: true,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.text,
        controller: _controllerUF,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.map,
            color: Colors.white,
          ),
          border: InputBorder.none,
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }

  Widget _bairroTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Bairro',
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
                Icons.account_circle,
                color: Colors.white,
              ),
              hintText: 'Digite o nome (apelido)',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _enderecoTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Endereço',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.text,
            controller: _controllerEndereco,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              hintText: 'Digite o nome (apelido)',
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
        onPressed: () {
          _validarCampos();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Atualizar',
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

  Widget _btnRemover() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _excluir();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.red,
        child: Text(
          'Excluir',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  _excluir() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    db
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .collection("imoveis")
        .document(widget.post.documentID)
        .delete();
    _rotaImoveis();
  }

  _rotaImoveis() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ImoveisPage()));
  }

  _validarCampos() {
    if (_controllerNome.text.length < 5 ||
        _controllerCEP.text.length < 5 ||
        _controllerUF.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Campo Nome ou CEP inválido.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 3,
          backgroundColor: Colors.white,
          textColor: Colors.red,
          fontSize: 14.0);
    } else {
      _cadastrarImovel();
    }
  }

  _cadastrarImovel() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String _idUsuarioLogado = usuarioLogado.uid;

    Map<String, dynamic> map = {
      "nome": _controllerNome.text,
      "endereco": _controllerEndereco.text,
      "cidade": _controllerCidade.text,
      "UF": _controllerUF.text,
      "CEP": _controllerCEP.text,
    };

    Firestore db = Firestore.instance;
    db
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .collection("imoveis")
        .document(widget.post.documentID)
        .updateData(map)
        .then((value) => {
              scaffoldKey.currentState.showSnackBar(
                new SnackBar(
                  content: new Text(
                    "Imóvel atualizado com sucesso!",
                    style: TextStyle(color: Color(0xffB651E5)),
                  ),
                  backgroundColor: Colors.white,
                  action: SnackBarAction(
                    label: 'Fechar',
                    onPressed: () {},
                  ),
                ),
              ),
              _rotaImoveis()
            })
        .catchError((e) {
      scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(
            "Oops, aconteceu algo. Tente novamente.",
            style: TextStyle(color: Color(0xffB651E5)),
          ),
          backgroundColor: Colors.white,
          action: SnackBarAction(
            label: 'Fechar',
            onPressed: () {},
          ),
        ),
      );
    });
  }

  _recuperarDados() {
    setState(() {
      _controllerNome.text = widget.post.data["nome"];
      _controllerCEP.text = widget.post.data["CEP"];
      _controllerEndereco.text = widget.post.data["endereco"];
      _controllerUF.text = widget.post.data["UF"];
      _controllerCidade.text = widget.post.data["cidade"];
    });
  }

  @override
  void initState() {
    _recuperarDados();
    super.initState();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Editar Imóvel"),
        elevation: 0,
        centerTitle: true,
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
                alignment: AlignmentDirectional.center,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 50.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _nomeTF(),
                      SizedBox(
                        height: 10,
                      ),
                      _cepTF(),
                      SizedBox(
                        height: 10,
                      ),
                      _enderecoTF(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _cidadeTF(),
                          SizedBox(
                            width: 10,
                          ),
                          _estadoTF()
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _btnAdicionar(),
                      SizedBox(
                        height: 10,
                      ),
                      _btnRemover(),
                      SizedBox(
                        height: 10,
                      ),
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
