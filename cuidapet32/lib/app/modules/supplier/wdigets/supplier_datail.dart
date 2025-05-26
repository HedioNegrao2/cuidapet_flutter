import 'package:cuidapet32/app/core/ui/extension/theme_extension.dart';
import 'package:cuidapet32/app/models/supplier_model.dart';
import 'package:cuidapet32/app/modules/supplier/supplier_controller.dart';
import 'package:flutter/material.dart';

class SupplierDatail extends StatelessWidget {
  final SupplierModel supplier;
  final SupplierController controller;

  const SupplierDatail({super.key, required this.supplier, required this.controller}); 

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Center(
            child: Text(supplier.name,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,          
            ),
          ),
        ),
        Divider(
          color: context.primaryColor,
          thickness: 1,
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: 
        Text('Informações do estabelicimento',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,          
          ),
        ),
        ListTile(     
          onTap: () => controller.goToGeoOurCopyAdressToClipart(),     
          leading: Icon(Icons.location_city, 
            color: Colors.black,
          ),
          title: Text(supplier.address),
        ),
         ListTile(
          onTap: () =>  controller.goToPhoneOrCopyPhoneToClipboard(),
          leading: Icon(Icons.local_phone, 
            color: Colors.black,
          ),
          title: Text(supplier.phone),
        ),
          Divider(
          color: context.primaryColor,
          thickness: 1,
        ),
          
      ],
    );
  }
}
