import 'package:flutter/material.dart';
import 'package:flutter_crud_didi/db/operaciones.dart';
import 'package:flutter_crud_didi/modelos/notas.dart';

class guardarPagina extends StatefulWidget {
  const guardarPagina({super.key});

  @override
  State<guardarPagina> createState() => _guardarPaginaState();
}

class _guardarPaginaState extends State<guardarPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardar Nota'),
        backgroundColor: Colors.amberAccent,
      ),
      body: const GuardarFormulario(),
    );
  }
}

class GuardarFormulario extends StatefulWidget {
  const GuardarFormulario({super.key});

  @override
  State<GuardarFormulario> createState() => _GuardarFormularioState();
}

class _GuardarFormularioState extends State<GuardarFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _tituloController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingrese un título';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Título de la Nota',
                labelStyle: const TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.amberAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.title, color: Colors.amberAccent),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcionController,
              maxLength: 1000,
              maxLines: 4,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingresa una descripción';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Descripción de la nota',
                labelStyle: const TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.amberAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.description, color: Colors.amberAccent),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
              child: const Text('Guardar Nota', style: TextStyle(fontSize: 16)),
              onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          await Operaciones.insertarOperacion(
                            Nota(
                              titulo: _tituloController.text,
                              descripcion: _descripcionController.text,
                            ),
                          );

                          setState(() {
                            _isLoading = false;
                          });

                          Navigator.pop(context, true); // Regresar a la pantalla principal y enviar un resultado positivo
                        } catch (e) {
                          setState(() {
                            _isLoading = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al guardar la nota: $e')),
                          );

                          Navigator.pop(context, false); // Regresar a la pantalla principal y enviar un resultado negativo
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
