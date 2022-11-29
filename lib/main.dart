
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progetto_flutter_versione_00/user.dart';



class HomePage extends StatefulWidget {
  String username_utente;
  HomePage(this.username_utente);

  @override
  HomePageState createState() => HomePageState(this.username_utente);
}

class HomePageState extends State<HomePage> {
  String username_utente;
  HomePageState(this.username_utente);

  static const IconData account_circle_sharp = IconData(0xe743, fontFamily: 'MaterialIcons');


  final url = "http://10.0.2.2:8080/EsServlet_war_exploded/Prenotazioni-Disponibili-Servlet";
  final urlPrenota = "http://10.0.2.2:8080/EsServlet_war_exploded/PrenotaServletFlutter";
  var _postsJson = [];


  void postDataPrenota(String nome_corso,String username_docente,String giorno,int ora) async {
    print("1");
    try {
      print("2");
      String oraa= ora.toString();

      final response = await post(Uri.parse(urlPrenota), body: {
        "nome_corso": nome_corso,
        "username_docente": username_docente,
        "username_utente": username_utente,
        "giorno": giorno,
        "ora": oraa,
      });
      print("kkk");
      print(response.body);

    } catch (er) {
      print("3");
      print(er);
    }
  }

  void fetchPrenotazione() async {

    try{

      final response = await get(Uri.parse(url));

      final jsonData = jsonDecode(response.body) as List;


      print("Prenotazioni prenotabili ricaricate");

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
    fetchPrenotazione();
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

                print(ora);

                postDataPrenota(nome_corso,username_docente,giorno,ora);
                fetchPrenotazione();
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
          "Benvenuto  " + username_utente,
          style: TextStyle(fontSize: 24),
        )
        ),
        body: _listViewBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => UserPage(username_utente)));
        },
        label: const Text('User Page'),
        icon: const Icon(account_circle_sharp),
        backgroundColor: Colors.pink,
      ),

    );
  }


}


