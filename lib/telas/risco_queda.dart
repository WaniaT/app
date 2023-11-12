//Bibliotecas externas
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typed_data/src/typed_buffer.dart';

//Classes próprias
import 'package:appseniorcare/componentes/container.dart';
import 'package:appseniorcare/componentes/texto.dart';
import 'package:appseniorcare/componentes/botao.dart';
import 'package:appseniorcare/componentes/mensagem.dart';
import 'package:appseniorcare/mqtt.dart';

/*-------------------- Função 1: Detecta o risco de queda ----------------------

 Os seguintes tópicos MQTT são utilizados nesta função:

 1. PIR_STATUS (leitura): Indica se o ESP32 está ou não conectado ao servidor
    broker, ou seja, se o dispositivo está ligado ('1') ou desligado ('0');

 2. ESTADO_SENSOR (leitura): Representa o estado do sensor PIR. Se a mensagem
    for "Detectado", representa que há risco de queda, se for "no_moviment",
    não foi detectado risco.

 3. PIR_ON_OFF (ESCRITA): Define se o sensor PIR deve detectar ('1') ou não
    ('0') o risco de queda. É alterado quando o botão on/off é clicado.
-------------------------------------------------------------------------------*/

class risco_queda extends StatefulWidget {
  const risco_queda({super.key});

  @override
  State<risco_queda> createState() => _risco_quedaState();
}

class _risco_quedaState extends State<risco_queda> {

  //Tópicos MQTT
  String lPirStatus = ''; // Le as mensagens do tópico PIR_STATUS
  String lPirQueda = ''; // Le as mensagens do tópico ESTADO_SENSOR
  String lPirOnOff = ''; // Publica mensagens no tópico PIR_ON_OFF

  //Controle interno
  bool status = false;
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<ConcreteMqttService>(
      builder: (context, mqttService, child) {

        // Recupera os valores dos tópicos
        lPirStatus = mqttService.msgPirStatus;
        lPirQueda = mqttService.msgPirQueda;
        lPirOnOff = mqttService.msgPirOnOff;

        //Verifica se o dispositivo está desligado
        if (lPirStatus == '0') status = false;

        //Estrutura da tela
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.blue,
                bottomOpacity: 0.0,
                elevation: 0.0),
            body: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.05),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Colors.blue, Colors.white],
                )),
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    //Cabeçalho azul arredondado
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                          bottom: MediaQuery.of(context).size.height * 0.04,
                          left: MediaQuery.of(context).size.width * 0.07,
                          right: MediaQuery.of(context).size.width * 0.07,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                                bottomLeft: const Radius.circular(50.0),
                                bottomRight: const Radius.circular(50.0))),
                        child: Column(children: <Widget>[
                          TituloPrincipal(
                              texto: "Detector de risco de queda",
                              cor: Colors.white),
                          //Descrição da função
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: TextoPadrao(
                                  texto:
                                      "Para pessoas que necessitem de maior amparo na mobilidade,"
                                      " posicione um sensor próximo ao pé da cama e receba um"
                                      " alerta quando o idoso precisar de ajuda para se locomover.",
                                  cor: Colors.white70)),

                          //Botão liga-desliga
                          Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 10),
                            child: BotaoLigaDesliga(
                                value: status,
                                onChanged: (bool val) {
                                  // O dispositivo está ligado e o usuário pode decidir se quer
                                  // que o sensor PIR faça ou não a leitura.
                                  if (lPirStatus == "1") {
                                    setState(() {
                                      status = val;
                                      if (status == true)
                                        message = '1';
                                      else
                                        message = '0';
                                      final uint8Buffer =
                                          Uint8Buffer(); // Converte a mensagem de string para binario
                                      uint8Buffer.addAll(message.codeUnits);
                                      mqttService.publishMessage('PIR_ON_OFF',
                                          uint8Buffer); //Publica mensagem MQTT
                                    });
                                  }
                                  // Avisa que o dispositivo está desligado
                                  else {
                                    AlertaDispositivoDesligado(context);
                                  }
                                }),
                          ),

                          status == true
                              ? TextoPadrao(
                                  texto: "Clique para desativar a função",
                                  cor: Colors.white70)
                              : TextoPadrao(
                                  texto: "Clique para ativar a função",
                                  cor: Colors.white70),
                        ])),

                    DispositivoEstado(
                        caminho: "img/pir3d.png",
                        distancia_antes:
                            MediaQuery.of(context).size.height * 0.05,
                        distancia_depois:
                            MediaQuery.of(context).size.height * 0.05,
                        cor: lPirStatus == "1"
                            ? Colors.greenAccent.withOpacity(0.3)
                            : Colors.redAccent.withOpacity(0.3)),

                    lPirStatus == "1"
                        ? (TextoPadrao(
                            texto: "Dispositivo ligado",
                            cor: Colors.black45))
                        : TextoPadrao(
                            texto: "Dispositivo desligado",
                            cor: Colors.black45),

                    lPirQueda == "Detectado"
                        ? TextoPadrao(
                            texto: "Risco de queda detectado!",
                            cor: status ? Colors.blue : Colors.white)
                        : TextoPadrao(
                            texto: "Nenhum risco de queda detectado",
                            cor: status ? Colors.blue : Colors.white),
                  ],
                ))));
      },
    );
  }
}
