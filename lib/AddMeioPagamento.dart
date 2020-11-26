import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:tcc/MeiosPagamentos.dart';
import 'package:tcc/utilities/constants.dart';

class AddMeioPagamento extends StatefulWidget {
  @override
  _AddMeioPagamentoState createState() => _AddMeioPagamentoState();
}

class _AddMeioPagamentoState extends State<AddMeioPagamento> {
  TextEditingController _controllerNome = TextEditingController();
  var _controllerSaldo = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');
  String _tipo = "Carteira";

  List<String> _status = ["Carteira", "Banco", "Cartão"];
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
              hintText: 'Digite o nome (ex. Nubank)',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _saldoTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Saldo Atual',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: _controllerSaldo,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.monetization_on,
                color: Colors.white,
              ),
              hintText: 'Digite o saldo atual',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _addBtn() {
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

  _validarCampos() {
    if (_controllerNome.text.isEmpty || _controllerSaldo.text.isEmpty) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
          "Campo nome ou saldo incorreto.",
          style: TextStyle(color: Color(0xffB651E5)),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Fechar',
          onPressed: () {},
        ),
      ));
    } else {
      _adicionarMeioPagamento();
    }
  }

  _adicionarMeioPagamento() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String _idUsuarioLogado = usuarioLogado.uid;
    String icon;
    if (_tipo == "Carteira") {
      icon = "MaterialCommunityIcons.cash_usd";
    } else if (_tipo == "Banco") {
      icon = "MaterialCommunityIcons.bank";
    } else {
      icon = "MaterialCommunityIcons.credit_card_outline";
    }
    Map<String, dynamic> map = {
      "nome": _controllerNome.text,
      "saldo": _controllerSaldo.text,
      "tipo": _tipo,
      "icon": icon
    };

    Firestore db = Firestore.instance;
    db
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .collection("meios_pagamentos")
        .add(map)
        .then((value) => {
              scaffoldKey.currentState.showSnackBar(
                new SnackBar(
                  content: new Text(
                    "Meio de Pagamento adicionado com sucesso!",
                    style: TextStyle(color: Color(0xffB651E5)),
                  ),
                  backgroundColor: Colors.white,
                  action: SnackBarAction(
                    label: 'Fechar',
                    onPressed: () {},
                  ),
                ),
              ),
              _goToHome()
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

  _goToHome() {
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MeiosPagamentos()));
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Adicionar Meio Pagamento"),
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
                      _saldoTF(),
                      SizedBox(
                        height: 10,
                      ),
                      RadioGroup<String>.builder(
                        direction: Axis.horizontal,
                        groupValue: _tipo,
                        onChanged: (value) => setState(() {
                          _tipo = value;
                        }),
                        items: _status,
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                        ),
                      ),
                      //_enderecoTF(),
                      SizedBox(
                        height: 10,
                      ),
                      _addBtn(),
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
