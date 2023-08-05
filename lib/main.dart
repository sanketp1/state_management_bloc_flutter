import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: HomePage(),
      );
}

const names = ['Foo', 'Bar', 'Baz'];

extension RandomElement on Iterable<dynamic> {
  dynamic getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() => emit(names.getRandomElement() as String);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NamesCubit _namesCubit;
  @override
  void initState() {
    _namesCubit = NamesCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bloc App"),
      ),
      body: StreamBuilder(
        stream: _namesCubit.stream,
        builder: (context, snapshot) {
          final button = ElevatedButton(
              onPressed: () => _namesCubit.pickRandomName(),
              child: const Text("Pick Random Name"));
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
              return Center(   
                child: Column(
                  children: [
                    Text(
                      snapshot.data ?? "",
                      style: const TextStyle(fontSize: 20),
                    ),
                    button
                  ],
                ),
              );
            case ConnectionState.done:
              return SizedBox();

            default:
              return button;
          }
        },
      ),
    );
  }
}
