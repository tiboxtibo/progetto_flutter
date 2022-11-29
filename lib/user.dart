
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progetto_flutter_versione_00/main.dart';



class UserPage extends StatefulWidget {
  String username_utente;
  UserPage(this.username_utente);

  @override
  UserPageState createState() => UserPageState(this.username_utente);
}

class UserPageState extends State<UserPage> {
  String username_utente;
  UserPageState(this.username_utente);
  final urlPrenotazioni = "http://10.0.2.2:8080/EsServlet_war_exploded/ListaPrenotazioniPersonaleServletFlutter";
  final urlEliminaPrenotazione = "http://10.0.2.2:8080/EsServlet_war_exploded/EliminaPrenotazioneServletFlutter";
  final urlConfermaPrenotazione = "http://10.0.2.2:8080/EsServlet_war_exploded/ConfermaPrenotazioneServletFlutter";
  var _postsJson = [];

  static const IconData logout = IconData(0xe3b3, fontFamily: 'MaterialIcons');

  void postDataCancellaPrenotazione(String nome_corso,String username_docente,String giorno,int ora,int id_prenotazione) async {

    try {

      String oraa= ora.toString();
      String id_prenotazionee= id_prenotazione.toString();

      final response = await post(Uri.parse(urlEliminaPrenotazione), body: {
        "nome_corso": nome_corso,
        "username_docente": username_docente,
        "username_utente": username_utente,
        "giorno": giorno,
        "ora": oraa,
        "id_prenotazione":id_prenotazionee,
      });

      print(response.body);

    } catch (er) {

      print(er);
    }
  }

  void postDataConfermaPrenotazione(String nome_corso,String username_docente,String giorno,int ora,int id_prenotazione) async {

    try {

      String oraa= ora.toString();
      String id_prenotazionee= id_prenotazione.toString();

      final response = await post(Uri.parse(urlConfermaPrenotazione), body: {
        "nome_corso": nome_corso,
        "username_docente": username_docente,
        "username_utente": username_utente,
        "giorno": giorno,
        "ora": oraa,
        "id_prenotazione":id_prenotazionee,
      });


      print(response.body);

    } catch (er) {

      print(er);
    }
  }

  void fetchPrenotazioniPersonali() async {

    try{

      final response = await post(Uri.parse(urlPrenotazioni), body: {
        "username_utente": username_utente,
      });

      final jsonData = jsonDecode(response.body) as List;

      print("Prenotazioni personali ricaricate");

      setState(() {
        _postsJson=jsonData;
      });
    }
    catch(err){
      print(err);
    }

  }
  @override
  void initState() {
    super.initState();
    fetchPrenotazioniPersonali();
  }

  Widget _listViewBody() {
    return ListView.builder(
        itemCount : _postsJson.length,
        itemBuilder: (context,i){
          final post = _postsJson[i];
          //return Text("Nome corso: ${post["nome_corso"]} \n Username utente: ${post["username_utente"]}\n\n");
          return ElevatedButton(
              onPressed: () {
                if((post["stato_prenotazione"] as int)==-1){
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Prenotazione già cancellata')));
                  //print("prenotazione già cancellata");
                }
                if((post["stato_prenotazione"] as int)==1){
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Prenotazione Confermata')));
                  //print("prenotazione Confermata");

                  String nome_corso=post["nome_corso"] as String;
                  String username_docente=post["username_docente"] as String;
                  //String username_utente="tiboxtibo";
                  String giorno=post["giorno"] as String;
                  int ora = post["ora"] as int;
                  int id_prenotazione = post["id_prenotazione"] as int;

                  postDataConfermaPrenotazione(nome_corso,username_docente,giorno,ora,id_prenotazione);
                  fetchPrenotazioniPersonali();
                }
                if((post["stato_prenotazione"] as int)==0){
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Prenotazione già Confermata')));
                  //print("prenotazione già Confermata");
                }

              },
              onLongPress: () {

                if((post["stato_prenotazione"] as int)==1){
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Prenotazione Cancellata')));

                  String nome_corso=post["nome_corso"] as String;
                  String username_docente=post["username_docente"] as String;
                  //String username_utente="tiboxtibo";
                  String giorno=post["giorno"] as String;
                  int ora = post["ora"] as int;
                  int id_prenotazione = post["id_prenotazione"] as int;


                  postDataCancellaPrenotazione(nome_corso,username_docente,giorno,ora,id_prenotazione);
                  fetchPrenotazioniPersonali();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: (post["stato_prenotazione"] as int==-1) ? Colors.red : ((post["stato_prenotazione"] as int==1) ? Colors.green : Colors.blue),
              ),
              child: Text("Nome corso: ${post["nome_corso"]} \nUsername docente: ${post["username_docente"]} \nGiorno: ${post["giorno"]} \nOra: ${post["ora"]}\nStato: ${post["stato_prenotazione"]}\n\n")
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(username_utente + " User page", style: TextStyle(fontSize: 24),),
          actions: <Widget>[
            IconButton(
            icon: const Icon(logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  MyApp()), (Route<dynamic> route) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout'))
              );
            },
    ),
          ]

      ),
      body:_listViewBody(),

    );
  }


}


