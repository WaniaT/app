import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//-------------------------------- Containers ----------------------------------
//Imagem
class Imagem extends StatelessWidget {
  const Imagem(
      {super.key,
      required this.distancia_antes,
      required this.distancia_depois,
      required this.caminho});

  final double distancia_antes;
  final double distancia_depois;
  final String caminho;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.only(top: distancia_antes, bottom: distancia_depois),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Image.asset(caminho)],
        ));
  }
}

//------------------------------------------------------------------------------
//Círculo colorido com imagem
class DispositivoEstado extends StatelessWidget {
  const DispositivoEstado({
    Key? key,
    required this.distancia_antes,
    required this.distancia_depois,
    required this.caminho,
    required this.cor,
  }) : super(key: key);

  final double distancia_antes;
  final double distancia_depois;
  final Color cor;
  final String caminho;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: distancia_antes, bottom: distancia_depois),
      child: Stack(
        children: [
          Container(
            width: 160, // Ajuste o tamanho do oval externo conforme necessário
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cor, // Cor da sombra
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(14),
            child: ClipOval(
              child: Container(
                //width: 140, // Ajuste o tamanho do oval interno conforme necessário
                //height: 10,
                color: Colors.transparent, // Torna o oval interno transparente
                child: Image.asset(
                  caminho,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
