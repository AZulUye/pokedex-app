import 'package:flutter/material.dart';
import '../models/pokemon_detail.dart';
import '../services/pokeapi_service.dart';

class PokemonDetailScreen extends StatefulWidget {
  final int pokemonId;

  const PokemonDetailScreen({Key? key, required this.pokemonId}) : super(key: key);

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late Future<PokemonDetail> _pokemonDetailFuture;
  final PokeApiService _apiService = PokeApiService();

  @override
  void initState() {
    super.initState();
    _pokemonDetailFuture = _apiService.fetchPokemonDetails(widget.pokemonId);
  }

  // Helper to format stat names
  String _formatStatName(String name) {
    switch (name) {
      case 'hp': return 'HP';
      case 'attack': return 'Attack';
      case 'defense': return 'Defense';
      case 'special-attack': return 'Sp. Atk';
      case 'special-defense': return 'Sp. Def';
      case 'speed': return 'Speed';
      default: return name.replaceAll('-', ' ').toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        // Title will be set dynamically after data loads
      ),
      body: FutureBuilder<PokemonDetail>(
        future: _pokemonDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading details: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final pokemon = snapshot.data!;
            // Set AppBar title dynamically
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                 Scaffold.of(context).appBarMaxHeight; // Force AppBar rebuild if needed
                 // This is a bit of a workaround, ideally use a different state management
                 // or pass the name from the list screen.
                 // For now, we update the title here.
                 (context as Element).markNeedsBuild(); 
              }
            });

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Update AppBar title in build method
                  AppBar( 
                    title: Text(pokemon.name[0].toUpperCase() + pokemon.name.substring(1)),
                    backgroundColor: Colors.transparent, // Make it transparent as it's part of body scroll
                    elevation: 0,
                    automaticallyImplyLeading: false, // Hide back button here
                    centerTitle: true,
                  ),
                  const SizedBox(height: 10),
                  Image.network(
                    pokemon.imageUrl,
                    height: 200,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator()),
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 100),
                  ),
                  const SizedBox(height: 20),
                  Text('ID: #${pokemon.id}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    alignment: WrapAlignment.center,
                    children: pokemon.types.map((type) => Chip(label: Text(type), backgroundColor: Colors.orangeAccent)).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Height: ${pokemon.height / 10} m'), // Convert dm to m
                      Text('Weight: ${pokemon.weight / 10} kg'), // Convert hg to kg
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Abilities:', style: Theme.of(context).textTheme.titleMedium),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    alignment: WrapAlignment.center,
                    children: pokemon.abilities.map((ability) => Chip(label: Text(ability))).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text('Base Stats:', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  ...pokemon.stats.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatStatName(entry.key)),
                          Row(
                            children: [
                              Text(entry.value.toString()),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5, // Adjust width as needed
                                child: LinearProgressIndicator(
                                  value: entry.value / 255.0, // Assuming max stat is 255 for scaling
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(entry.value > 50 ? Colors.green : Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Pokemon details not found.'));
          }
        },
      ),
    );
  }
}

