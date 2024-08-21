import 'package:cuidapet_api/entities/category.dart';
import 'package:cuidapet_api/modules/categories/data/i_categories_repository.dart';
import 'package:cuidapet_api/modules/categories/service/i_categories_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ICategoriesService)
class CategoriesService implements ICategoriesService {
  ICategoriesRepository repository;
  CategoriesService({
    required this.repository,
  });

  @override
  Future<List<Category>> findAll() => repository.findAll();
}
