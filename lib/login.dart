
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'main.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Login',
    home: LoginPage(),
  ));
}


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}


class LoginPageState extends State<LoginPage> {
  final urlLogin = "http://10.0.2.2:8080/EsServlet_war_exploded/LoginServlet";

  var username_utente = TextEditingController();
  var password_utente = TextEditingController();


   void postData(String username_utente,String password_utente) async {
    try {
      final response = await post(Uri.parse(urlLogin), body: {
        "username_utente": username_utente,
        "password_utente": password_utente,
      });

      int ruolo= int.parse(response.body);
      String username_utente_pass= username_utente;

      if(ruolo==0){//pagina utente

        Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage(username_utente_pass)));

      }
      else{
        print("Errore");
      }

    } catch (er) {
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Center(

                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: username_utente,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter a valid username'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: password_utente,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter your password'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: () {

                  print("username:" + username_utente.text);
                  print("password:" + password_utente.text);

                  postData(username_utente.text,password_utente.text);

                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 130,
              ),
              const Text('Progetto IUM-tweb 2022-2023')
            ],
          ),
        ),
    );
  }


}


