
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progetto_flutter_versione_00/user.dart';
import 'main.dart';

/** HomePage Utente */
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


  final urlUtente = "http://10.0.2.2:8080/EsServlet_war_exploded/UtenteServlet";


  var _postsJson = [];

  String dispositivo= "flutter";
  String userOperation= "";

  static const IconData logout = IconData(0xe3b3, fontFamily: 'MaterialIcons');


  /** Si connette tramite Post alla servlet Utente nel progetto di tweb */
  /** Prenota una prenotazione creata virtualmente e visualizzata a schermo come elenco di bottoni*/
  void postDataPrenota(String nome_corso,String username_docente,String giorno,int ora) async {

    try {

      String oraa= ora.toString();

      final response = await post(Uri.parse(urlUtente), body: {
        "nome_corso": nome_corso,
        "username_docente": username_docente,
        "username_utente": username_utente,
        "giorno": giorno,
        "ora": oraa,
        "dispositivo": dispositivo,
        "userOperation": userOperation
      });

      //print(response.body);

    } catch (er) {

      print(er);
    }
  }

  /** Si connette tramite Post alla servlet Utente nel progetto di tweb */
  /** Visualizza una lista virtutale di prenotazioni che possono essere effettuate*/
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

  /** Metodi caricati all'avvio della pagina */
  @override
  void initState() {
    super.initState();
    fetchPrenotazione();
  }

  /** Widget che visualizza la lista delle prenotazioni che possono essere effettuate */
  Widget _listViewBody() {
    return Container(
      child: Column(
        children: [
          const SizedBox(
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
                            //print("1234");

                            String nome_corso=post["nome_corso"] as String;
                            String username_docente=post["username_docente"] as String;
                            //String username_utente="tiboxtibo";
                            String giorno=post["giorno"] as String;
                            int ora = post["ora"] as int;
                            userOperation="prenota";

                            //print(ora);

                            postDataPrenota(nome_corso,username_docente,giorno,ora);
                            fetchPrenotazione();

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(duration: const Duration(seconds: 1),content: Text('Prenotazione Prenotata')));
                          },
                          child: Text("${post["nome_corso"]} | Docente: ${post["username_docente"]} \n  ${post["giorno"]} ${post["ora"]}:00",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
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
                      const SizedBox(
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

  /** Build dell'applicazione */
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => UserPage(username_utente)));
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(duration: const Duration(seconds: 3),content: Text('Premi per confermare e tieni premuto per cancellare'))
          );

        },
        label: const Text('User Page'),
        icon: const Icon(account_circle_sharp),
        backgroundColor: Colors.pink,
      ),

    );
  }


}


