import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/big_card.dart';
import 'package:english_words/english_words.dart';

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final pair = appState.current;

    IconData icon =
        appState.isFavorite(pair) ? Icons.favorite : Icons.favorite_border;

    return LayoutBuilder(
      builder: (context, constraints) {
        // history drawer height calculation
        final totalHeight = constraints.maxHeight;
        final buttonAreaHeight = totalHeight * 0.4;
        final historyAreaHeight = totalHeight - buttonAreaHeight;
        // Column offset calculation
        final verticalOffset = totalHeight * 0.2;

        return Padding(
          padding: EdgeInsets.only(top: verticalOffset),
          child: Column(
            children: [
              HistoryDrawer(
                history: appState.history,
                maxHeight: historyAreaHeight,
              ),
              BigCard(pair: pair),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => appState.toggleFavorite(),
                    icon: Icon(icon),
                    label: const Text('Like'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: appState.getNext,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class HistoryDrawer extends StatelessWidget {
  final List<WordPair> history;
  final double maxHeight;

  const HistoryDrawer(
      {super.key, required this.history, required this.maxHeight});

  @override
  Widget build(BuildContext context) {
    // Max num of cards calculation
    const cardHeight = 100.0;
    final maxItems = (maxHeight / cardHeight).floor();

    // reversed clipped history
    final limitedHistory = history.take(maxItems).toList().reversed.toList();

    return Column(
      children: limitedHistory.map((pair) {
        final appState = context.watch<AppState>();
        final index = limitedHistory.indexOf(pair);
        final opacity =
            (0.4 + (index / limitedHistory.length) * 0.6).clamp(0.4, 1.0);

        return Opacity(
          opacity: opacity,
          child: SmallCard(
            pair: pair,
            isFavorite: appState.isFavorite(pair),
            onFavoriteToggle: () => appState.toggleFavorite(pair),
          ),
        );
      }).toList(),
    );
  }
}

class SmallCard extends StatelessWidget {
  final WordPair pair;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const SmallCard({
    super.key,
    required this.pair,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.inversePrimary,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(pair.asPascalCase),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 20,
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  final WordPair pair;

  const BigCard({super.key, required this.pair});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: RichText(
          text: TextSpan(
            style: style,
            children: [
              TextSpan(text: pair.first), // First word normal
              TextSpan(
                text: pair.second, // Second word bold
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
