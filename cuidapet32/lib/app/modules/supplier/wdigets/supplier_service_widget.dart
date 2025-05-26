import 'package:cuidapet32/app/core/helpers/text_formatter.dart';
import 'package:cuidapet32/app/core/ui/extension/theme_extension.dart';
import 'package:cuidapet32/app/models/supplier_services_model.dart';
import 'package:cuidapet32/app/modules/supplier/supplier_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SupplierServiceWidget extends StatelessWidget {
  final SupplierServicesModel service;
  final SupplierController supplerController;

  const SupplierServiceWidget({
    super.key,
    required this.service,
    required this.supplerController,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.pets),
        ),
        title: Text(service.name),
        subtitle: Text(TextFormatter.formatReal(service.price)),
        trailing: Observer(
          builder: (_) {
            return IconButton(
              onPressed: () {
                supplerController.addOrRemoveService(service);
              },
              icon: supplerController.isServiceSelected(service)
                  ? Icon(
                      Icons.remove_circle,
                      size: 30,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.add_circle,
                      size: 30,
                      color: context.primaryColor,
                    ),
            );
          },
        ));
  }
}
