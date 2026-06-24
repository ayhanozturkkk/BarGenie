import 'package:flutter_riverpod/flutter_riverpod.dart';

final xpProvider = StateNotifierProvider<XpNotifier, XpState>((ref) {
  return XpNotifier();
});

class XpState {
  final int currentXP;
  final int totalXPEarned;
  final int cocktailsMade;

  const XpState({
    this.currentXP = 0,
    this.totalXPEarned = 0,
    this.cocktailsMade = 0,
  });

  int get level {
    // Fast progression: Level = 1 + floor(totalXP / 100)
    // Level 1: 0-99 XP, Level 2: 100-199 XP, etc.
    return 1 + (totalXPEarned ~/ 100);
  }

  int get xpInCurrentLevel => totalXPEarned % 100;

  int get xpForNextLevel => 100;

  double get progressPercent => xpInCurrentLevel / xpForNextLevel;

  String get title {
    if (level >= 12) return 'USTA SİMYACI';
    if (level >= 9) return 'SİMYA USTASI';
    if (level >= 6) return 'KOKTEYL SANATÇISI';
    if (level >= 3) return 'ÇİRAK MİKSOLOG';
    return 'ACEMI BARMEN';
  }

  XpState copyWith({
    int? currentXP,
    int? totalXPEarned,
    int? cocktailsMade,
  }) {
    return XpState(
      currentXP: currentXP ?? this.currentXP,
      totalXPEarned: totalXPEarned ?? this.totalXPEarned,
      cocktailsMade: cocktailsMade ?? this.cocktailsMade,
    );
  }
}

class XpNotifier extends StateNotifier<XpState> {
  XpNotifier() : super(const XpState(totalXPEarned: 150, cocktailsMade: 3));

  void addXP(int amount) {
    state = state.copyWith(
      totalXPEarned: state.totalXPEarned + amount,
    );
  }

  void recordCocktailMade() {
    state = state.copyWith(
      cocktailsMade: state.cocktailsMade + 1,
      totalXPEarned: state.totalXPEarned + 50,
    );
  }

  void recordCocktailCreated() {
    state = state.copyWith(
      totalXPEarned: state.totalXPEarned + 30,
    );
  }
}
