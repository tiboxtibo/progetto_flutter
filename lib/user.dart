
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
  final urlPrenotazioni = "http://10.0.2.2:8080/EsServlet_war_exploded/ListaPrenotazioniPersonaleServletFlutter";
  var _postsJson = [];

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
                /*
                String nome_corso=post["nome_corso"] as String;
                String username_docente=post["username_docente"] as String;
                //String username_utente="tiboxtibo";
                String giorno=post["giorno"] as String;
                int ora = post["ora"] as int;

                print(ora);

                //postDataPrenota(nome_corso,username_docente,giorno,ora);
                fetchPrenotazioniPersonali();

                 */
              },
              child: Text("Nome corso: ${post["nome_corso"]} \nUsername docente: ${post["username_docente"]} \nGiorno: ${post["giorno"]} \nOra: ${post["ora"]}\n\n")
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


