import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:rbctruck/google_sheet_api.dart';
import 'package:rbctruck/loading_circle.dart';
import 'package:rbctruck/plus_button.dart';
import 'package:rbctruck/top_card.dart';
import 'package:rbctruck/transation.dart';
import 'package:brasil_fields/brasil_fields.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //metodo de entrta na transação
  void _entrarTransaction() {
    GoogleSheetApi.insert(
      _textcontrollerMotorista.text,
      _textcontrollerValor.text,
      _textcontrollerCaminhao.text,
      _textcontrollerKmInicial.text,
      _textcontrollerKmFinal.text,
      _textcontrollerLitros.text,
      //_isIncome,
    );
    setState(() {});
  }

  //controladores do imput
  final _textcontrollerCaminhao = TextEditingController();
  final _textcontrollerValor = TextEditingController();
  final _textcontrollerKmInicial = TextEditingController();
  final _textcontrollerKmFinal = TextEditingController();
  final _textcontrollerLitros = TextEditingController();
  final _textcontrollerMotorista = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  //nova transcao
  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: Text('NOVA TRANSAÇÃO'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'MOTORISTA',
                              ),
                              keyboardType: TextInputType.text,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Digite nome do motorista';
                                }
                                return null;
                              },
                              controller: _textcontrollerMotorista,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: TextFormField(
                                inputFormatters: <TextInputFormatter>[
                                  PlacaVeiculoInputFormatter(),
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'CAMINHÃO',
                                ),
                                keyboardType: TextInputType.text,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Digite o caminhão';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerCaminhao,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                KmInputFormatter(),
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'KM INICIAL',
                              ),
                              keyboardType: TextInputType.text,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Digite o km inicial';
                                }
                                return null;
                              },
                              controller: _textcontrollerKmInicial,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                KmInputFormatter(),
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'KM FINAL',
                              ),
                              keyboardType: TextInputType.text,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Digite o km final';
                                }
                                return null;
                              },
                              controller: _textcontrollerKmFinal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'LITROS',
                              ),
                              keyboardType: TextInputType.text,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Digite a quantidade de litros abastecido';
                                }
                                return null;
                              },
                              controller: _textcontrollerLitros,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                RealInputFormatter(),
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'VALOR',
                              ),
                              keyboardType: TextInputType.text,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Digite a valor abastecido';
                                }
                                return null;
                              },
                              controller: _textcontrollerValor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                      color: Colors.blue[600],
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  MaterialButton(
                      color: Colors.blue[600],
                      child: Text(
                        'Entrar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (_formKey.currentState!.validate()) {
                          _entrarTransaction();
                        }
                        {}
                      }),
                ],
              ),
            );
          });
        });
  }

  bool timerHasStarted = false;

  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetApi.loading == false) {
        setState(() {
          timer.cancel();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetApi.loading == true && timerHasStarted == false) {
      startLoading();
    }
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            TopMeuCard(
              balance: (GoogleSheetApi.calculateabastecimento() /
                      GoogleSheetApi.calculatemanutencao())
                  .toString(),
              LitrosTotal: GoogleSheetApi.calculateabastecimento().toString(),
              KmTotal: GoogleSheetApi.calculatemanutencao().toString(),
            ),

            Expanded(
              child: GoogleSheetApi.loading == true
                  ? LoadingCircle()
                  : ListView.builder(
                      itemCount: GoogleSheetApi.currentTransactions.length,
                      itemBuilder: (context, index) {
                        return MyTransation(
                          transationMotorista:
                              GoogleSheetApi.currentTransactions[index][0],
                          transationCaminhao:
                              GoogleSheetApi.currentTransactions[index][1],
                          transationKmInicial:
                              GoogleSheetApi.currentTransactions[index][2],
                          transationKmFinl:
                              GoogleSheetApi.currentTransactions[index][3],
                          transationLitros:
                              GoogleSheetApi.currentTransactions[index][4],
                          transationValor: GoogleSheetApi.currentTransactions[index]
                              [5],
                          //AbastecimentoOrManutencao:
                              //GoogleSheetApi.currentTransactions[index][6],
                        );
                      }),
            ),
            PlusButton(
              function: _newTransaction,
            ),
          ],
        ),
      ),
    );
  }
}