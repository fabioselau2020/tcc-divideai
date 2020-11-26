import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:tcc/utilities/constants.dart';

import 'AddPagamentoPage.dart';

class EditarPagamento extends StatefulWidget {
  var nome, valor, status, comprovante;
  var dataVencimento, dataPagamento;

  EditarPagamento(
      {Key key, this.nome, this.valor, this.status, this.comprovante})
      : super(key: key);
  @override
  _EditarPagamentoState createState() => _EditarPagamentoState();
}

class _EditarPagamentoState extends State<EditarPagamento> {
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
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ImageView(
                            //               comprovante: comprovante,
                            //             )));
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
