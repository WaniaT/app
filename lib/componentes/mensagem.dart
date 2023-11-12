import 'package:appseniorcare/componentes/texto.dart';
import 'package:flutter/material.dart';

//---------------------------- Mensagens de alerta -----------------------------
// Alerta de MPU desligado
void AlertaMpuDesligado(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: TextoMedio(
            texto: 'Não há comunicação com o dispositivo',
            cor: Colors.black),
        content: TextoPadrao(
            texto: 'Ligue-o manualmente pressionando o botão de boot e verifique'
                ' se a rede wi-fi local está funcionando corretamente.',
            cor: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Feche o AlertDialog
            },
            child: Text('Fechar'),
          ),
        ],
      );
    },
  );
}
//------------------------------------------------------------------------------
// Alerta de dispositivo desligado (PIR e caixa)
void AlertaDispositivoDesligado(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: TextoMedio(
            texto: 'Não há comunicação com o dispositivo',
            cor: Colors.black),
        content: TextoPadrao(
            texto: 'Verifique se ele está conectado a uma tomada e se a rede '
                'wi-fi local está funcionando corretamente.',
            cor: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Feche o AlertDialog
            },
            child: Text('Fechar'),
          ),
        ],
      );
    },
  );
}
//------------------------------------------------------------------------------
// Alerta de queda identificada
void AlertaQuedaIdentificada(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: TextoMedio(texto: 'Queda identificada!', cor: Colors.black),
        content: TextoPadrao(texto: 'O idoso pode estar precisando de ajuda.', cor: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Feche o AlertDialog
            },
            child: Text('Fechar'),
          ),
        ],
      );
    },
  );
}
//------------------------------------------------------------------------------
// Alerta sem compartimento selecionado
void ErroSemCompartimento(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: TextoMedio(
            texto: 'Selecione um compartimento',
            cor: Colors.black),
        content: TextoPadrao(texto: 'Clique no compartimento da caixa que você '
            'deseja colocar seu medicamento.', cor: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Feche o AlertDialog
            },
            child: Text('Fechar'),
          ),
        ],
      );
    },
  );
}

//------------------------------------------------------------------------------
// Alerta campos não preenchidos
void CampoVazio(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: TextoMedio(texto: 'Existem campos vazios', cor: Colors.black),
        content: TextoPadrao(texto: 'Preencha todos os campos para prosseguir', cor: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Feche o AlertDialog
            },
            child: Text('Fechar'),
          ),
        ],
      );
    },
  );
}