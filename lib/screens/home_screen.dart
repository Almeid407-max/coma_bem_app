import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'cadastro_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _todosRestaurantes = [];
  List<Map<String, dynamic>> _restaurantesFiltrados = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarRestaurantes();
  }

  void _carregarRestaurantes() async {
    var dados = await DatabaseHelper().consultarDados('restaurante');

    setState(() {
      _todosRestaurantes = dados;
      _restaurantesFiltrados = dados;
    });
  }

  void _filtrarRestaurantes(String texto) {
    setState(() {
      if (texto.isEmpty) {
        _restaurantesFiltrados = _todosRestaurantes;
      } else {
        _restaurantesFiltrados = _todosRestaurantes.where((restaurante) {
          final nome = (restaurante['res_nm_restaurante'] ?? '')
              .toString()
              .toLowerCase();
          final culinaria = (restaurante['res_ds_tipo_culinaria'] ?? '')
              .toString()
              .toLowerCase();
          final busca = texto.toLowerCase();

          return nome.contains(busca) || culinaria.contains(busca);
        }).toList();
      }
    });
  }

  // Função auxiliar para as imagens dos restaurantes
  String _obterCaminhoFoto(String culinaria) {
    final tipo = culinaria.toLowerCase();
    if (tipo.contains('japones') || tipo.contains('japonês')) {
      return 'screens/imagem/restaurante_japones.jpg';
    }
    return 'screens/imagem/restaurante_italiano.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(5, 84, 66, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. LOGO CENTRALIZADA (ATUALIZADA)
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 90,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.restaurant, size: 70, color: Colors.white),
            ),
          ),
          const SizedBox(height: 15),

          // 2. CAMPO DE BUSCA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filtrarRestaurantes,
              decoration: InputDecoration(
                hintText: 'RESTAURANTES ITALIANOS, JAPONÊS...',
                hintStyle: TextStyle(fontSize: 11, color: Colors.grey[600]),
                suffixIcon: const Icon(Icons.search, color: Colors.black),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // 3. TÍTULO EM DESTAQUE
          const Text(
            'OS MELHORES RESTAURANTES!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),

          // 4. LISTA DE CARDS IGUAL AO FIGMA
          Expanded(
            child: _restaurantesFiltrados.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum restaurante encontrado.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _restaurantesFiltrados.length,
                    itemBuilder: (context, index) {
                      final item = _restaurantesFiltrados[index];
                      final culinaria = item['res_ds_tipo_culinaria'] ?? '';
                      final nome = item['res_nm_restaurante'] ?? '';

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(168, 93, 9, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // BANNER DA IMAGEM
                              Stack(
                                children: [
                                  Image.asset(
                                    _obterCaminhoFoto(culinaria),
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              height: 160,
                                              color: Colors.grey[400],
                                              child: const Icon(
                                                Icons.restaurant,
                                                size: 50,
                                                color: Colors.white,
                                              ),
                                            ),
                                  ),
                                  const Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),

                              // INFORMAÇÕES DO CARD
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    // LADO ESQUERDO: NOME E LOCALIZAÇÃO
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'RESTAURANTE ${culinaria.toUpperCase()}:',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            nome,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'LOCALIZAÇÃO:',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'São Paulo',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // DIVISOR
                                    Container(
                                      height: 50,
                                      width: 1,
                                      color: Colors.black26,
                                    ),
                                    const SizedBox(width: 10),

                                    // LADO DIREITO: AVALIAÇÃO COM ESTRELAS
                                    const Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'AVALIAÇÃO:',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              Icon(
                                                Icons.star_half,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroScreen()),
          );
          _carregarRestaurantes();
        },
        backgroundColor: Colors.orange[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
