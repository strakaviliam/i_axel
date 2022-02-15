import 'package:uuid/uuid.dart';

class Tools {

  Tools();

  static String randomString() {
    return const Uuid().v4();
  }
}
