import 'dart:async';
import 'package:flutter/material.dart';

class ComponenteValidaSenhaWidget extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController controllerConfirmar;
  final Function(bool) aoValidarComSucesso;

  ComponenteValidaSenhaWidget(this.controller, this.aoValidarComSucesso, {this.controllerConfirmar});

  @override
  _ComponenteValidaSenhaWidgetState createState() => _ComponenteValidaSenhaWidgetState();
}

class _ComponenteValidaSenhaWidgetState extends State<ComponenteValidaSenhaWidget> {
  bool exibeValidacoes = false;
  bool _politicaSenha8Digitos = false;
  bool _politicaSenhaCaractereEspecial = false;
  bool _politicaSenhaLetrasMaiusculasEMinusculas = false;
  bool _politicaSenhaNumeros = false;
  bool _politicaSenhaMatch = false;
  bool _politicaSenhaValida = false;
  bool senhaInvisivel = false;

  @override
  Widget build(BuildContext context) {
    return montaTextFieldSenha();
  }

  Widget toolTipSenha(bool exibe) {
    bool confirmarSenha = (widget.controllerConfirmar?.text ?? "").isNotEmpty;
    double alturaTootip = confirmarSenha ? 110 : 90;
    double heightContainer = exibe ? alturaTootip : 0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      height: heightContainer,
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          Text("- 8 caracteres ", style: estiloValidador(_politicaSenha8Digitos)),
          Text("- Maiúsculas e minúsculas ", style: estiloValidador(_politicaSenhaLetrasMaiusculasEMinusculas)),
          Text("- Um caracter especial ", style: estiloValidador(_politicaSenhaCaractereEspecial)),
          Text("- Um número ", style: estiloValidador(_politicaSenhaNumeros)),
          confirmarSenha ? Text("- Senhas coincidem ", style: estiloValidador(_politicaSenhaMatch)) : SizedBox.shrink(),
        ],
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
    );
  }

  void visualizarSenha() {
    setState(() {
      senhaInvisivel = !senhaInvisivel;
    });
  }

  Widget montaTextFieldSenha() {
    return Container(
      child: Column(
        children: [
          TextField(
            controller: widget.controller,
            obscureText: senhaInvisivel,
            decoration: InputDecoration(suffixIcon: GestureDetector(child: iconeVisivel(senhaInvisivel), onTap: visualizarSenha)),
            onChanged: (value) {
              if (validaPoliticaSenha()) {
                //Padrão válido
                GeralhHelperDebouncer(Duration(seconds: 1)).executar(() {
                  setState(() {
                    exibeValidacoes = false;
                    widget.aoValidarComSucesso(true);
                  });
                });
              } else {
                //Padrão inválido
                exibeValidacoes = true;
              }
            },
          ),
          toolTipSenha(exibeValidacoes)
        ],
      ),
    );
  }

  bool validaPoliticaSenha() {
    String valor = widget.controller.text;
    String valorConfirmar = widget.controllerConfirmar?.text ?? "";

    if ((valor ?? "").isEmpty) valor = "";

    String _pattern8Digitos = r".{8,}";
    String _patternCaractereEspecial = r"\W";
    String _patternLetrasMaiusculas = r"[A-Z]";
    String _patternLetrasMinusculas = r"[a-z]";
    String _patternNumeros = r"\d";

    _politicaSenha8Digitos = RegExp(_pattern8Digitos).hasMatch(valor);
    _politicaSenhaCaractereEspecial = RegExp(_patternCaractereEspecial).hasMatch(valor);
    _politicaSenhaLetrasMaiusculasEMinusculas = (RegExp(_patternLetrasMaiusculas).hasMatch(valor) && RegExp(_patternLetrasMinusculas).hasMatch(valor));
    _politicaSenhaNumeros = RegExp(_patternNumeros).hasMatch(valor);
    _politicaSenhaValida = _politicaSenha8Digitos && _politicaSenhaCaractereEspecial && _politicaSenhaLetrasMaiusculasEMinusculas && _politicaSenhaNumeros; // && (valorConfirmar != "" && _politicaSenhaMatch);

    if (valorConfirmar != '') {
      _politicaSenhaMatch = valor == valorConfirmar && valorConfirmar.length > 0;
      _politicaSenhaValida = _politicaSenhaValida && _politicaSenhaMatch;
    }

    setState(() => _politicaSenhaValida);
    return _politicaSenhaValida;
  }

  TextStyle estiloValidador(bool isValido) {
    return TextStyle(fontSize: 15, color: isValido ? Colors.green : Colors.red);
  }

  Widget iconeVisivel(bool isVisivel) {
    return !isVisivel ? Icon(Icons.visibility) : Icon(Icons.visibility_off);
  }
}

class GeralhHelperDebouncer {
  final Duration duracao;
  VoidCallback acaoCallback;
  Timer _timer;
  GeralhHelperDebouncer(this.duracao);

  executar(VoidCallback acaoCallback) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(duracao, acaoCallback);
  }
}
