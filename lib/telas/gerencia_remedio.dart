//Bibliotecas externas
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Classes próprias
import 'package:appseniorcare/componentes/container.dart';
import 'package:appseniorcare/componentes/texto.dart';
import 'package:appseniorcare/componentes/botao.dart';
import 'package:appseniorcare/componentes/mensagem.dart';
import 'package:appseniorcare/mqtt.dart';

/*-------------------------- Função 3: Gerencia remédios -----------------------

Essa função se estende para as telas:

- gerenciador_remedio_caixa
- gerenciador_remedio_medicamento

Os seguintes tópicos MQTT são utilizados nesta função:

1. CAIXA_STATUS (leitura): Indica se o ESP32 está ou não conectado ao servidor
   broker, ou seja, se o dispositivo está ligado ('1') ou desligado ('0');

2. CAIXA_COMPARTIMENTO (leitura e escrita): Indica o número do compartimento
   selecionado, variando de 0 a 15. A informação é enviada em formato JSON.

3. NOVO_INPUT (escrita): Contém as informações sobre o medicamento selecionado,
   e é enviado em formato JSON.
------------------------------------------------------------------------------*/

class gerencia_remedio extends StatefulWidget {
  const gerencia_remedio({super.key});

  @override
  State<gerencia_remedio> createState() => _gerencia_remedioState();
}

class _gerencia_remedioState extends State<gerencia_remedio> {
  String lCaixaStatus =
      ''; //Armazena o tópico CAIXA_STATUS referente ao estado do caixa
  String lCaixaDados =
      ''; //Armazena o tópico NOVO_INPUT referente ao estado do MPU
  bool status = false; //Controle do botão de liga/desliga

  //Construção da tela
  @override
  Widget build(BuildContext context) {
    return Consumer<ConcreteMqttService>(
        builder: (context, mqttService, child) {
      //Le a mensagem dos tópicos
      lCaixaStatus = mqttService.msgCaixaStatus;
      lCaixaDados = mqttService.msgCaixaDados;

      if (lCaixaStatus == "1")
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
                            texto: "Gerenciador de remédios",
                            cor: Colors.white),

                        //Descrição da função
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextoPadrao(
                                texto:
                                    "Utilize uma caixa de remédios personalizada que,"
                                    " no horário em que se deve tomar a medicação, informará em qual compartimento"
                                    " está localizado o comprimido que deve ser ingerido.\n",
                                cor: Colors.white70)),

                        //Reescrevendo classe Botão Função Complementar
                        GestureDetector(
                          onTap: () {
                            if (lCaixaStatus == "1")
                              Navigator.pushNamed(context, "/telas/gerencia_remedio_caixa");
                            else
                              AlertaDispositivoDesligado(context);
                          },
                          //Botão
                          child: Container(
                              height: 50,
                              width: 330,
                              margin: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(
                                          0.0, //horizontal
                                          5.0))
                                ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  //Icone azul
                                  Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Container(
                                          height: 50,
                                          width: 65,
                                          padding: EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                            color: Colors.lightBlue,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                          ),
                                          child:
                                              Image.asset("img/icon/add.png"))),

                                  //Descrição botão
                                  Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: TextoPadrao(
                                          texto: "Adicionar medicamento",
                                          cor: Colors.black45)),
                                ],
                              )),
                        ),
                      ])),

                  DispositivoEstado(
                      caminho: "img/first-aid-box.png",
                      distancia_antes:
                          MediaQuery.of(context).size.height * 0.05,
                      distancia_depois:
                          MediaQuery.of(context).size.height * 0.05,
                      cor: lCaixaStatus == "1"
                          ? Colors.greenAccent.withOpacity(0.5)
                          : Colors.redAccent.withOpacity(0.5)),

                  lCaixaStatus == "1"
                      ? (TextoPadrao(
                          texto: "Dispositivo ligado", cor: Colors.black45))
                      : TextoPadrao(
                          texto: "Dispositivo desligado", cor: Colors.black45),
                ],
              ))));
    });
  }
}
