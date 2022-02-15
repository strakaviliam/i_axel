
class BookModel {

  final String title;
  final String subtitle;
  final String authors;
  final String publisher;
  final String pages;
  final String year;
  final double rating;
  final String desc;
  final String isbn13;
  final String price;
  final String image;
  final String url;
  final Map<String, String> pdf;

  BookModel.fromMap(Map<String, dynamic> map) :
        title = map['title'] as String? ?? '',
        subtitle = map['subtitle'] as String? ?? '',
        authors = map['authors'] as String? ?? '',
        publisher = map['publisher'] as String? ?? '',
        pages = map['pages'] as String? ?? '',
        year = map['year'] as String? ?? '',
        rating = double.tryParse(map['rating'] as String? ?? '0') ?? 0,
        desc = map['desc'] as String? ?? '',
        isbn13 = map['isbn13'] as String? ?? '',
        price = map['price'] as String? ?? '',
        image = map['image'] as String? ?? '',
        pdf = (map['pdf'] as Map<String, dynamic>? ?? <String, dynamic>{}).map((key, dynamic value) => MapEntry(key, value.toString())),
        url = map['url'] as String? ?? '';
}
