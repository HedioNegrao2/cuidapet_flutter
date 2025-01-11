import 'package:cuidapet32/app/core/helpers/debuoncer.dart';
import 'package:cuidapet32/app/core/ui/extension/size_screen_extension.dart';
import 'package:cuidapet32/app/core/ui/extension/theme_extension.dart';
import 'package:cuidapet32/app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';

class HomeAppbar extends SliverAppBar {
   HomeAppbar(HomeController controller, {super.key})
      : super(
            expandedHeight: 100,
            collapsedHeight: 100,
            elevation: 0,
            flexibleSpace: _CuidapetAppBar(controller),
            iconTheme: const IconThemeData(color: Colors.black),
            pinned: true,
            );
}

class _CuidapetAppBar extends StatelessWidget {

  final _debuncer = Debuoncer(milliseconds: 500);

  final HomeController controller;


   _CuidapetAppBar(this.controller);

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: Colors.grey[200]!),
    );

    return AppBar(
      backgroundColor: Colors.grey[100],
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Text(
          'Cuidapet',
          style: TextStyle(color: context.primaryColorDark, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            controller.goToAddressPage();
          },
          icon: const Icon(Icons.location_on, color: Colors.black,),
        )
      ],
      elevation: 0,
      flexibleSpace: Stack(
        children: [
          Container(
            height: 110.h,
            color: context.primaryColor,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: .9.sw,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(30),
                child: TextFormField(
                  onChanged: (value) {
                    _debuncer.run(() {
                      controller.filterSupplierByName(value);
                    });
                    
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: Icon(
                        Icons.search,
                        size: 25,
                        color: Colors.grey,
                      ),
                      border: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      enabledBorder: outlineInputBorder),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
