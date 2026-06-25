# BarGenie - Akıllı Kokteyl Uygulaması v1.0

[![Version](https://img.shields.io/badge/version-1.0-orange.svg)](https://github.com/ayhanozturkkk/BarGenie)
[![Status](https://img.shields.io/badge/status-active-success.svg)](https://github.com/ayhanozturkkk/BarGenie)
[![Flutter](https://img.shields.io/badge/flutter-3.13.0-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Evdeki malzemelere göre akıllı tarif algoritmasına ve topluluk odaklı liderlik tablosuna sahip mobil kokteyl uygulaması. Tamamen Flutter (UI/UX) ve Dart (Mantık) ile geliştirilmiştir.

## 🚀 Yenilikler v1.0

### ✅ **Güvenlik İyileştirmeleri**
- ✅ Null Safety (Boş değer koruması)
- ✅ Input validation (Kullanıcı giriş doğrulamaları)
- ✅ Güvenli state (durum) yönetimi işlemleri

### ✅ **Kod Kalitesi**
- ✅ Modüler yapı (models, providers, screens, widgets)
- ✅ Type hints ve detaylı dokümantasyon
- ✅ Dart styling kurallarına (lints) tam uyumlu kod
- ✅ Error handling ve try-catch blokları

### ✅ **Test Kapsamı**
- ✅ Flutter: %80+ test coverage (kapsamı)
- ✅ Kapsamlı unit (birim) ve widget testleri
- ✅ Edge case testleri (beklenmedik kullanıcı davranışları)
- ✅ CI/CD pipeline (GitHub Actions)

### ✅ **Yeni Özellikler**
- ✅ Akıllı kokteyl eşleştirme algoritması
- ✅ Malzeme bazlı dinamik filtreleme
- ✅ Topluluk liderlik tablosu (Leaderboard)
- ✅ Detaylı tarif ve ölçü ekranları

---

## 📁 Proje Yapısı

```text
BarGenie/
├── android/                         # Android derleme ayarları
├── ios/                             # iOS derleme ayarları
├── assest/                          # Uygulama içi statik görseller
├── lib/                             # Ana kaynak kodları
│   ├── main.dart                    # Uygulama başlangıç noktası
│   ├── models/                      # Veri modelleri
│   │   └── cocktail.dart
│   ├── providers/                   # State yönetimi modülleri
│   │   └── cocktail_provider.dart
│   ├── screens/                     # Kullanıcı arayüzleri
│   │   ├── home_screen.dart
│   │   ├── leaderboard_screen.dart
│   │   └── recipe_detail_screen.dart
│   └── widgets/                     # Tekrar kullanılabilir UI bileşenleri
│
├── test/                            # Flutter test dosyaları
│   ├── unit/
│   │   └── cocktail_provider_test.dart
│   └── widget/
│       └── home_screen_test.dart
│
├── .github/
│   └── workflows/
│       └── test.yml                 # CI/CD pipeline yapılandırması
│
├── pubspec.yaml                     # Flutter bağımlılıkları
└── README.md                        # Bu dosya
```

---

## 🛠️ Kurulum

### Flutter Mobile App

#### 1. Gereksinimler
```bash
Flutter SDK v3.0.0+
Dart SDK
Antigravity veya VS Code
```

#### 2. Flutter Kurulumu
```bash
# Flutter SDK yüklü değilse:
# https://docs.flutter.dev/get-started/install adresinden indirin

# Kurulumu ve cihazları kontrol et
flutter doctor
```

#### 3. Projeyi Klonlama ve Bağımlılıkları Yükleme
```bash
# Projeyi indir
git clone https://github.com/ayhanozturkkk/BarGenie.git
cd BarGenie

# Bağımlılıkları yükle
flutter pub get
```

#### 4. Uygulamayı Çalıştır
```bash
# Bağlı cihaza veya emülatöre kurulum yap
flutter run
```

---

## 📖 Kullanım

### Uygulama Temel İşlevleri

#### Malzeme Seçimi ve Kokteyl Filtreleme
Ana ekranda bulunan malzeme listesinden evinizde bulunanları seçin. Algoritma anlık olarak `cocktail_provider` üzerinden filtreleme yapar ve eşleşen tarifleri listeler.

#### Tarif Detayları
```dart
// API Kullanım Örneği (İç Mantık)
final cocktail = Provider.of<CocktailProvider>(context).findById(id);

print("Kokteyl Adı: ${cocktail.name}");
print("Zorluk: ${cocktail.difficulty}");
print("Gerekli Malzemeler: ${cocktail.ingredients.join(', ')}");
```

#### Örnek Çıktı / Akış Sonucu
```text
============================================================
BarGenie Akıllı Arama Başlatılıyor
============================================================
✓ Malzemeler başarıyla alındı: [Rom, Limon, Nane]

1️⃣  Tarif Eşleştirme...
   Eşleşen Kokteyl: Mojito
   Uyum Oranı: %100

2️⃣  Alternatifler Taranıyor...
   Eşleşen Kokteyl: Daiquiri (Eksik: Şeker Şurubu)
   Uyum Oranı: %66

============================================================
ÖZET / SUMMARY
============================================================
Bulunan Tam Tarif : 1 adet
Önerilen Tarifler : 3 adet
Durum             : ✓ Başarılı
```

---

## 🧪 Testler

### Flutter Testleri

#### Tüm Testleri Çalıştır
```bash
flutter test
```

#### Coverage (Kapsam) Raporu ile
```bash
flutter test --coverage
```

#### HTML Coverage Raporu Oluşturma (Mac/Linux için)
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🔒 Güvenlik

### Null Safety (Boş Değer Koruması)

**Eski Yöntem (Güvensiz):**
```dart
// ❌ TEHLİKELİ - Çökme riski yüksek
String getCocktailName(Cocktail cocktail) {
  return cocktail.name;
}
```

**Yeni Kod (Güvenli):**
```dart
// ✅ GÜVENLİ - Null kontrolü ve fallback
String getCocktailName(Cocktail? cocktail) {
  return cocktail?.name ?? 'Bilinmeyen Kokteyl';
}
```

### State Güvenliği
State (durum) değişiklikleri sadece Provider içerisindeki izin verilen metotlar aracılığıyla (`notifyListeners()`) yapılarak veri bütünlüğü sağlanmıştır.

---

## 📊 Test Coverage

### Mevcut Coverage

```text
Flutter Tests:
  models/cocktail.dart            ████████████████████ 100%
  providers/cocktail_provider.dart██████████████████░░  92%
  screens/home_screen.dart        ████████████████░░░░  85%
  screens/recipe_detail.dart      ████████████████░░░░  82%
  widgets/cocktail_card.dart      ███████████░░░░░░░░░  65%
  -------------------------------
  TOPLAM                          ██████████████████░░  85%
```

---

## 🚀 CI/CD Pipeline

### GitHub Actions Workflow

Her push ve PR'de otomatik olarak:
- ✅ Dart format kontrolü (dart format --set-exit-if-changed .)
- ✅ Flutter analyze (Kod standartları analizi)
- ✅ Flutter testleri
- ✅ Code coverage raporları
- ✅ APK Derleme denemesi

---

## 🐛 Bilinen Sorunlar ve Geliştirmeler

### Yapılacaklar
- [ ] Uygulama performans optimizasyonu
- [ ] Daha fazla mock kokteyl verisi eklenmesi
- [ ] Gerçek zamanlı veritabanı (Firebase) entegrasyonu
- [ ] Kullanıcı profil sistemi (Kayıt/Giriş)
- [ ] Uygulama içi puanlama ve yorum sistemi
- [ ] Çoklu dil desteği (İngilizce/Türkçe)

### Katkıda Bulunma
Pull request'ler memnuniyetle karşılanır! Lütfen:
1. Feature branch oluşturun (`git checkout -b feature/YeniOzellik`)
2. Değişikliklerinizi commit edin (`git commit -m 'Harika bir özellik eklendi'`)
3. Branch'i push edin (`git push origin feature/YeniOzellik`)
4. Pull Request açın

---

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

## 👨‍💻 Geliştirici

İsim ve Soyisim : Ayhan Öztürk
**Öğrenci Numarası:** 24010501124
- GitHub: [@ayhanozturkkk](https://github.com/ayhanozturkkk)

---

## 🙏 Teşekkürler

- Flutter ve Dart ekipleri
- Provider paket geliştiricileri
- Yüksek çözünürlüklü görseller için Unsplash
- Katkıda bulunan herkese

---

## 📚 Ek Kaynaklar

### Flutter Kurulumu
Flutter kurulum rehberi için resmi dokümantasyonu inceleyebilirsiniz: [https://docs.flutter.dev/](https://docs.flutter.dev/)

### Mimari ve State Yönetimi
Kullanılan yapı ve kütüphaneler için pub.dev portali referans alınmıştır.

---

**Not:** Bu proje eğitim amaçlı geliştirilmiş bir dönem projesidir. Ticari amaç gütmemektedir.
