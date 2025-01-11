import 'dart:async';
import 'package:cuidapet32/app/core/mixins/location_mixins.dart';
import 'package:cuidapet32/app/modules/address/widgets/address_controller.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:cuidapet32/app/core/database/sqlite_connection_factory.dart';
import 'package:cuidapet32/app/core/live_cycle/page_live_cycle_state.dart';
import 'package:cuidapet32/app/core/ui/extension/theme_extension.dart';
import 'package:cuidapet32/app/models/place_model.dart';
import 'package:cuidapet32/app/modules/address/widgets/address_seach_widget/address_seach_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';

part 'widgets/address_item.dart';
part 'widgets/address_seach_widget/address_search_widget.dart';

class AddresPage extends StatefulWidget {
  const AddresPage({super.key});

  @override
  State<AddresPage> createState() => _AddresPageState();
}

class _AddresPageState extends PageLiveCycleState<AddressController, AddresPage>
    with LocationMixins {
  final reactionDisposers = <ReactionDisposer>[];

  @override
  void initState() {
    super.initState();
    final reactonService =
        reaction<Observable<bool>>((_) => controller.locationServiceUnavailable,
            (locationServiceUnavailable) {
      if (locationServiceUnavailable.value) {
        showDialogLocationsServiceUnaviaible();
      }
    });
    final reactonPermission = reaction<Observable<LocationPermission>?>(
        (_) => controller.locationPermission, (locationPermission) {
      if (locationPermission != null &&
          locationPermission == LocationPermission.denied) {
        showDialogLocationsDenied(() => controller.myLocation());
      } else if (locationPermission != null &&
          locationPermission == LocationPermission.deniedForever) {
        showDialogLocationsDeniedForever();
      }
    });

    reactionDisposers.addAll([reactonService, reactonPermission]);
  }

  @override
  void dispose() {
    for (var reaction in reactionDisposers) {
      reaction();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Modular.get<SqliteConnectionFactory>().openConnection();
    return WillPopScope(     
      onWillPop: () => controller.addressWasSelectec(),        
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: context.primaryColorDark),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                Text(
                  'Adcione ou escolha um erdereço',
                  style: context.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Observer(
                  builder: (_) {
                    return _AddressSearchWidget(
                      key: UniqueKey(),
                      addresSelectedCallback: (place) {
                        controller.goToAddresDetail(place);
                      },
                      place: controller.placeModel,
                    );
                  },
                ),
                SizedBox(height: 30),
                ListTile(
                  onTap: controller.myLocation,
                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30,
                    child: Icon(
                      Icons.near_me,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    'localização atual',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                const SizedBox(
                  height: 20,
                ),
                Observer(
                  builder: (_) {
                    return Column(
                      children: controller.addresses
                          .map((e) => _AddressItem(                          
                              address: e.address, 
                              additional: e.additional,
                              onTap: () { controller.selectAddress(e);
                              },
                              ))
                          .toList(),
                    );
                  },
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
