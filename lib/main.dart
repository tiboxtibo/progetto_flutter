import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'homePage.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final urlLog = "http://localhost:8080/EsServlet_war_exploded/LoginServlet";
  String username = "";
  String password = "";
  bool semaforo = false;


  // Put Function
  void postData() async {
    try {
      final response = await post(Uri.parse(urlLog), body: {
        "username_utente": username,
        "password_utente": password,
      });

      print("Username: " + username);
      print(" Password: "+ password);
      int ruolo = int.parse(response.body);
      print(ruolo);

      if(ruolo == 0) {
        print("true");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(username)),
        );
      } else {
        print("False");
      }
    } catch (er) {
    }
  }
  // End Put Function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // here the desired height
        child: AppBar(
          backgroundColor: Colors.grey[100],

          shadowColor: Colors.grey[500],
          title: Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Image(
              width: 150,
              image: AssetImage('assets/Logo.png'),
            ),
          ),
          centerTitle: true,
        ),
      ),

      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Center(
                    child: Image(
                      image: AssetImage('assets/image.png'),
                    ),
                  ),
                ],
              ),),
            Expanded(child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                  boxShadow:[
                    BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 10,
                        blurRadius: 30,
                        offset: Offset(0, -10)
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Bentornato",
                      style: TextStyle(
                          height: 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 36
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: <Widget>[
                          // Input Field User and Pass
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Username",
                                labelStyle: TextStyle(
                                  color: Colors.grey[800],
                                ),
                                hintText: "Enter Username",
                                fillColor: Colors.grey[100],
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              onChanged: (String value) {
                                username = value;
                              },
                              validator: (value) {
                                return value!.isEmpty ? "Please enter Username" : null;
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Passwrod",
                                labelStyle: TextStyle(
                                  color: Colors.grey[800],
                                ),
                                hintText: "Enter Password",
                                fillColor: Colors.grey[100],
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              onChanged: (String value) {
                                password = value;
                              },
                              validator: (value) {
                                return value!.isEmpty ? "Please enter Password" : null;
                              },
                            ),
                          ),
                          // Button
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: postData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40), // <-- Radius
                                ),
                              ),
                              child: const Text("Accedi"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

}
