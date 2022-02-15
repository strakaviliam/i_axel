
class BookModel {

  final String title;
  final String subtitle;
  final String isbn13;
  final String price;
  final String image;
  final String url;

  BookModel.fromMap(Map<String, dynamic> map) :
        title = map['title'] as String? ?? '',
        subtitle = map['subtitle'] as String? ?? '',
        isbn13 = map['isbn13'] as String? ?? '',
        price = map['price'] as String? ?? '',
        image = map['image'] as String? ?? '',
        url = map['url'] as String? ?? '';
}
