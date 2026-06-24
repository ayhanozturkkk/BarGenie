import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cocktail.dart';
import 'xp_provider.dart';

/// 12 underground / rare homemade secret recipes
final secretRecipeProvider = Provider<List<SecretRecipe>>((ref) {
  return _secretRecipes;
});

/// Provider that checks which recipes are unlocked based on user level
final unlockedRecipesProvider = Provider<List<bool>>((ref) {
  final xp = ref.watch(xpProvider);
  return _secretRecipes.map((r) => xp.level >= r.requiredLevel).toList();
});

class SecretRecipe {
  final String id;
  final int requiredLevel;
  final Cocktail cocktail;

  const SecretRecipe({
    required this.id,
    required this.requiredLevel,
    required this.cocktail,
  });
}

final _secretRecipes = <SecretRecipe>[
  SecretRecipe(
    id: 's1',
    requiredLevel: 2,
    cocktail: Cocktail(
      id: 's1', name: 'Şalgam Sunrise', category: 'Gizli',
      description: 'Türk şalgam suyunun tekila ile beklenmedik uyumu.',
      imagePath: 'https://images.unsplash.com/photo-1536935338788-8422ea7162df?w=500',
      rating: 4.7, fpRatio: 9.0, prepTimeMin: 4, intensity: 'Orta',
      preparation: 'Uzun bardağa buz koyun. Tekila ve portakal suyunu ekleyin. Üzerine yavaşça şalgam suyunu gezdirin. Karıştırmadan servis edin.',
      ingredients: [
        CocktailIngredient(name: 'Tekila', amount: '45 ml'),
        CocktailIngredient(name: 'Portakal Suyu', amount: '90 ml'),
        CocktailIngredient(name: 'Şalgam Suyu', amount: '30 ml'),
        CocktailIngredient(name: 'Nar Ekşisi', amount: '10 ml'),
      ],
    ),
  ),
  SecretRecipe(
    id: 's2',
    requiredLevel: 3,
    cocktail: Cocktail(
      id: 's2', name: 'Smoky İstanbul', category: 'Gizli',
      description: 'İsli viski ve Türk kahvesinin gizemli buluşması.',
      imagePath: 'https://images.unsplash.com/photo-1597075687490-8f673c6c17f6?w=500',
      rating: 4.9, fpRatio: 9.5, prepTimeMin: 6, intensity: 'Güçlü',
      preparation: 'Soğutulmuş Türk kahvesini shaker\'a alın. İsli viski, bal şurubu ve bir tutam tarçın ekleyin. Buzla çalkalayın, süzün.',
      ingredients: [
        CocktailIngredient(name: 'İsli Viski', amount: '50 ml'),
        CocktailIngredient(name: 'Türk Kahvesi (soğuk)', amount: '30 ml'),
        CocktailIngredient(name: 'Bal Şurubu', amount: '15 ml'),
        CocktailIngredient(name: 'Tarçın', amount: '1 tutam'),
      ],
    ),
  ),
  SecretRecipe(
    id: 's3',
    requiredLevel: 3,
    cocktail: Cocktail(
      id: 's3', name: 'Nar Negroni', category: 'Gizli',
      description: 'Klasik Negroni\'nin nar ekşili Anadolu versiyonu.',
      imagePath: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=500',
      rating: 4.8, fpRatio: 9.3, prepTimeMin: 4, intensity: 'Güçlü',
      preparation: 'Karıştırma bardağına buz doldurun. Tüm malzemeleri ekleyip 30 saniye karıştırın. Rocks bardağına süzün, nar taneleri ile süsleyin.',
      ingredients: [
        CocktailIngredient(name: 'Gin', amount: '30 ml'),
        CocktailIngredient(name: 'Campari', amount: '25 ml'),
        CocktailIngredient(name: 'Tatlı Vermut', amount: '25 ml'),
        CocktailIngredient(name: 'Nar Ekşisi', amount: '10 ml'),
      ],
    ),
  ),
  SecretRecipe(
    id: 's4',
    requiredLevel: 4,
    cocktail: Cocktail(
      id: 's4', name: 'Damla Sakızlı Rüya', category: 'Gizli',
      description: 'Damla sakızı ve vodkanın parfüm gibi kokteyli.',
      imagePath: 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500',
      rating: 4.6, fpRatio: 8.8, prepTimeMin: 5, intensity: 'Hafif',
      preparation: 'Damla sakızını havanda ezin. Vodka ve limon suyu ile shaker\'da çalkalayın. İnce süzgeçle martini kadehine süzün. Gül suyu spritz yapın.',
      ingredients: [
        CocktailIngredient(name: 'Premium Vodka', amount: '50 ml'),
        CocktailIngredient(name: 'Damla Sakızı', amount: '2 adet'),
        CocktailIngredient(name: 'Limon Suyu', amount: '20 ml'),
        CocktailIngredient(name: 'Şeker Şurubu', amount: '15 ml'),
        CocktailIngredient(name: 'Gül Suyu', amount: '2 dash'),
      ],
    ),
  ),
  SecretRecipe(
    id: 's5',
    requiredLevel: 5,
    cocktail: Cocktail(
      id: 's5', name: 'Midnight Pekmez', category: 'Gizli',
      description: 'Bourbon ve üzüm pekmezinin karanlık senfonisi.',
      imagePath: 'https://images.unsplash.com/photo-1574853018258-009c916ff0a6?w=500',
      rating: 4.8, fpRatio: 9.1, prepTimeMin: 5, intensity: 'Güçlü',
      preparation: 'Pekmezi sıcak suyla inceltip soğutun. Bourbon ve limon suyuyla buzlu shaker\'da çalkalayın. Rocks bardağına süzün.',
      ingredients: [
        CocktailIngredient(name: 'Bourbon', amount: '50 ml'),
        CocktailIngredient(name: 'Pekmez (Üzüm)', amount: '20 ml'),
        CocktailIngredient(name: 'Limon Suyu', amount: '15 ml'),
        CocktailIngredient(name: 'Angostura Bitters', amount: '2 dash'),
      ],
    ),
  ),
  SecretRecipe(
    id: 's6',
    requiredLevel: 6,
    cocktail: Cocktail(
      id: 's6', name: 'Sultan\'s Elixir', category: 'Gizli',
      description: 'Safran, bal ve rakının saray ilhamı.',
      imagePath: 'https://images.unsplash.com/photo-1606118431872-91f18e9d57a9?w=500',
      rating: 4.9, fpRatio: 9.6, prepTimeMin: 8, intensity: 'Güçlü',
      preparation: 'Safranı ılık bala batırıp 5 dk bekletin. Rakı ve limon suyuyla karıştırın. Buzla süzüp servis edin.',
      ingredients: [
        CocktailIngredient(name: 'Rakı', amount: '45 ml'),
        CocktailIngredient(name: 'Bal', amount: '20 ml'),
        CocktailIngredient(name: 'Saffron', amount: '3 tel'),
        CocktailIngredient(name: 'Limon Suyu', amount: '15 ml'),
      ],
    ),
  ),
  SecretRecipe(
    id: 's7',
    requiredLevel: 7,
    cocktail: Cocktail(
      id: 's7', name: 'Boza Colada', category: 'Gizli',
      description: 'Bozanın tropik yorumuyla modern fusion.',
      imagePath: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=500',
      rating: 4.5, fpRatio: 8.7, prepTimeMin: 5, intensity: 'Hafif',
      preparation: 'Boza, rom, hindistan cevizi kreması ve buzu blender\'da karıştırın. Tarçın serpin.',
      ingredients: [
        CocktailIngredient(name: 'Beyaz Rom', amount: '40 ml'),
        CocktailIngredient(name: 'Boza', amount: '80 ml'),
        CocktailIngredient(name: 'Hindistan Cevizi Kreması', amount: '30 ml'),
        CocktailIngredient(name: 'Tarçın', amount: '1 tutam'),
      ],
    ),
  ),
  SecretRecipe(
    id: 's8',
    requiredLevel: 8,
    cocktail: Cocktail(
      id: 's8', name: 'Lokum Old Fashioned', category: 'Gizli',
      description: 'Gül lokumu infüze edilmiş bourbon klasiği.',
      imagePath: 'https://images.unsplash.com/photo-1629851603572-c0cb4bc50db1?w=500',
      rating: 4.9, fpRatio: 9.4, prepTimeMin: 10, intensity: 'Güçlü',
      preparation: 'Bir gün önceden bourbon\'a gül lokumu atıp bekletin. Lokumlu bourbon, şeker şurubu ve bitter ile karıştırın.',
      ingredients: [
        CocktailIngredient(name: 'Bourbon', amount: '60 ml'),
        CocktailIngredient(name: 'Lokum (Güllü)', amount: '2 adet'),
        CocktailIngredient(name: 'Şeker Şurubu', amount: '10 ml'),
        CocktailIngredient(name: 'Angostura Bitters', amount: '2 dash'),
      ],
    ),
  ),
  SecretRecipe(
    id: 's9',
    requiredLevel: 9,
    cocktail: Cocktail(
      id: 's9', name: 'Kapadokya Mist', category: 'Gizli',
      description: 'Mezcal ve kayısının büyülü Kapadokya sisinde buluşması.',
      imagePath: 'https://images.unsplash.com/photo-1595981267035-7b0419ec62c2?w=500',
      rating: 4.7, fpRatio: 9.2, prepTimeMin: 5, intensity: 'Orta',
      preparation: 'Kayısı nektarı, mezcal ve limon suyunu shaker\'da çalkalayın. Bardağı dumanlayıp (smoke) içine süzün.',
      ingredients: [
        CocktailIngredient(name: 'Mezcal', amount: '45 ml'),
        CocktailIngredient(name: 'Kayısı Nektarı', amount: '40 ml'),
        CocktailIngredient(name: 'Limon Suyu', amount: '15 ml'),
        CocktailIngredient(name: 'Agave Şurubu', amount: '10 ml'),
      ],
    ),
  ),
  SecretRecipe(
    id: 's10',
    requiredLevel: 10,
    cocktail: Cocktail(
      id: 's10', name: 'Ayran Martini', category: 'Gizli',
      description: 'Ayranın vodka ile en cesur yorumu. Tuzlu, kremamsı, farklı.',
      imagePath: 'https://images.unsplash.com/photo-1662998847849-0fa4b1b8aa40?w=500',
      rating: 4.6, fpRatio: 8.9, prepTimeMin: 3, intensity: 'Orta',
      preparation: 'Premium vodka ve soğuk ayranı buzlu shaker\'da çalkalayın. Martini kadehine süzün. Nane ve sumak ile süsleyin.',
      ingredients: [
        CocktailIngredient(name: 'Premium Vodka', amount: '50 ml'),
        CocktailIngredient(name: 'Ayran', amount: '60 ml'),
        CocktailIngredient(name: 'Tuz', amount: '1 tutam'),
        CocktailIngredient(name: 'Nane', amount: '2 yaprak'),
      ],
    ),
  ),
  SecretRecipe(
    id: 's11',
    requiredLevel: 11,
    cocktail: Cocktail(
      id: 's11', name: 'Salep Bourbon Sour', category: 'Gizli',
      description: 'Kış gecelerinin salepli bourbon şaheseri.',
      imagePath: 'https://images.unsplash.com/photo-1629168621183-b77da12b988f?w=500',
      rating: 4.8, fpRatio: 9.3, prepTimeMin: 7, intensity: 'Güçlü',
      preparation: 'Sıcak salebi soğutun. Bourbon, limon suyu ve yumurta akı ile dry shake yapın. Buz ekleyip tekrar çalkalayıp süzün.',
      ingredients: [
        CocktailIngredient(name: 'Bourbon', amount: '50 ml'),
        CocktailIngredient(name: 'Salep', amount: '40 ml'),
        CocktailIngredient(name: 'Limon Suyu', amount: '20 ml'),
        CocktailIngredient(name: 'Yumurtanın Akı', amount: '1 adet'),
      ],
    ),
  ),
  SecretRecipe(
    id: 's12',
    requiredLevel: 12,
    cocktail: Cocktail(
      id: 's12', name: 'Altın Simyacı', category: 'Gizli',
      description: 'Tüm seviyeleri geçen simyacının ödül kokteyli. Safran, altın ve duman.',
      imagePath: 'https://images.unsplash.com/photo-1560512823-829485b8bf24?w=500',
      rating: 5.0, fpRatio: 10.0, prepTimeMin: 12, intensity: 'Güçlü',
      preparation: 'Safranı ılık konyağa 5 dk infüze edin. Bal şurubu, portakal suyu ve bitters ekleyin. Bardağı meşe talaşıyla dumanlayın. İçine süzüp altın varak ile süsleyin.',
      ingredients: [
        CocktailIngredient(name: 'Konyak', amount: '50 ml'),
        CocktailIngredient(name: 'Saffron', amount: '5 tel'),
        CocktailIngredient(name: 'Bal Şurubu', amount: '15 ml'),
        CocktailIngredient(name: 'Portakal Suyu', amount: '20 ml'),
        CocktailIngredient(name: 'Angostura Bitters', amount: '2 dash'),
      ],
    ),
  ),
];
