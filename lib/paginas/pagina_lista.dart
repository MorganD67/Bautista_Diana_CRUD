import 'package:flutter/material.dart';
import 'package:flutter_crud_didi/db/operaciones.dart';
import 'package:flutter_crud_didi/paginas/guardar_pagina.dart';
import 'package:flutter_crud_didi/paginas/editar_nota.dart';
import 'package:flutter_crud_didi/modelos/notas.dart';

class ListPages extends StatefulWidget {
  const ListPages({Key? key}) : super(key: key);

  @override
  State<ListPages> createState() => _ListPagesState();
}

class _ListPagesState extends State<ListPages> {
  List<Nota> notas = [];

  @override
  void initState() {
    _cargarDatos();
    Operaciones.setOnDatabaseChange(
        _onDatabaseChange); // Establecer el callback de cambio
    super.initState();
  }

  void _onDatabaseChange() {
    _cargarDatos(); // Cargar datos cuando haya cambios en la base de datos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => guardarPagina()),
          );
          if (result == true) {
            _cargarDatos(); // Actualiza la lista cuando se agrega una nueva nota
          }
        },
        backgroundColor: Colors.amberAccent,
      ),
      appBar: AppBar(
        title: const Text('Rush'),
        backgroundColor: Colors.amberAccent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: _buildListaNotas(),
      ),
    );
  }

  Widget _buildListaNotas() {
    return FutureBuilder<List<Nota>>(
      future: Operaciones.obtenerNotas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay notas disponibles'));
        } else {
          notas = snapshot.data!;
          return ListView.builder(
            itemCount: notas.length,
            itemBuilder: (_, index) {
              return _buildItemNota(context, index);
            },
          );
        }
      },
    );
  }

  Widget _buildItemNota(BuildContext context, int index) {
    Nota nota = notas[index];
    return Dismissible(
      key: Key(nota.id.toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: const EdgeInsets.only(left: 20),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete, color: Colors.white, size: 30),
        ),
      ),
      onDismissed: (direction) {
        // Eliminar nota
        Operaciones.eliminarOperacion(nota);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          leading: CircleAvatar(
            backgroundColor: Colors.amberAccent,
            child: const Icon(
              Icons.laptop_windows_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Text(
            nota.titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          trailing: const Icon(Icons.edit, color: Colors.black54),
          onTap: () async {
            bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditNoteScreen(nota: nota),
              ),
            );
            if (result == true) {
              _cargarDatos(); // Actualiza la lista cuando se edita una nota
            }
          },
        ),
      ),
    );
  }

  void _cargarDatos() async {
    List<Nota> auxNotas = await Operaciones.obtenerNotas();
    setState(() {
      notas = auxNotas;
    });
  }
}
