import 'package:realm/realm.dart';
part 'schema.g.dart';

@RealmModel()
class _Links {
  @PrimaryKey()
  late ObjectId id;

  late String? title;
  late String? address;
  late _User? user;
}


@RealmModel()
class _User {
  late String? id;
  late String? name;
}
