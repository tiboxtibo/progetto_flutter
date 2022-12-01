
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progetto_flutter_versione_00/main.dart';


/** Pagina personale User */
class UserPage extends StatefulWidget {
  String username_utente;
  UserPage(this.username_utente);

  @override
  UserPageState createState() => UserPageState(this.username_utente);
}


class UserPageState extends State<UserPage> {
  String username_utente;
  UserPageState(this.username_utente);

  final urlUtente = "http://10.0.2.2:8080/EsServlet_war_exploded/UtenteServlet";
  var _postsJson = [];

  String dispositivo= "flutter";
  String userOperation= "";

  static const IconData logout = IconData(0xe3b3, fontFamily: 'MaterialIcons');

  /** Si connette tramite Post alla servlet User nel progetto di tweb */
  /** Cancella la prenotazione */
  void postDataCancellaPrenotazione(String nome_corso,String username_docente,String giorno,int ora,int id_prenotazione) async {

    try {

      String oraa= ora.toString();
      String id_prenotazionee= id_prenotazione.toString();

      final response = await post(Uri.parse(urlUtente), body: {
        "nome_corso": nome_corso,
        "username_docente": username_docente,
        "username_utente": username_utente,
        "giorno": giorno,
        "ora": oraa,
        "id_prenotazione":id_prenotazionee,
        "dispositivo": dispositivo,
        "userOperation": "eliminaPrenotazione"
      });

      print(response.body);

    } catch (er) {

      print(er);
    }
  }

  /** Si connette tramite Post alla servlet User nel progetto di tweb */
  /** Conferma la prenotazione */
  void postDataConfermaPrenotazione(String nome_corso,String username_docente,String giorno,int ora,int id_prenotazione) async {

    try {

      String oraa= ora.toString();
      String id_prenotazionee= id_prenotazione.toString();

      final response = await post(Uri.parse(urlUtente), body: {
        "nome_corso": nome_corso,
        "username_docente": username_docente,
        "username_utente": username_utente,
        "giorno": giorno,
        "ora": oraa,
        "id_prenotazione":id_prenotazionee,
        "dispositivo": dispositivo,
        "userOperation": "confermaPrenotazione"
      });


      //print(response.body);

    } catch (er) {

      print(er);
    }
  }

  /** Si connette tramite Post alla servlet User nel progetto di tweb */
  /** Visualizza l'elenco delle prenotazioni personali */
  void fetchPrenotazioniPersonali() async {

    try{

      final response = await post(Uri.parse(urlUtente), body: {
        "username_utente": username_utente,
        "dispositivo": dispositivo,
        "userOperation": "listaPrenotazioniPersonale"
      });

      final jsonData = jsonDecode(response.body) as List;

      //print("Prenotazioni personali ricaricate");

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
    fetchPrenotazioniPersonali();
  }

  /** Widget che visualizza la lista delle prenotazioni già effettuate, quelle cancellate e prenotate */
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
                                if((post["stato_prenotazione"] as int)==-1){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(duration: const Duration(seconds: 1),content: Text('Prenotazione già cancellata')));
                                  //print("prenotazione già cancellata");
                                }
                                if((post["stato_prenotazione"] as int)==1){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(duration: const Duration(seconds: 1),content: Text('Prenotazione Confermata')));
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
                                      const SnackBar(duration: const Duration(seconds: 1),content: Text('Prenotazione già Confermata')));
                                  //print("prenotazione già Confermata");
                                }

                              },
                              onLongPress: () {

                                if((post["stato_prenotazione"] as int)==1){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(duration: const Duration(seconds: 1),content: Text('Prenotazione Cancellata')));

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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40), // <-- Radius
                                ),
                                backgroundColor: (post["stato_prenotazione"] as int==-1) ? Colors.red[100] : ((post["stato_prenotazione"] as int==1) ? Colors.green[100] : Colors.grey[200]),
                              ),
                            child: Text("${post["nome_corso"]} | Docente: ${post["username_docente"]} \n  ${post["giorno"]} ${post["ora"]}:00",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                ),),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    );
                  }
              ))
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
              },
            ) ,
            backgroundColor: Colors.grey[100],
            shadowColor: Colors.grey[500],
            title: Text(
              username_utente + " User Page",
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
      body:_listViewBody(),

    );
  }


}


