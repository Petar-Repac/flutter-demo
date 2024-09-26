import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class SmallCard extends StatelessWidget {
  const SmallCard({
    super.key,
    required this.word,
  });

  final WordPair word;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    final appState = context.watch<AppState>();

    return Card(
      color: theme.colorScheme.primary,
      child: Stack(
        children: [
          Center(
            child: Text(
              word.asLowerCase,
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: theme.colorScheme.onPrimary,
              onPressed: () => appState.removeFavorite(word),
            ),
          ),
        ],
      ),
    );
  }
}
