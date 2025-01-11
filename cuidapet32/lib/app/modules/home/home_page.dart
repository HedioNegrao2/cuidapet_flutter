import 'package:cuidapet32/app/core/live_cycle/page_live_cycle_state.dart';
import 'package:cuidapet32/app/core/ui/extension/size_screen_extension.dart';
import 'package:cuidapet32/app/core/ui/extension/theme_extension.dart';
import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:cuidapet32/app/models/supplier_category_model.dart';
import 'package:cuidapet32/app/models/supplier_nearby_me_model.dart';
import 'package:cuidapet32/app/modules/home/home_controller.dart';
import 'package:cuidapet32/app/modules/home/widgets/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:path/path.dart';


part 'widgets/home_address_widget.dart';
part 'widgets/home_category_widget.dart';
part 'widgets/home_supplier_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends PageLiveCycleState<HomeController, HomePage> {
  AddressEntity? addressEnity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      backgroundColor: Colors.grey[100],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            HomeAppbar(controller),
            SliverToBoxAdapter(
              child: _HomeAddressWidget(controller: controller,),
            ),
            SliverToBoxAdapter(
              child: _HomeCategoryWidget(controller),
            ),
          ];
        },
        body: _HomeSupplierTab(controller: controller,)
      ),
    );
  }
}
