
import 'package:flutter/material.dart';
import 'package:asuka/asuka.dart';

class Loader {
  static OverlayEntry? _entry;
  static bool _open = false;

  Loader._();  

  static void show(){
    _entry ??= OverlayEntry(
      builder: (context) {
        return Container(
          color: Colors.black54,
          child:const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    );
    if(!_open){
      _open = true;
      Asuka.addOverlay(_entry!);
      
    }

  }
  static void hide(){
    _open = false;
    _entry?.remove();

  }


  
}