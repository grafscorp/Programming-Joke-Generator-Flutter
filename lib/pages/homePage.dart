import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:joke_generator/jokeapi.dart';
import 'package:share_plus/share_plus.dart';
//import 'package:share';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String joke = "";
  final jokeClient = const JokeApiClient();
  @override
  void initState() {
    super.initState();
    updateJoke();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Joke Generator",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.yellow, Colors.blue, Colors.pinkAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
              Expanded(
                child: Center(
                  child: joke != ""
                      ? Text(
                          joke,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),

              //Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 120,
                  ),
                  IconButton(
                    onPressed: () {
                      updateJoke();
                    },
                    icon: const Icon(
                      color: Colors.white,
                      Icons.replay_outlined,
                      size: 60,
                    ),
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  IconButton(
                      onPressed: () {
                        if (joke.isNotEmpty) {
                          Share.share(joke);
                        }
                      },
                      icon: const Icon(
                        Icons.share_sharp,
                        color: Colors.white,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateJoke() async {
    setState(() {
      joke = "";
    });
    final res = await jokeClient.makeRequest(JokeRequest(
        type: const JokeTypeQueryParam(JokeType.single),
        pathParameter:
            const JokePathParam(categories: [JokeCategory.programming])));
    final map = json.decode(res.body);
    setState(() {
      joke = map['joke'];
    });
  }
}
