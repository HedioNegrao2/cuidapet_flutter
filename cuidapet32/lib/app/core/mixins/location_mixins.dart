import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

typedef  TryAgain = void Function(); 

mixin LocationMixins<E extends StatefulWidget>  on State<E> {

   void showDialogLocationsServiceUnaviaible() {
    showDialog(context: context, builder: (contextDialog) {
      return  AlertDialog(
        title: const Text('Serviço de localização indisponível'),
        content: const Text(
            'O serviço de localização está desativado, por favor ative para continuar'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(contextDialog).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(contextDialog).pop();
              Geolocator.openLocationSettings();
            },
            child: const Text('Abrir configurações'),
          )
        ],
      );
    });
  }
  void showDialogLocationsDenied(TryAgain? tryAgain) {
    showDialog(context: context, builder: (contextDialog) {
      return  AlertDialog(
        title: const Text('Precisamos de sua localização'),
        content: const Text(
            'Para realizar a busca da sua localização, precisamos que voce autoriza a atualização'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(contextDialog).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(contextDialog).pop();
              if (tryAgain != null) {
                tryAgain();
              }
              
            },
            child: const Text('Tentar novamente'),
          )
        ],
      );
    });
  }
  void showDialogLocationsDeniedForever() {
    showDialog(context: context, builder: (contextDialog) {
      return  AlertDialog(
        title: const Text('Precisamos de sua autorização'),
        content: const Text(
            'Para realizar a busca da sua localização, precisamos que voce autoriza a utilização, clique no botão configuraçoes'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(contextDialog).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(contextDialog).pop();
              Geolocator.openLocationSettings();              
            },
            child: const Text('Abrir configuraçoes'),
          )
        ],
      );
    });
  }

  
}