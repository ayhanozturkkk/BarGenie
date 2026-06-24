import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityProvider = StateNotifierProvider<ActivityNotifier, List<ActivityEntry>>((ref) {
  return ActivityNotifier();
});

class ActivityEntry {
  final String name;
  final String date;
  final String? badge;

  ActivityEntry({required this.name, required this.date, this.badge});
}

class ActivityNotifier extends StateNotifier<List<ActivityEntry>> {
  ActivityNotifier() : super([
    ActivityEntry(name: 'Smoky Negroni', date: 'Bugün', badge: '5 Yıldız'),
    ActivityEntry(name: 'Custom Gin Smash', date: 'Dün'),
    ActivityEntry(name: 'Espresso Martini', date: '2 Gün Önce', badge: 'Yeni Keşif'),
  ]);

  void logCocktail(String name, String badge) {
    state = [
      ActivityEntry(name: name, date: 'Şimdi', badge: badge),
      ...state,
    ].take(3).toList();
  }
}
