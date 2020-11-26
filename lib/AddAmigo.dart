import 'package:tcc/Solicitacoes.dart';
import 'package:tcc/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'HomePage.dart';

class AddAmigo extends StatefulWidget {
  @override
  _AddAmigoState createState() => _AddAmigoState();
}

class _AddAmigoState extends State<AddAmigo> {
  TextEditingController _controlleruserEmail = TextEditingController();
  String _msgValidacao = "";

  validarEmail(String email) {
    if (email.isNotEmpty && email.contains("@")) {
      consultarUsuario(email);
    } else {
      setState(() {
        _msgValidacao = "Oops, parece que o e-mail está errado :/";
      });
    }
  }

  consultarUsuario(String email) async {
    var id = '';

    String _idUsuarioLogado;
    String _uidRecuperado;
    String documento;
    String documento2;

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore dbLogado = Firestore.instance;
    DocumentSnapshot docRecuperado =
        await dbLogado.collection("usuarios").document(_idUsuarioLogado).get();
    String nomeLogado = docRecuperado['nome'];
    String emailLogado = docRecuperado['email'];
    String urlImagemLogado = docRecuperado['urlImagem'];

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("usuarios")
        .where("email", isEqualTo: email)
        .getDocuments();
    var list = querySnapshot.documents;

    list.forEach((doc) => id = doc.documentID);

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(id).get();

    String nome = snapshot['nome'];
    String urlImagem = snapshot['urlImagem'];
    String emailRecuperado = snapshot['email'];

    print("ID USER B " + nome);
    print("ID USER B " + urlImagem);
    print("ID USER B " + emailRecuperado);
    //DADOS DO USUÁRIO QUE ENVIOU  O CONVITE
    Map<String, dynamic> dados = {
      "uid": id,
      "nome": nome,
      "email": emailRecuperado,
      "urlImagem": urlImagem,
      "status": "Pendente",
      "uidEnviado": _idUsuarioLogado,
      "doc": "teste",
      "docEnviado": "teste"
    };

    DocumentReference docRef = await Firestore.instance
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .collection('amigos')
        .add(dados);
    documento = docRef.documentID;
    print(docRef.documentID);

    Map<String, dynamic> dadosLogado = {
      "uid": _idUsuarioLogado,
      "nome": nomeLogado,
      "email": emailLogado,
      "urlImagem": urlImagemLogado,
      "status": "Pendente",
      "uidEnviado": _idUsuarioLogado,
      "doc": documento2,
      "docEnviado": documento
    };
    DocumentReference docRef2 = await Firestore.instance
        .collection("usuarios")
        .document(id)
        .collection('amigos')
        .add(dadosLogado);
    documento2 = docRef2.documentID;

    Map<String, dynamic> dadosUpdate = {
      "doc": documento2,
      "docEnviado": documento
    };
    db
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .collection('amigos')
        .document(documento)
        .updateData(dadosUpdate);

    db
      ..collection("usuarios")
          .document(id)
          .collection('amigos')
          .document(documento2)
          .updateData(dadosUpdate);
    Future.delayed(const Duration(milliseconds: 500), () {
      _mensagem();
    });
  }
  //   db
  //       .collection("usuarios")
  //       .document(id)
  //       .collection('amigos')
  //       .add(dadosUpdate);
  // }

  _mensagem() {
    Fluttertoast.showToast(
        msg:
            "Pedido enviado, quando for aceito você irá conseguir dividir as contas.",
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

  Widget _userEmailTF() {
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
            keyboardType: TextInputType.text,
            controller: _controlleruserEmail,
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
              hintText: 'Digite o e-mail do Usuário',
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
        onPressed: () => validarEmail(_controlleruserEmail.text),
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
        title: Text("Adicionar Amigo"),
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
                      _userEmailTF(),
                      SizedBox(
                        height: 10,
                      ),
                      _btnAdicionar(),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        // padding: EdgeInsets.symmetric(vertical: 25.0),
                        width: double.infinity,
                        child: RaisedButton(
                          //elevation: 5.0,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SolicitacoesAmigos()));
                          },
                          padding: EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.white,
                          child: Text(
                            'Solicitações',
                            style: TextStyle(
                              color: Color(0xFF527DAA),
                              letterSpacing: 1.5,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _msgValidacao,
                        style: TextStyle(color: Colors.white),
                      )
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
