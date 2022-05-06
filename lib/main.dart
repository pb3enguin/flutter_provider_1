import 'package:flutter/material.dart';
import 'package:flutter_provider_1/models/babies.dart';
import 'package:provider/provider.dart';

import 'models/dog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Dog(name: 'Sun', breed: 'dog', age: 3),
        ),
        FutureProvider(
          create: (context) {
            final int dogAge = context.read<Dog>().age;
            final babies = Babies(age: dogAge);
            return babies.getBabies();
          },
          initialData: 0,
        ),
        StreamProvider<String>(
          create: (context) {
            final int dogAge = context.read<Dog>().age;
            final babies = Babies(age: dogAge * 2);
            return babies.bark();
          },
          initialData: 'Bark 0 times',
        )
      ],
      child: MaterialApp(
        title: 'Provider 01',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dog = Dog(name: 'dog03', breed: 'breed03');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider 01'),
      ),
      body: Consumer<Dog>(
        builder: (BuildContext context, Dog dog, Widget? child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                child!,
                const SizedBox(height: 10.0),
                Text(
                  '- name: ${dog.name}',
                  style: const TextStyle(fontSize: 20.0),
                ),
                const SizedBox(height: 10.0),
                const BreedAndAge(),
              ],
            ),
          );
        },
        child: const Text(
          // avoid rebuild
          'I like dogs very much!',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}

class BreedAndAge extends StatelessWidget {
  const BreedAndAge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Dog>(
      builder: (_, Dog dog, __) {
        return Column(
          children: [
            Text(
              '- breed: ${dog.breed}',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 10.0),
            const Age(),
          ],
        );
      },
    );
  }
}

class Age extends StatelessWidget {
  const Age({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Dog>(
      builder: (_, dog, __) {
        return Column(
          children: [
            Text(
              '- age: ${dog.age}',
              style: const TextStyle(fontSize: 20.0),
            ),
            // const SizedBox(height: 20.0),
            // Text(
            //   '- number of babies: ${context.watch<int>()}',
            //   style: const TextStyle(fontSize: 20.0),
            // ),
            // const SizedBox(height: 10.0),
            // Text(
            //   '- ${context.watch<String>()}',
            //   style: TextStyle(fontSize: 20.0),
            // ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => dog.grow(),
              child: const Text('Grow'),
            )
          ],
        );
      },
    );
  }
}
