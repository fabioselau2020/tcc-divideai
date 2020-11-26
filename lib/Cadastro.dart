import 'package:tcc/LoginScreen.dart';
import 'package:tcc/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/model/Usuario.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //Controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    //recuperar dados dos campos
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (nome.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (senha.isNotEmpty && senha.length >= 8) {
          Usuario usuario = Usuario();
          usuario.nome = nome;
          usuario.email = email;
          usuario.senha = senha;

          _cadastrarUsuario(usuario);

          this.iniciarFirebaseListeners();
        } else {
          setState(() {
            _mensagemErro = "A senha deve ter no mínimo 8 caracteres.";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha o e-mail corretamente.";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o nome.";
      });
    }
  }

  _cadastrarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      Firestore db = Firestore.instance;

      db
          .collection("usuarios")
          .document(firebaseUser.user.uid)
          .setData(usuario.toMap());

      // _firebaseMessaging.getToken().then((token) {
      //   print("Firebase token " + token);
      // });
      _firebaseMessaging.subscribeToTopic(firebaseUser.user.uid);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
    }).catchError((error) {
      setState(() {
        _mensagemErro = error;
      });
    });
  }

  void iniciarFirebaseListeners() {
    if (Platform.isIOS) requisitarPermissoesParaNotificacoesNoIos();

    // _firebaseMessaging.getToken().then((token) {
    //   print("Firebase token " + token);
    // });

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
            keyboardType: TextInputType.emailAddress,
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
              hintText: 'Digite seu nome',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _btnLogin() {
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
          'CADASTRAR-SE',
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

  Widget _btnTenhoConvite() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFF6CA8F1),
        child: Text(
          'LOGIN',
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

  Widget _emailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            keyboardType: TextInputType.emailAddress,
            controller: _controllerEmail,
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

  Widget _senhaTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Senha',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            controller: _controllerSenha,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Digite sua senha',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                      Text(
                        'Cadastrar-se',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      _nomeTF(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _emailTF(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _senhaTF(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _btnLogin(),
                      _btnTenhoConvite(),
                      Text(
                        _mensagemErro,
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

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key key}) : super(key: key);

  void _onIntroEnd(context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (_) => HomeNewDesignBar()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 19.0,
      color: Colors.white,
    );
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white),
      bodyTextStyle: TextStyle(fontSize: 15.0, color: Colors.white),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Color(0xFF73AEF5),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Bem vindo!",
          body:
              "Estamos felizes em ter você conosco. Muito obrigado por participar da versão beta do Divide.ai.",
          image: Center(
            child: Image.asset("imagens/welcome.png"),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "O que é?",
          body:
              "O Divide.ai é a solução dos problemas de muitas pessoas que dividem moradia com outra pessoa. Viemos para resolver esse problema de maneira fácil e rápida.",
          image: Center(
            child: Text(
              'Divide.ai',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Como funciona?",
          body:
              "Adicione as pessoas que dividem moradia com você utilizando o e-mail, quando a pessoa aceitar o convite, vocês ficarão conectados e poderão dividir as contas.",
          image: Center(
            child: Image.asset("imagens/convite.png"),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Reportar Bugs",
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                  "O Divide.ai está em fase beta, então você pode visualizar alguns bugs.",
                  style: bodyStyle),
              Text("Já sabemos desses bugs e já estamos corrigindo.",
                  style: bodyStyle),
              Text(
                  "Caso queira enviar um feedback, basta clicar em 'Feedback' que fica localizado na aba Conta.",
                  style: bodyStyle),
            ],
          ),
          //footer: Text("Caso queira reportar um bug, dá uma sugestão ou reclamação, basta enviar para help@divideai.tech", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
          image: Center(
            child: Image.asset("imagens/bug.png"),
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Pular'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('OK', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
