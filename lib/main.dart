import 'package:flutter/material.dart';
import 'package:poc_regex_senha/validaSenhaWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Validador de senha com Regex'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController senhaController = TextEditingController();
  TextEditingController senhaConfirmacaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: ComponenteValidaSenhaWidget(senhaController, (aaa) => aaa ? print('deu bom senha 1') : print('deu ruimm senha 1')),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: ComponenteValidaSenhaWidget(senhaConfirmacaoController, (aaa) => aaa ? print('deu bom senha 2') : print('deu ruimm senha 2'), controllerConfirmar: senhaController),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: RaisedButton(
                  child: Text("Avançar"),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
