import 'package:booksy_app/features/book/bloc/add_book_bloc.dart';
import 'package:booksy_app/features/book/bloc/add_book_event.dart';
import 'package:booksy_app/features/book/bloc/add_book_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _condition = 'good';
  String _operationType = 'exchange';
  int _categoryId = 1;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final data = <String, dynamic>{
      'title': _titleController.text.trim(),
      'author': _authorController.text.trim(),
      'physical_condition': _condition,
      'operation_type': _operationType,
      'category_id': _categoryId,
      if (_descriptionController.text.trim().isNotEmpty)
        'description': _descriptionController.text.trim(),
    };

    context.read<AddBookBloc>().add(SubmitBook(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text('Subir un Libro'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Autor',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El autor es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descripción (Opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _condition,
                decoration: const InputDecoration(
                  labelText: 'Condición',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'new', child: Text('Nuevo')),
                  DropdownMenuItem(
                    value: 'like_new',
                    child: Text('Como nuevo'),
                  ),
                  DropdownMenuItem(value: 'good', child: Text('Bueno')),
                  DropdownMenuItem(
                    value: 'acceptable',
                    child: Text('Aceptable'),
                  ),
                  DropdownMenuItem(value: 'poor', child: Text('Desgastado')),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _condition = value;
                  });
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _operationType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Operación',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'sale', child: Text('Venta')),
                  DropdownMenuItem(
                    value: 'exchange',
                    child: Text('Intercambio'),
                  ),
                  DropdownMenuItem(
                    value: 'both',
                    child: Text('Venta / Intercambio'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _operationType = value;
                  });
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<int>(
                value: _categoryId,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1')),
                  DropdownMenuItem(value: 2, child: Text('2')),
                  DropdownMenuItem(value: 3, child: Text('3')),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _categoryId = value;
                  });
                },
              ),
              const SizedBox(height: 22),
              BlocConsumer<AddBookBloc, AddBookState>(
                listener: (context, state) {
                  if (state is AddBookSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Libro subido con éxito!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pop(context, true);
                  }

                  if (state is AddBookError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AddBookLoading;

                  return SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D9CFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.4,
                              ),
                            )
                          : const Text(
                              'Subir Libro',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
