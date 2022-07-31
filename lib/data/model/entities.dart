// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class FinModel {
  int id;
  double price;
  String comments;
  DateTime createdTime;
  DateTime updatedTime;
  final tag = ToOne<TagModel>();

  FinModel({
    this.id = 0,
    required this.price,
    required this.comments,
    required this.createdTime,
    required this.updatedTime,
  });
}

@Entity()
@Sync()
class TagModel {
  int id;
  String tag;
  @Backlink()
  final orders = ToMany<FinModel>();

  TagModel({
    this.id = 0,
    required this.tag,
  });
}
