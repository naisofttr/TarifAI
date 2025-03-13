class Ingredient {
  final String name;
  final String category;

  const Ingredient({
    required this.name,
    required this.category,
  });
}

class IngredientList {
  static const List<Ingredient> commonIngredients = [
    // Sebzeler
    Ingredient(name: "Domates", category: "Sebze"),
    Ingredient(name: "Salatalık", category: "Sebze"),
    Ingredient(name: "Patlıcan", category: "Sebze"),
    Ingredient(name: "Biber", category: "Sebze"),
    Ingredient(name: "Soğan", category: "Sebze"),
    Ingredient(name: "Sarımsak", category: "Sebze"),
    Ingredient(name: "Havuç", category: "Sebze"),
    Ingredient(name: "Patates", category: "Sebze"),
    
    // Et Ürünleri
    Ingredient(name: "Kıyma", category: "Et"),
    Ingredient(name: "Tavuk Göğsü", category: "Et"),
    Ingredient(name: "Kuşbaşı Et", category: "Et"),
    
    // Süt Ürünleri
    Ingredient(name: "Süt", category: "Süt Ürünü"),
    Ingredient(name: "Yoğurt", category: "Süt Ürünü"),
    Ingredient(name: "Peynir", category: "Süt Ürünü"),
    Ingredient(name: "Kaşar Peyniri", category: "Süt Ürünü"),
    
    // Bakliyat
    Ingredient(name: "Pirinç", category: "Bakliyat"),
    Ingredient(name: "Bulgur", category: "Bakliyat"),
    Ingredient(name: "Mercimek", category: "Bakliyat"),
    Ingredient(name: "Nohut", category: "Bakliyat"),
    
    // Baharatlar
    Ingredient(name: "Tuz", category: "Baharat"),
    Ingredient(name: "Karabiber", category: "Baharat"),
    Ingredient(name: "Pul Biber", category: "Baharat"),
    Ingredient(name: "Kekik", category: "Baharat"),
    
    // Yağlar
    Ingredient(name: "Zeytinyağı", category: "Yağ"),
    Ingredient(name: "Ayçiçek Yağı", category: "Yağ"),
    Ingredient(name: "Tereyağı", category: "Yağ"),
  ];
} 