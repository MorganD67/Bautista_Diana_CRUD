import 'package:flutter/material.dart';
import 'package:flutter_crud_didi/db/operaciones.dart';
import 'package:flutter_crud_didi/modelos/notas.dart';

class EditNoteScreen extends StatefulWidget {
  final Nota nota;

  EditNoteScreen({required this.nota});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.nota.titulo);
    _descriptionController = TextEditingController(text: widget.nota.descripcion);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Nota'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese un título';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Título de la Nota',
                  labelStyle: TextStyle(color: Colors.amberAccent),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amberAccent),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                maxLength: 1000,
                maxLines: 4,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Descripción de la Nota',
                  labelStyle: TextStyle(color: Colors.amberAccent),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amberAccent),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      child: Text('Actualizar nota'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            // Actualizar los datos de la nota
                            final updatedNota = Nota(
                              id: widget.nota.id,
                              titulo: _tituloController.text,
                              descripcion: _descriptionController.text,
                            );

                            // Llamar a la función de actualización en Operaciones
                            await Operaciones.actualizarOperacion(updatedNota);

                            setState(() {
                              _isLoading = false;
                            });

                            // Notificar éxito y volver a la lista
                            Navigator.pop(context, true); // Esto notifica que la edición fue exitosa
                          } catch (e) {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al actualizar la nota: $e')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
