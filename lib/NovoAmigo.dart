import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'HomePage.dart';

class NovoAmigo extends StatefulWidget {
  @override
  _NovoAmigoState createState() => _NovoAmigoState();
}

class _NovoAmigoState extends State<NovoAmigo> {
  TextEditingController _controlleruserEmail = TextEditingController();
  TextEditingController _controllerNomeFantasma = TextEditingController();

  double altura = kToolbarHeight;

  bool btnAdicionar = true;
  bool btnAdicionarFantasma = true;
  bool btnConvidar = true;

  consultarUsuario(String email) async {
    var id = '';

    print("Email consultarUsuario: " + email);

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
        backgroundColor: Colors.blue,
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

  cadastrarFantasma(String nome) async {
    print("Nome:  " + nome);

    String _idUsuarioLogado;
    String documento;

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
    Firestore db = Firestore.instance;

    //DADOS DO USUÁRIO QUE ENVIOU  O CONVITE
    Map<String, dynamic> dados = {"nome": nome, "status": "Aceito"};

    DocumentReference docRef = await Firestore.instance
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .collection('amigos')
        .add(dados);
    documento = docRef.documentID;
    print(docRef.documentID);

    Map<String, dynamic> dadosUpdate = {
      "uid": documento,
    };
    db
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .collection('amigos')
        .document(documento)
        .updateData(dadosUpdate);

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _controllerNomeFantasma.text = "";
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => _mensagemFantasmaAdicionado(),
      );
    });
  }

  _verificarBtnAdicionar() {
    //btnAdicionar ? null : _teste()
    if (btnAdicionar) {
      return null;
    } else {
      return () {
        print(_controlleruserEmail.text);
        consultarUsuario(_controlleruserEmail.text);
      };
    }
  }

  _verificarBtnConvidar() {
    //btnAdicionar ? null : _teste()
    if (btnConvidar) {
      return null;
    } else {
      return () {
        showDialog(
          context: context,
          builder: (BuildContext context) => _mensagemConviteEnviado(),
        );
      };
    }
  }

  _verificarBtnFantasma() {
    //btnAdicionar ? null : _teste()
    if (btnAdicionarFantasma) {
      return null;
    } else {
      return () {
        cadastrarFantasma(_controllerNomeFantasma.text);
      };
    }
  }

  _mensagemConviteEnviado() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text("PODE DEIXAR!"),
                      ),
                      Divider(),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                            "Enviamos o convite para o e-mail do seu amigo. Mas ele só vai receber se o e-mail estiver correto."),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text("TalOk?!"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                            "Enquanto isso, põe na conta do fantasminha dele que a gente criou."),
                      ),
                    ]),
              ),
              GestureDetector(
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      color: Colors.blue,
                      gradient: LinearGradient(
                          colors: [Color(0XFFF04275F), Color(0XFFF78AAB4)]),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "OK!",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          )),
    );
  }

  _mensagemFantasmaAdicionado() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text("TÁ CRIADO."),
                      ),
                      Divider(),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text("Criamos esse amigo fantasma pra você."),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text("Agora é só dividir as contas com ele."),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text("Mas chama ele pro app assim que der."),
                      ),
                    ]),
              ),
              GestureDetector(
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      color: Colors.blue,
                      gradient: LinearGradient(
                          colors: [Color(0XFFF04275F), Color(0XFFF78AAB4)]),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "PODE DEIXAR!",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                  height: altura,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      gradient: LinearGradient(
                          colors: [Color(0XFF3172B6), Color(0XFF77A6EE)])),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment
                      .center, // Align however you like (i.e .centerRight, centerLeft)
                  child: Text(
                    "Digite o usuário ou e-mail do seu amigo",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                  height: 50,
                  alignment: AlignmentDirectional.centerEnd,
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      onChanged: (String value) {
                        if (value.contains("@")) {
                          setState(() {
                            btnAdicionar = false;
                          });
                        } else {
                          setState(() {
                            btnAdicionar = true;
                          });
                        }
                      },
                      controller: _controlleruserEmail,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.mail),
                        border: InputBorder.none,
                        hasFloatingPlaceholder: false,
                      ),
                    ),
                  )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 5.0,
                  onPressed: _verificarBtnAdicionar(),
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color(0XFFF04275F),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment
                      .center, // Align however you like (i.e .centerRight, centerLeft)
                  child: Text(
                    "Deixa o e-mail que a gente manda um convite especial",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                  height: 50,
                  alignment: AlignmentDirectional.centerEnd,
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      //controller: _controllerDescricao,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hasFloatingPlaceholder: false,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          hintText: 'Digite o nome do seu amigo aqui'),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                  height: 50,
                  alignment: AlignmentDirectional.centerEnd,
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      onChanged: (String value) {
                        print(value);
                        print(value.length);
                        if (value.contains("@")) {
                          setState(() {
                            btnConvidar = false;
                          });
                        } else {
                          setState(() {
                            btnConvidar = true;
                          });
                        }
                      },
                      //controller: _controllerDescricao,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hasFloatingPlaceholder: false,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          hintText: 'Digite o e-mail do seu amigo aqui'),
                    ),
                  )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 5.0,
                  onPressed: _verificarBtnConvidar(),
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color(0XFFF04275F),
                  child: Text(
                    'Convida ele por mim',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment
                      .center, // Align however you like (i.e .centerRight, centerLeft)
                  child: Text(
                    "Mas se ele não curte tecnologia, então cria um usuário fantasma!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                  height: 50,
                  alignment: AlignmentDirectional.centerEnd,
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      onChanged: (String value) {
                        print(value);
                        print(value.length);
                        if (value.length >= 1) {
                          setState(() {
                            btnAdicionarFantasma = false;
                          });
                        } else {
                          setState(() {
                            btnAdicionarFantasma = true;
                          });
                        }
                      },
                      controller: _controllerNomeFantasma,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              MaterialCommunityIcons.ghost,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                        hasFloatingPlaceholder: false,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        hintText: 'Digite o nome desse amigo fantasma',
                      ),
                    ),
                  )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 5.0,
                  onPressed: _verificarBtnFantasma(),
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color(0XFFF04275F),
                  child: Text(
                    'Criar esse amigo fantasma',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
