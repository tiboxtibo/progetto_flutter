
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progetto_flutter_versione_00/user.dart';

import 'main.dart';



class HomePageAmministratore extends StatefulWidget {
  String username_utente;
  HomePageAmministratore(this.username_utente);

  @override
  HomePageAmministratoreState createState() => HomePageAmministratoreState(this.username_utente);
}

class HomePageAmministratoreState extends State<HomePageAmministratore> {
  String username_utente;
  HomePageAmministratoreState(this.username_utente);

  static const IconData account_circle_sharp = IconData(0xe743, fontFamily: 'MaterialIcons');


  final url = "http://10.0.2.2:8080/EsServlet_war_exploded/Prenotazioni-Disponibili-Servlet";
  final urlPrenota = "http://10.0.2.2:8080/EsServlet_war_exploded/PrenotaServletFlutter";

  var _postsJson = [];

  static const IconData logout = IconData(0xe3b3, fontFamily: 'MaterialIcons');


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
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: ListView.builder(
                itemCount : _postsJson.length,
                itemBuilder: (context,i){
                  final post = _postsJson[i];
                  //return Text("Nome corso: ${post["nome_corso"]} \n Username utente: ${post["username_utente"]}\n\n");
                  return Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 350,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Accesso effettuato come Amministratore -> Non è possibile prenotare')));
                          },
                          child: Text("${post["nome_corso"]} | Docente: ${post["username_docente"]} \n  ${post["giorno"]} ${post["ora"]}:00",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40), // <-- Radius
                            ),
                          ),
                        ),

                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],

                  );
                }
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        "Benvenuto  " + username_utente,
        style: TextStyle(fontSize: 24),

      ),
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
      body:
      _listViewBody(),

    );
  }


}


