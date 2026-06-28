// Create a service to manage liked state
import 'package:flutter/material.dart';

class LikedWallpapersNotifier extends ValueNotifier<Set<int>> {
  LikedWallpapersNotifier() : super({});

  void addLiked(int id) {
    value = {...value, id};
    notifyListeners();
  }

  void removeLiked(int id) {
    value = {...value}..remove(id);
    notifyListeners();
  }

  bool isLiked(int id) => value.contains(id);
}