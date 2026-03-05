import 'package:booksy_app/core/models/book/book_category.dart';
import 'package:booksy_app/core/services/book_service.dart';
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
  final TextEditingController _priceController = TextEditingController();
  final BookService _bookService = BookService();

  String _condition = 'good';
  String _operationType = 'exchange';
  int? _categoryId;
  late Future<List<BookCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _bookService.getCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _reloadCategories() {
    setState(() {
      _categoriesFuture = _bookService.getCategories();
    });
  }

  double? _parsePrice(String raw) {
    final normalized = raw.trim().replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final categoryId = _categoryId;
    if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona una categoria valida'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final double? parsedPrice = _operationType == 'sale'
        ? _parsePrice(_priceController.text)
        : null;

    final data = <String, dynamic>{
      'title': _titleController.text.trim(),
      'author': _authorController.text.trim(),
      'physical_condition': _condition,
      'operation_type': _operationType,
      'category_id': categoryId,
      'price': _operationType == 'sale' ? parsedPrice : null,
      if (_descriptionController.text.trim().isNotEmpty)
        'description': _descriptionController.text.trim(),
    };

    context.read<AddBookBloc>().add(SubmitBook(data));
  }

  void _safeBackToHome({Object? result}) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
      return;
    }

    Navigator.pushReplacementNamed(context, '/home-user');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _safeBackToHome();
      },
      child: Scaffold(
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
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _operationType = value;
                      if (_operationType == 'exchange') {
                        _priceController.clear();
                      }
                    });
                  },
                ),
                if (_operationType == 'sale') ...[
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      hintText: 'Ej: 12.50',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (_operationType != 'sale') {
                        return null;
                      }

                      final parsed = _parsePrice(value ?? '');
                      if (parsed == null) {
                        return 'El precio es obligatorio';
                      }

                      if (parsed <= 0) {
                        return 'El precio debe ser mayor a 0';
                      }

                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 14),
                FutureBuilder<List<BookCategory>>(
                  future: _categoriesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'No se pudieron cargar las categorias',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _reloadCategories,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reintentar categorias'),
                          ),
                        ],
                      );
                    }

                    final categories = snapshot.data ?? const <BookCategory>[];
                    if (categories.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'No hay categorias disponibles',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _reloadCategories,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reintentar categorias'),
                          ),
                        ],
                      );
                    }

                    final selectedCategoryId =
                        categories.any((category) => category.id == _categoryId)
                        ? _categoryId
                        : categories.first.id;

                    if (_categoryId != selectedCategoryId) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) {
                          return;
                        }
                        setState(() {
                          _categoryId = selectedCategoryId;
                        });
                      });
                    }

                    return DropdownButtonFormField<int>(
                      value: selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                      ),
                      items: categories
                          .map(
                            (category) => DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(category.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _categoryId = value;
                        });
                      },
                    );
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
                      _safeBackToHome(result: true);
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
      ),
    );
  }
}
