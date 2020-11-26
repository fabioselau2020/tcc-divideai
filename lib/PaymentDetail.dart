import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tcc/utilities/constants.dart';

import 'AddPagamentoPage.dart';

class PaymentDetail extends StatefulWidget {
  final DocumentSnapshot post;

  PaymentDetail({this.post});
  @override
  _PaymentDetailState createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerValor = TextEditingController();
  TextEditingController _controllerDataPagamento = TextEditingController();
  TextEditingController _controllerDataVencimento = TextEditingController();
  TextEditingController _controllerStatus = TextEditingController();
  TextEditingController _controllerqtdePessoas = TextEditingController();
  String _status;
  String comprovante;
  String iconPayment;
  bool _radioPendente;
  String doc;

  _recuperarDados() {
    if (widget.post.data["dataPagamento"] != null) {
      setState(() {
        doc = widget.post.data["doc"];
        print(doc);
        _controllerNome.text = widget.post.data["nome"];
        _controllerValor.text = "R\$ " + widget.post.data["valor"];
        _controllerDataPagamento.text = DateFormat('dd/mM/yyyy')
            .format(widget.post.data["dataPagamento"].toDate());
        _controllerqtdePessoas.text =
            widget.post.data["qtde"].toString() + " pessoas";
        _controllerDataVencimento.text = DateFormat('dd/mM/yyyy')
            .format(widget.post.data["dataVencimento"].toDate());
        comprovante = widget.post.data["urlComprovante"];
        _controllerStatus.text = widget.post.data["status"];
        _status = widget.post.data["status"];
        iconPayment = widget.post.data["iconCategoria"];
        print(widget.post.data["dataPagamento"]);

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
    } else {
      setState(() {
        doc = widget.post.data["doc"];
        print(doc);
        _controllerNome.text = widget.post.data["nome"];
        _controllerValor.text = "R\$ " + widget.post.data["valor"];
        _controllerqtdePessoas.text = widget.post.data["qtde"] +
            " pessoas | R\$ " +
            widget.post.data["valorDividido"].toString() +
            " pra cada";
        _controllerDataVencimento.text = DateFormat('dd/mM/yyyy')
            .format(widget.post.data["dataVencimento"].toDate());
        comprovante = widget.post.data["urlComprovante"];
        _controllerStatus.text = widget.post.data["status"];
        _status = widget.post.data["status"];
        iconPayment = widget.post.data["iconCategoria"];
        print(widget.post.data["dataPagamento"]);

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
  }

  //WIDGETS
  Widget _nomeTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nome',
          style: paymentDetailLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            readOnly: true,
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
          'Valor Total',
          style: paymentDetailLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            readOnly: true,
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

  Widget _dataVencimentoTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Data de Vencimento',
          style: paymentDetailLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            readOnly: true,
            keyboardType: null,
            onTap: () {},
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

  Widget _dataPagamentoTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Data de Pagamento',
          style: paymentDetailLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            readOnly: true,
            keyboardType: null,
            onTap: () {},
            controller: _controllerDataPagamento,
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

  Widget _qtdePessoasTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Dividido em',
          style: paymentDetailLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            readOnly: true,
            keyboardType: null,
            onTap: () {},
            controller: _controllerqtdePessoas,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                MaterialCommunityIcons.account_group_outline,
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

  Widget _pagarOpcoes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Pagar com',
          style: paymentDetailLabelStyle,
        ),
        SizedBox(height: 5),
        Container(
            alignment: Alignment.center,
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  MaterialCommunityIcons.barcode,
                  size: 40,
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Icon(
                    Icons.credit_card,
                    size: 40,
                  ),
                  onTap: () {},
                )
              ],
            )),
      ],
    );
  }

  Widget _comprovante() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Comprovante',
          style: paymentDetailLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 30.0,
            child: Row(
              children: <Widget>[
                comprovante != null
                    ? Expanded(
                        child: Center(
                        child: FlatButton(
                          child: Text("Visualizar Comprovante",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageView(
                                          comprovante: comprovante,
                                        )));
                          },
                        ),
                      ))
                    : Expanded(
                        child: Center(
                        child: Text("Nenhum comprovante foi anexado.",
                            style: TextStyle(fontSize: 15, color: Colors.red)),
                      ))
              ],
            )),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _recuperarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Detalhes"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.withOpacity(0.7),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              MaterialCommunityIcons.close_circle,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                child: Icon(MaterialCommunityIcons.square_edit_outline),
                onTap: () {
                  widget.post.data["dataPagamento"] != null
                      ? Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentEditPago(
                                    nome: _controllerNome.text,
                                    valor: _controllerValor.text,
                                    dataPagamento:
                                        widget.post.data["dataPagamento"],
                                    dataVencimento:
                                        widget.post.data["dataVencimento"],
                                    comprovante:
                                        widget.post.data["comprovante"],
                                  )))
                      : PaymentEditPendente();
                },
              ))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.blue.withOpacity(0.7),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 100),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 50.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
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
                          widget.post.data["dataPagamento"] != null
                              ? _dataPagamentoTF()
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          _qtdePessoasTF(),
                          SizedBox(
                            height: 10,
                          ),
                          _comprovante(),
                          SizedBox(
                            height: 15,
                          ),
                          //_pagarOpcoes(),
                        ],
                      )),
                ],
              ),
              Positioned(
                top: 40,
                left: 150,
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Image.network(
                    iconPayment,
                    scale: 0.7,
                  ),
                  radius: 60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

class PaymentEditPago extends StatefulWidget {
  final nome, valor, status, comprovante;
  var dataVencimento, dataPagamento;

  PaymentEditPago(
      {Key key,
      this.nome,
      this.valor,
      this.dataVencimento,
      this.dataPagamento,
      this.status,
      this.comprovante})
      : super(key: key);
  @override
  _PaymentEditPagoState createState() => _PaymentEditPagoState();
}

class _PaymentEditPagoState extends State<PaymentEditPago> {
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
  String comprovante;

  atualizarCampos() {
    setState(() {
      _controllerNome.text = widget.nome;
      _controllerValor.text = widget.valor;
      _controllerDataVencimento.text =
          DateFormat('dd/mM/yyyy').format(widget.dataVencimento.toDate());
      _controllerDataPagamento.text =
          DateFormat('dd/mM/yyyy').format(widget.dataPagamento.toDate());
      comprovante = widget.comprovante;
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
        onPressed: () => {},
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

  Widget _comprovante() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Comprovante',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 30.0,
            child: Row(
              children: <Widget>[
                comprovante != null
                    ? Expanded(
                        child: Center(
                        child: FlatButton(
                          child: Text("Visualizar Comprovante",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageView(
                                          comprovante: comprovante,
                                        )));
                          },
                        ),
                      ))
                    : Expanded(
                        child: Center(
                        child: Text("Adicionar Comprovante",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                      ))
              ],
            )),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    atualizarCampos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Editar Pagamento"),
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
                      _dataPagamentoTF(),
                      SizedBox(
                        height: 10,
                      ),
                      _comprovante(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _mensagemErro,
                        style: TextStyle(color: Colors.white),
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

class PaymentEditPendente extends StatefulWidget {
  @override
  _PaymentEditPendenteState createState() => _PaymentEditPendenteState();
}

class _PaymentEditPendenteState extends State<PaymentEditPendente> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
