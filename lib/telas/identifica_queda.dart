//Bibliotecas externas
import 'package:flutter/material.dart';
import 'package:typed_data/src/typed_buffer.dart';
import 'package:provider/provider.dart';

//Classes próprias
import 'package:appseniorcare/componentes/container.dart';
import 'package:appseniorcare/componentes/texto.dart';
import 'package:appseniorcare/componentes/botao.dart';
import 'package:appseniorcare/componentes/mensagem.dart';
import 'package:appseniorcare/mqtt.dart';

/*----------------- Função 2: Identifica ocorrência de queda -------------------

 Os seguintes tópicos MQTT são utilizados nesta função:

 1. MPU_STATUS (leitura): Indica se o ESP32 está ou não conectado ao servidor
    broker, ou seja, se o dispositivo está ligado ('1') ou desligado ('0');

 2. MPU_QUEDA (leitura): Indica se uma queda foi identificada pelo algoritmo
    de cálculo de queda ('1' ou '0'). O algoritmo se baseia na aceleração do
    corpo, obtida através do acelerômetro e giroscópio MPU6050.

 3. MPU_ON_OFF (ESCRITA): Define se o dispostivo deve ser desligado ou não
    ('1' ou '0').

------------------------------------------------------------------------------*/

class identifica_queda extends StatefulWidget {
  const identifica_queda({super.key});

  @override
  State<identifica_queda> createState() => _identifica_quedaState();
}

class _identifica_quedaState extends State<identifica_queda> {

  //Tópicos MQTT
  String lMpuStatus = ''; // Le e publica mensagens no tópico MPU_STATUS
  String lMpuQueda = '';  // Le as mensagens no tópica MPU_QUEDA
  String lMpuOnOff = '';  // Publica mensagens no tópico MPU_ON_OFF

  //Controle interno
  bool status = false; // Controle do botão de liga/desliga
  String message = '';

  //Contrução da tela
  @override
  Widget build(BuildContext context) {
    return Consumer<ConcreteMqttService>(
        builder: (context, mqttService, child) {

      // Recupera os valores dos tópicos
      lMpuStatus = mqttService.msgMpuStatus;
      lMpuQueda = mqttService.msgMpuQueda;
      lMpuOnOff = mqttService.msgMpuOnOff;

      // Determina o estado do dispositivo
      if (lMpuStatus == '1')
        status = true;
      else
        status = false;

      //Estrutura da tela
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.blue, bottomOpacity: 0.0, elevation: 0.0),
          body: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.05),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [Colors.blue, Colors.white])),
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
                            texto: "Identificador de queda", cor: Colors.white),
                        //Descrição da função
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextoPadrao(
                                texto:
                                    "Utilize um dispositivo que monitore a mobilidade da pessoa idosa e, no "
                                    "caso de queda, a Alexa prestará socorro por comando de voz. Você será "
                                    "notificado mediante a necessidade de ajuda.",
                                cor: Colors.white70)),

                        //Botão liga-desliga
                        Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: BotaoLigaDesliga(
                                value: status,
                                onChanged: (bool val) {
                                  //Se o dispositivo estiver desligado envia notificação de alerta
                                  if (status == false) {
                                    AlertaMpuDesligado(context);
                                  }

                                  //Se estiver ligado pode mudar o estado para desligado
                                  else if (status == true) {
                                    setState(() {
                                      final message = '0';
                                      final uint8Buffer =
                                          Uint8Buffer(); // Converte a mensagem de string para binario
                                      uint8Buffer.addAll(message.codeUnits);
                                      mqttService.publishMessage('MPU_STATUS',
                                          uint8Buffer); //Publica mensagem MQTT
                                    });
                                  }
                                  status = val;
                                })),

                        status == true
                            ? TextoPadrao(
                            texto: "Clique para desligar o dispositivo",
                            cor: Colors.white70)
                            : TextoPadrao(
                            texto: "Pressione o botão no dispositivo",
                            cor: Colors.white70)
                      ])),

                  DispositivoEstado(
                      caminho: "img/computer.png",
                      distancia_antes:
                          MediaQuery.of(context).size.height * 0.05,
                      distancia_depois:
                          MediaQuery.of(context).size.height * 0.05,
                      cor: lMpuStatus == "1"
                          ? Colors.greenAccent.withOpacity(0.3)
                          : Colors.redAccent.withOpacity(0.3)),

                  lMpuStatus == "1"
                      ? (TextoPadrao(
                          texto: "Dispositivo ligado", cor: Colors.black45))
                      : TextoPadrao(
                          texto: "Dispositivo desligado",
                          cor: Colors.black45),

                  lMpuQueda == "1" && (lMpuStatus == "1")
                      ? TextoPadrao(
                          texto: "Queda identificada!",
                          cor: status ? Colors.blue : Colors.white)
                      : TextoPadrao(
                          texto: "Nenhuma queda identificada",
                          cor: status ? Colors.blue : Colors.white),
                ],
              ))));
    });
  }
}
