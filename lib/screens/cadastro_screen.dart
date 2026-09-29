import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import "../database/database_helper.dart";

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _culinariaController = TextEditingController();

  File? _fotoPrato;

  String _latitude = '';
  String _longitude = '';

  final ImagePicker _picker = ImagePicker();

  Future<void> _tirarFoto() async {
    final XFile? fotoCapturada = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (fotoCapturada != null) {
      setState(() {
        _fotoPrato = File(fotoCapturada.path);
      });
    }
  }

  void _salvarCadastro() async {
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe o nome do restaurante'),
        ),
      );
      return;
    }

    // CORREÇÃO: 'res_ds_tipo_culinaria' com underline
    Map<String, dynamic> dadosRestaurante = {
      'res_nm_restaurante': _nomeController.text.trim(),
      'res_ds_tipo_culinaria': _culinariaController.text.trim(),
      'res_nu_latitude': _latitude,
      'res_nu_longitude': _longitude,
    };

    await DatabaseHelper().inserirDados('restaurante', dadosRestaurante);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restaurante cadastrado com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(5, 84, 66, 1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Novo Cadastro',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LOGO ADICIONADA AQUI
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 100, // Ajuste a altura se precisar
              ),
            ),
            const SizedBox(height: 20),

            // Campo: Nome do Restaurante
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Restaurante',
                prefixIcon: Icon(Icons.store, color: primaryColor),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Campo: Tipo de Culinária
            TextField(
              controller: _culinariaController,
              decoration: const InputDecoration(
                labelText: 'Tipo de Culinária (ex: Italiano, Japonês)',
                prefixIcon: Icon(Icons.restaurant_menu, color: primaryColor),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Foto do Prato:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Preview da Foto
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: _fotoPrato != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(_fotoPrato!, fit: BoxFit.cover),
                    )
                  : const Center(
                      child: Text(
                        'Nenhuma foto selecionada',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
            const SizedBox(height: 10),

            // Botão para Tirar Foto
            Center(
              child: ElevatedButton.icon(
                onPressed: _tirarFoto,
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text(
                  'Tirar foto do prato',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              ),
            ),
            const SizedBox(height: 30),

            // Botão Salvar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _salvarCadastro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Salvar Cadastro',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
