import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class AppState extends ChangeNotifier {
  WordPair _current = WordPair.random();
  final List<WordPair> _favorites = [];
  final List<WordPair> _history = [];
  static const int _maxHistoryLength = 10;

  WordPair get current => _current;
  List<WordPair> get favorites => List.unmodifiable(_favorites);
  List<WordPair> get history => List.unmodifiable(_history);

  void getNext() {
    _addToHistory(_current);
    _current = WordPair.random();
    notifyListeners();
  }

  void _addToHistory(WordPair pair) {
    if (!_history.contains(pair)) {
      _history.insert(0, pair);
      if (_history.length > _maxHistoryLength) {
        _history.removeLast();
      }
    }
  }

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? _current;
    if (_favorites.contains(pair)) {
      _favorites.remove(pair);
    } else {
      _favorites.add(pair);
    }
    notifyListeners();
  }

  bool isFavorite(WordPair pair) {
    return _favorites.contains(pair);
  }

  void removeFavorite(WordPair word) {
    _favorites.remove(word);
    notifyListeners();
  }
}
