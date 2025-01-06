import 'package:cuidapet32/app/core/ui/extension/size_screen_extension.dart';
import 'package:cuidapet32/app/core/ui/widgets/cuidapet_default_button.dart';
import 'package:cuidapet32/app/models/place_model.dart';
import 'package:cuidapet32/app/modules/address/address_detail/address_datail_conttroller.dart';
import 'package:flutter/material.dart';
import 'package:cuidapet32/app/core/ui/extension/theme_extension.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

class AddressDetailPage extends StatefulWidget {
  final PlaceModel place;

  const AddressDetailPage({super.key, required this.place});

  @override
  State<AddressDetailPage> createState() => _AddressDetailPageState();
}

class _AddressDetailPageState extends State<AddressDetailPage> {
  get initialCameraPosition => null;
  final _additionalController = TextEditingController();
  final controller = Modular.get<AddressDatailConttroller>();

  late final ReactionDisposer addressEntityDsiposer;

  @override
  void initState() {
    super.initState();
    addressEntityDsiposer =
        reaction((_) => controller.addressEntity, (addressEntity) {
      if (addressEntity != null) {
        Navigator.pop(context, addressEntity);
      }
    });
  }

  @override
  void dispose() {
    _additionalController.dispose();
    addressEntityDsiposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: context.primaryColor),
        elevation: 0,
      ),
      body: Column(
        children: [
          Text('Confirme seu endereço',
              style: context.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          SizedBox(height: 20),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.place.lat,
                    widget.place.lng,
                  ),
                  zoom: 16),
              markers: {
                Marker(
                  markerId: MarkerId('AddressID'),
                  position: LatLng(widget.place.lat, widget.place.lng),
                  infoWindow: InfoWindow(title: widget.place.address),
                ),
              },
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                initialValue: widget.place.address,
                readOnly: true,
                decoration:  InputDecoration(
                  labelText: 'Endereço',
                  // hintText: 'Endereço',
                  suffixIcon:
                      IconButton(onPressed: () {
                        Navigator.of(context).pop(widget.place);

                      }, icon: const Icon(Icons.edit)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: _additionalController,
                decoration: const InputDecoration(labelText: 'Complemento')),
          ),
          SizedBox(
              width: .95.sw,
              height: 60.h,
              child: CuidapetDefaultButton(
                  onPressed: () {
                    controller.saveAddress(
                        widget.place, _additionalController.text);
                  },
                  label: 'Salvar')),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
