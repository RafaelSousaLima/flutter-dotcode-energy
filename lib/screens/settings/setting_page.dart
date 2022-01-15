import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _tsudController = TextEditingController();
  final TextEditingController _teController = TextEditingController();
  final TextEditingController _lastNumberController = TextEditingController();

  bool isBandeiraAmerela = false;
  bool isBandeiraVermelha = false;
  bool isTenPercentOthers = false;

  bool isBandeiraVermelhaPatamarUm = false;
  bool isBandeiraVermelhaPatamarDois = false;

  bool isWaterShortage = false;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Configurações",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),
                  TextFormField(
                    controller: _tsudController,
                    decoration: const InputDecoration(
                      label: Text("Consumo Ativo (kWh) - TUSD"),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _teController,
                    decoration: const InputDecoration(
                      label: Text("Consumo Ativo (kWh) - TE"),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _lastNumberController,
                    decoration: const InputDecoration(
                      label: Text("Valor da Última Leitura"),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isBandeiraAmerela,
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              isBandeiraAmerela = value;
                              isBandeiraVermelha = false;
                              isBandeiraVermelhaPatamarUm = false;
                              isBandeiraVermelhaPatamarDois = false;
                              isWaterShortage = false;
                            } else {
                              isBandeiraAmerela = value;
                            }
                          });
                        },
                      ),
                      const Text("Bandeira Amarela?"),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isBandeiraVermelha,
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              isBandeiraVermelha = value;
                              isBandeiraAmerela = false;
                              isWaterShortage = false;
                            } else {
                              isBandeiraVermelha = value;
                            }
                          });
                        },
                      ),
                      const Text("Bandeira Vermelha?"),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    value: isBandeiraVermelhaPatamarUm,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          isBandeiraVermelhaPatamarUm = value;
                                          isBandeiraVermelhaPatamarDois = false;
                                        } else {
                                          isBandeiraVermelhaPatamarUm = value;
                                        }
                                      });
                                    }),
                                const Text("Patamar Um?"),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    value: isBandeiraVermelhaPatamarDois,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          isBandeiraVermelhaPatamarDois = value;
                                          isBandeiraVermelhaPatamarUm = false;
                                        } else {
                                          isBandeiraVermelhaPatamarDois = value;
                                        }
                                      });
                                    }),
                                const Text("Patamar dois?"),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isWaterShortage,
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              isWaterShortage = value;
                              isBandeiraAmerela = false;
                              isBandeiraVermelha = false;
                              isBandeiraVermelhaPatamarUm = false;
                              isBandeiraVermelhaPatamarDois = false;
                            } else {
                              isWaterShortage = value;
                            }
                          });
                        },
                      ),
                      const Text("Bandeira escassez hídrica?"),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isTenPercentOthers,
                        onChanged: (value) {
                          setState(() {
                            isTenPercentOthers = !isTenPercentOthers;
                          });
                        },
                      ),
                      const Text("Adicionar 5% de outra taxas?"),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => onSubmit(),
                    child: const Text("Tudo certo!"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble("TUSD", double.parse(_tsudController.text));
    prefs.setDouble("TE", double.parse(_teController.text));
    prefs.setDouble("LAST_NUMBER", double.parse(_lastNumberController.text));
    prefs.setBool("YELLOW_FLAG", isBandeiraAmerela);
    prefs.setBool("RED_FLAG", isBandeiraVermelha);
    prefs.setBool("TEN_PERCENT", isTenPercentOthers);
    prefs.setBool("LVL_ONE", isBandeiraVermelhaPatamarUm);
    prefs.setBool("LVL_TWO", isBandeiraVermelhaPatamarDois);
    prefs.setBool("WAT_SHORT", isWaterShortage);

    Navigator.pushReplacementNamed(context, "home");
  }

  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getKeys().isNotEmpty) {
      setState(() {
        _tsudController.text = prefs.getDouble("TUSD")!.toString();
        _teController.text = prefs.getDouble("TE")!.toString();
        _lastNumberController.text = prefs.getDouble("LAST_NUMBER")!.toString();
        isBandeiraAmerela = prefs.getBool("YELLOW_FLAG")!;
        isBandeiraVermelha = prefs.getBool("RED_FLAG")!;
        isTenPercentOthers = prefs.getBool("TEN_PERCENT")!;
        isBandeiraVermelhaPatamarUm = prefs.getBool("LVL_ONE")!;
        isBandeiraVermelhaPatamarDois = prefs.getBool("LVL_TWO")!;
        isWaterShortage = prefs.getBool("WAT_SHORT")!;
      });
    }
  }
}
