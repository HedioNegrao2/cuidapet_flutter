import 'package:sqflite/sqflite.dart';

abstract class Migraion {
  void create(Batch batch);
  void update(Batch batch);
}