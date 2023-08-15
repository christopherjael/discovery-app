
enum Category { Hotel, Restaurante, Parque, Museo, Descatado } extension CategoryExtension on Category {
  String get displayTitle {
    switch (this) {
      case Category.Hotel:
        return 'This is red';
      case Category.Restaurante:
        return 'This is orange';
      case Category.Parque:
        return 'This is yellow';
      case Category.Museo:
        return 'This is green';
      case Category.Descatado:
        return 'This is blue';
      default:
        return 'Category is null';
    }
  }
}