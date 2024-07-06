import 'package:flutter/material.dart';
import 'package:flutter_crud_didi/paginas/pagina_lista.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas :3',
      debugShowCheckedModeBanner: false,
      home: ListPages(),
    );
  }
}