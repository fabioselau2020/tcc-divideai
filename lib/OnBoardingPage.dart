import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'HomePage.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key key}) : super(key: key);

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HomeNewDesignBar()),
    );
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
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
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
