import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isSwitched = true;
  String _idUsuarioLogado;
  String nome = "";
  File _imagem;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;
  String _mensagem = "";
  String email = "";
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
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo =
        pastaRaiz.child("perfil").child(_idUsuarioLogado + ".jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

    //Controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _subindoImagem = false;
        });
      }
    });

    //Recuperar url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestore(url);

    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  _atualizarUrlImagemFirestore(String url) {
    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {"urlImagem": url};

    db
        .collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizar);

    setState(() {
      _urlImagemRecuperada;
    });
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore dbu = Firestore.instance;
    DocumentSnapshot snapshot =
        await dbu.collection("usuarios").document(_idUsuarioLogado).get();

    if (snapshot['urlImagem'] != null) {
      setState(() {
        _urlImagemRecuperada = snapshot['urlImagem'];
      });
    }

    setState(() {
      nome = snapshot['nome'];
      email = snapshot['email'];
    });
  }

  @override
  void initState() {
    _recuperarDadosUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Meu Perfil"),
          centerTitle: true,
          backgroundColor: Color(0XFF3172B6),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Center(
                    child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: _urlImagemRecuperada != null
                          ? NetworkImage(_urlImagemRecuperada)
                          : NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/divide-ai-b6983.appspot.com/o/perfil%2Fuser.png?alt=media&token=77c585d6-4e4b-4554-a946-d4006c9defdc"),
                    ),
                    GestureDetector(
                      child: Icon(MaterialCommunityIcons.camera_plus_outline),
                      onTap: () {
                        _recuperarImagem("galeria");
                      },
                    ),
                    _subindoImagem ? CircularProgressIndicator() : Container(),
                  ],
                )),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      nome,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ListTile(
                        title: Text(
                          "E-mail",
                        ),
                        trailing: Text(email))),
                SizedBox(
                  height: 15,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ListTile(
                      title: Text(
                        "SEGURANÇA",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.indigo,
                          fontFamily: 'Roboto-Regular',
                        ),
                      ),
                      trailing: Container(
                        height: 1,
                        width: 1,
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ListTile(
                        title: Text(
                          "Senha",
                        ),
                        trailing: Icon(Icons.lock, color: Colors.grey))),
                Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ListTile(
                      title: Text(
                        "Desbloquear com TouchId",
                      ),
                      trailing: Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                        activeTrackColor: Colors.grey,
                        activeColor: Colors.indigo,
                        inactiveTrackColor: Colors.grey,
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
