part of '../home_page.dart';

class _HomeCategoryWidget extends StatelessWidget {
  final HomeController _controller;

  const _HomeCategoryWidget(this._controller);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Observer(
        builder: (_) {
          return Center(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _controller.listCategories.length,
              itemBuilder: (context, index) {
                final category = _controller.listCategories[index];
                return _CategoryItem(category, _controller);
              },
            ),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final SupplierCategoryModel _categoryModel;
  final HomeController _controller;

  static const categoriesIcons = {
    'P': Icons.pets,
    'V': Icons.local_hospital,
    'C': Icons.store_mall_directory,
  };

  const _CategoryItem(this._categoryModel, this._controller);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _controller.filterSuppliersCategory(_categoryModel);
      },
      child: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Observer(
              builder: (_) {
                return CircleAvatar(
                  radius: 30,
                  backgroundColor:
                      _controller.supplierCategoryFilterSelected?.id ==
                              _categoryModel.id
                          ? context.primaryColor
                          : context.primaryColorLight,
                  child: Icon(
                    categoriesIcons[_categoryModel.type],
                    color: Colors.black,
                    size: 30,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              _categoryModel.name,
              style: TextStyle(color: context.primaryColorDark),
            )
          ],
        ),
      ),
    );
  }
}
