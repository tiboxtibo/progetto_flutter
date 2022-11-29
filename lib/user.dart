
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';



class UserPage extends StatefulWidget {
  String username_utente;
  UserPage(this.username_utente);

  @override
  UserPageState createState() => UserPageState(this.username_utente);
}

class UserPageState extends State<UserPage> {
  String username_utente;
  UserPageState(this.username_utente);
  final urlPrenotazioni = "http://localhost:8080/EsServlet_war_exploded/ListaPrenotazioniPersonaleServletFlutter";
  final urlEliminaPrenotazione = "http://localhost:8080/EsServlet_war_exploded/EliminaPrenotazioneServlet";

  var _postsJson = [];

  void postDataCancellaPrenotazione(String nome_corso,String username_docente,String giorno,int ora,int id_prenotazione) async {
    print("11");
    try {
      print("22");
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
      print("kkk");
      print(response.body);

    } catch (er) {
      print("3");
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

                print("1234");

                String nome_corso=post["nome_corso"] as String;
                String username_docente=post["username_docente"] as String;
                //String username_utente="tiboxtibo";
                String giorno=post["giorno"] as String;
                int ora = post["ora"] as int;
                int id_prenotazione = post["id_prenotazione"] as int;


                postDataCancellaPrenotazione(nome_corso,username_docente,giorno,ora,id_prenotazione);
                fetchPrenotazioniPersonali();


              },
              child: Text("Nome corso: ${post["nome_corso"]} \nUsername docente: ${post["username_docente"]} \nGiorno: ${post["giorno"]} \nOra: ${post["ora"]}\nStato: ${post["stato_prenotazione"]}\n\n")
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        "Benvenuto nella user page " + username_utente,
        style: TextStyle(fontSize: 24),
      )
      ),
      body:_listViewBody(),

    );
  }


}


