
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'main.dart';


/** HomePage Amministratore */
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


  final urlUtente = "http://10.0.2.2:8080/EsServlet_war_exploded/UtenteServlet";

  var _postsJson = [];

  String dispositivo= "flutter";
  String userOperation= "";

  static const IconData logout = IconData(0xe3b3, fontFamily: 'MaterialIcons');


  void fetchPrenotazione() async {

    try{

      final response = await post(Uri.parse(urlUtente), body: {
        "username_utente": username_utente,
        "dispositivo": dispositivo,
        "userOperation": "prenotazioniDisponibili"
      });

      final jsonData = jsonDecode(response.body) as List;

      //print("Prenotazioni prenotabili ricaricate");

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
                                const SnackBar(duration: const Duration(seconds: 1),content: Text('Accesso effettuato come Amministratore -> Non è possibile prenotare')));
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
            leading: GestureDetector(
              child: const Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              } ,
            ) ,
            backgroundColor: Colors.grey[100],
            shadowColor: Colors.grey[500],
            title: Text(
              "Benvenuto  " + username_utente,
              style: const TextStyle(
                fontSize: 18,
                height: 3,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            actions: <Widget>[
              Transform.scale(
                scale: 1.5,
                child: IconButton(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 10),
                  color: Colors.red,
                  icon: const Icon(logout),
                  tooltip: 'Logout',
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    const MyApp()), (Route<dynamic> route) => false);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(duration: const Duration(seconds: 1),content: Text('Logout'))
                    );
                  },
                ),
              )
            ]
        ),
      ),
      body:
      _listViewBody(),

    );
  }


}


