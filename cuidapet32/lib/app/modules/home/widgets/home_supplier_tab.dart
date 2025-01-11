part of '../home_page.dart';

class _HomeSupplierTab extends StatelessWidget {
  final HomeController controller;

  const _HomeSupplierTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HomeTabHeader(controller: controller),
        Expanded(child: Observer(
          builder: (_) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              child:
                  controller.spplaierPageTypeSelected == SupplierPageType.list
                      ? _HomeSupplierList(homeController: controller)
                      : _HomeSupplierGrid(homeController: controller),
            );
          },
        ))
      ],
    );
  }
}

class _HomeTabHeader extends StatelessWidget {
  final HomeController controller;

  const _HomeTabHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          const Text('Estabelecientos'),
          const Spacer(),
          InkWell(
              onTap: () =>
                  controller.changeSupplierPageType(SupplierPageType.list),
              child: Observer(
                builder: (_) {
                  return Icon(
                    Icons.view_headline,
                    color: controller.spplaierPageTypeSelected ==
                            SupplierPageType.list
                        ? Colors.black
                        : Colors.grey,
                  );
                },
              )),
          InkWell(
              onTap: () =>
                  controller.changeSupplierPageType(SupplierPageType.grid),
              child: Observer(
                builder: (_) {
                  return Icon(
                    Icons.view_comfy,
                    color: controller.spplaierPageTypeSelected ==
                            SupplierPageType.grid
                        ? Colors.black
                        : Colors.grey,
                  );
                },
              )),
        ],
      ),
    );
  }
}

class _HomeSupplierList extends StatelessWidget {
  final HomeController homeController;

  const _HomeSupplierList({required this.homeController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        Observer(
          builder: (_) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final supplier = homeController.listSuppliersByAddress[index];
                  return _HomeSupplierListItemWidget(supplier: supplier);
                },
                childCount: homeController.listSuppliersByAddress.length,
              ),
            );
          },
        )
      ],
    );
  }
}

class _HomeSupplierListItemWidget extends StatelessWidget {
  final SupplierNearbyMeModel supplier;

  const _HomeSupplierListItemWidget({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30),
            width: 1.sw,
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          supplier.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                            ),
                            Text(
                                '${supplier.distance.toStringAsFixed(2)} km de dsitância'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: context.primaryColorDark,
                    maxRadius: 15,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 1),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[100]!,
                  width: 5,
                ),
                color: Colors.grey,
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: NetworkImage(supplier.logo),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _HomeSupplierGrid extends StatelessWidget {
  final HomeController homeController;

  const _HomeSupplierGrid({required this.homeController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        Observer(
            builder: (_) {
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: homeController.listSuppliersByAddress.length,
                    (context, index) {
                      final supplier = homeController.listSuppliersByAddress[index];
                      return _HomeSupplierCardGridItemWidget(supplier);
                    },
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                  ),
                );
            },
        )
      ],
    );
  }
}

class _HomeSupplierCardGridItemWidget extends StatelessWidget {
  final SupplierNearbyMeModel supplier;
  const _HomeSupplierCardGridItemWidget(this.supplier);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
          child: SizedBox.expand(
            
            child: Padding(
              padding: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(supplier.name,
                    style: context.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    ),
                  Text('${supplier.distance.toStringAsFixed(2)} km de distância',
                   
                   overflow: TextOverflow.ellipsis,),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[200],
          ),
        ),
        Positioned(
          top: 4,
          left: 0,
          right: 0,
          child: Center(
            child: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                supplier.logo,
              ),
                
              ),
          ),
        ),
        
        
      ],
    );
  }
}
